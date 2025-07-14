import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kliklaptop/data/model/request/admin/service_sparepart_request_model.dart';
import 'package:kliklaptop/data/model/response/service_sparepart_response_model.dart';
import 'package:kliklaptop/presentation/services/service_http_client.dart';

class ServiceSparepartRepository {
  final ServiceHttpClient _httpClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ServiceSparepartRepository(this._httpClient);

  /// Tambah banyak sparepart sekaligus ke service (bulk insert)
  Future<Either<String, ServiceSparepartResponseModel>> addMultipleSpareparts(
    List<ServiceSparepartRequestModel> dataList,
  ) async {
    try {
      final token = await _secureStorage.read(key: "authToken");
      final uri = Uri.parse("${_httpClient.baseUrl}service-spareparts/bulk");

      if (dataList.isEmpty) {
        return Left("Data tidak boleh kosong");
      }

      final body = dataList.map((e) => e.toMap()).toList();

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body), // langsung array (tanpa key 'items')
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final model = ServiceSparepartResponseModel.fromMap(decoded);
        return Right(model);
      } else {
        return Left(decoded['message'] ?? 'Gagal menambahkan sparepart');
      }
    } catch (e) {
      return Left("❌ Gagal mengirim sparepart: $e");
    }
  }

  /// Ambil semua sparepart berdasarkan service_by_admin_id
  Future<Either<String, List<Data>>> getSparepartsByServiceId(
    int serviceByAdminId,
  ) async {
    try {
      final token = await _secureStorage.read(key: "authToken");

      final uri = Uri.parse(
        "${_httpClient.baseUrl}service-spareparts/$serviceByAdminId",
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List list = decoded['data'] ?? [];

        final spareparts = list
            .map((item) => Data.fromMap(item['sparepart']))
            .toList();

        return Right(spareparts);
      } else {
        return Left(decoded['message'] ?? 'Gagal mengambil sparepart');
      }
    } catch (e) {
      return Left("❌ Gagal ambil sparepart: $e");
    }
  }
}
