import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kliklaptop/data/model/request/customer/service_request_model.dart';
import 'package:kliklaptop/data/model/response/servicerequest_response_model.dart';
import 'package:kliklaptop/presentation/services/service_http_client.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';

class ServiceRequestRepository {
  final ServiceHttpClient _serviceHttpClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ServiceRequestRepository(this._serviceHttpClient);

  /// Tambah permintaan service
  Future<Either<String, ServiceRequestResponseModel>> addServiceRequest({
    required Data dataServiceReq,
    File? photoFile,
  }) async {
    try {
      final token = await _secureStorage.read(key: "authToken");
      final uri = Uri.parse(
        "${_serviceHttpClient.baseUrl}service-request/create",
      );

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['jenis_laptop'] = dataServiceReq.jenisLaptop ?? ''
        ..fields['deskripsi_keluhan'] = dataServiceReq.deskripsiKeluhan ?? '';

      if (photoFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo', photoFile.path),
        );
      }

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 201) {
        final jsonResponse = json.decode(responseBody);
        final data = ServiceRequestResponseModel.fromMap(jsonResponse['data']);
        return Right(data);
      } else {
        final error = json.decode(responseBody);
        return Left(error['message'] ?? 'Terjadi kesalahan saat mengirim');
      }
    } catch (e) {
      return Left('Gagal mengirim request: $e');
    }
  }

  /// Ambil semua permintaan service milik user
  Future<Either<String, List<Data>>> getAllServiceRequests() async {
    try {
      final response = await _serviceHttpClient.get("service-request");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<Data> serviceList = (decoded['data'] as List)
            .map((item) => Data.fromMap(item))
            .toList();
        return Right(serviceList);
      } else {
        final errorMessage = json.decode(response.body);
        return Left(errorMessage['message'] ?? 'Gagal mengambil data service');
      }
    } catch (e) {
      return Left("Terjadi kesalahan saat mengambil data: $e");
    }
  }

  // Hapus transaksi
  Future<Either<String, String>> deleteService(int id) async {
    try {
      final token = await _secureStorage.read(key: "authToken");
      final uri = Uri.parse(
        "${_serviceHttpClient.baseUrl}transaction/$id/delete",
      );

      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return Right(decoded['message'] ?? 'Transaksi berhasil dihapus');
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal menghapus transaksi');
      }
    } catch (e) {
      return Left("Terjadi error saat menghapus transaksi: $e");
    }
  }

  // Ambil transaksi by ID
  Future<Either<String, Data>> getServiceRequestsById(int id) async {
    try {
      final response = await _serviceHttpClient.get("service-request/$id");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final Data transaksi = Data.fromMap(decoded['data']);
        return Right(transaksi);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal mengambil detail transaksi');
      }
    } catch (e) {
      return Left("Terjadi error saat mengambil detail transaksi: $e");
    }
  }

  /// Ambil riwayat permintaan service dengan status 'perbaikan selesai'
  Future<Either<String, List<Data>>> getHistoryService() async {
    try {
      final response = await _serviceHttpClient.get(
        "service-request/history/all",
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<Data> historyList = (decoded['data'] as List)
            .map((item) => Data.fromMap(item))
            .toList();
        return Right(historyList);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal mengambil data history');
      }
    } catch (e) {
      return Left("Terjadi kesalahan saat mengambil history: $e");
    }
  }

  /// Ambil semua permintaan service milik user yang belum selesai
  Future<Either<String, List<Data>>> getActiveServiceRequestsByUser() async {
    try {
      final response = await _serviceHttpClient.get("service-request/active");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<Data> list = (decoded['data'] as List)
            .map((item) => Data.fromMap(item))
            .toList();
        return Right(list);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal mengambil data service aktif');
      }
    } catch (e) {
      return Left("Terjadi kesalahan saat mengambil data aktif: $e");
    }
  }
}
