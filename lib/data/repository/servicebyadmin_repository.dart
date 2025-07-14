import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kliklaptop/data/model/response/servicebyadmin_response_model.dart';
import 'package:kliklaptop/presentation/services/service_http_client.dart';

class ServiceByAdminRepository {
  final ServiceHttpClient _serviceHttpClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ServiceByAdminRepository(this._serviceHttpClient);

  /// POST: Tambah layanan dari admin
  Future<Either<String, ServiceByAdminResponseModel>> addServiceByAdmin({
    required DataServiceByAdmin servicebyadmin,
    File? buktiPembayaran,
  }) async {
    try {
      final token = await _secureStorage.read(key: 'authToken');
      final uri = Uri.parse(
        '${_serviceHttpClient.baseUrl}service-request/servicebyadmin',
      );

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['service_id'] = servicebyadmin.serviceId.toString()
        ..fields['nama_servis'] = servicebyadmin.namaServis ?? ''
        ..fields['biaya_servis'] = servicebyadmin.biayaServis?.toString() ?? ''
        ..fields['total_bayar'] = servicebyadmin.totalBiaya?.toString() ?? '';

      if (buktiPembayaran != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'bukti_pembayaran',
            buktiPembayaran.path,
          ),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final decoded = json.decode(responseBody);
        return Right(ServiceByAdminResponseModel.fromMap(decoded));
      } else {
        final error = json.decode(responseBody);
        return Left(error['message'] ?? 'Gagal menambahkan service');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  /// GET: Ambil semua service by admin
  Future<Either<String, List<DataServiceByAdmin>>>
  getAllServiceByAdmin() async {
    try {
      final token = await _secureStorage.read(key: 'authToken');
      final uri = Uri.parse(
        '${_serviceHttpClient.baseUrl}service-request/servicebyadmin',
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> dataList = decoded['data'];
        final List<DataServiceByAdmin> services = dataList
            .map((item) => DataServiceByAdmin.fromMap(item))
            .toList();
        return Right(services);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal mengambil data service');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }

  Future<Either<String, DataServiceByAdmin>>
  getServiceByAdminByServiceRequestId(int serviceRequestId) async {
    try {
      final response = await _serviceHttpClient.get(
        "service-request/servicebyadmin/by-service-id/$serviceRequestId",
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final service = DataServiceByAdmin.fromMap(decoded['data']);
        return Right(service);
      } else {
        final error = json.decode(response.body);
        return Left(
          error['message'] ?? 'Gagal mengambil detail service by admin',
        );
      }
    } catch (e) {
      return Left("Terjadi error saat mengambil detail: $e");
    }
  }

  Future<Either<String, ServiceByAdminResponseModel>>
  updatePembayaranServiceByAdmin({
    required int id, // ini adalah field `id`, bukan `service_id`
    int? totalBayar,
    File? buktiPembayaran,
  }) async {
    try {
      final token = await _secureStorage.read(key: 'authToken');
      final uri = Uri.parse(
        '${_serviceHttpClient.baseUrl}service-request/servicebyadmin/$id/updated',
      );

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json';

      if (totalBayar != null) {
        request.fields['total_bayar'] = totalBayar.toString();
      }

      if (buktiPembayaran != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'bukti_pembayaran',
            buktiPembayaran.path,
          ),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = json.decode(responseBody);
        return Right(ServiceByAdminResponseModel.fromMap(decoded));
      } else {
        final error = json.decode(responseBody);
        return Left(error['message'] ?? 'Gagal mengirim pembayaran');
      }
    } catch (e) {
      return Left('Terjadi kesalahan: $e');
    }
  }
}
