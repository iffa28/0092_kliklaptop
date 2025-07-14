import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kliklaptop/data/model/response/transaksi_pembelian_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:kliklaptop/presentation/services/service_http_client.dart';

class TransaksiPembelianRepository {
  final ServiceHttpClient _serviceHttpClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  TransaksiPembelianRepository(this._serviceHttpClient);

  Future<Either<String, TransaksiPembelianResponseModel>>
  addTransaksiPembelian({required Data data,
    File? buktiPembayaran}) async {
    try {
      final token = await _secureStorage.read(key: "authToken");
      final uri = Uri.parse(
        "${_serviceHttpClient.baseUrl}transaction/add-transaction",
      );

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['product_id'] = data.productId.toString()
        ..fields['metode_pembayaran'] = data.metodePembayaran ?? '';

      if (buktiPembayaran != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'bukti_pembayaran',
            buktiPembayaran.path,
          ),
        );
      }

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 201) {
        final transactioResponse = TransaksiPembelianResponseModel.fromJson(
          responseBody
        );
        return Right(transactioResponse);
      } else {
        final error = json.decode(responseBody);
        return Left(error['message'] ?? 'Gagal menyimpan transaksi');
      }
    } catch (e) {
      return Left("Gagal mengirim transaksi: $e");
    }
  }

  Future<Either<String, List<Data>>> getAllTransactions() async {
    try {
      final response = await _serviceHttpClient.get("transaction");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<Data> transaksiList = (decoded['data'] as List)
            .map((item) => Data.fromMap(item))
            .toList();
        return Right(transaksiList);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal mengambil transaksi');
      }
    } catch (e) {
      return Left("Terjadi error saat mengambil transaksi: $e");
    }
  }

  // Ambil transaksi by ID
  Future<Either<String, Data>> getTransactionById(int id) async {
    try {
      final response = await _serviceHttpClient.get("transaction/$id");

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

  // Update transaksi
  Future<Either<String, TransaksiPembelianResponseModel>> updateTransaksiPembelian({
    required Data data,
    File? buktiPembayaran,
  }) async {
    try {
      final token = await _secureStorage.read(key: "authToken");
      final uri = Uri.parse("${_serviceHttpClient.baseUrl}transaction/$id");

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['_method'] = 'PUT';

      if (data.productId != null) {
        request.fields['product_id'] = data.productId.toString();
      }

      if (data.metodePembayaran != null) {
        request.fields['metode_pembayaran'] = data.metodePembayaran!;
      }

      if (data.status != null) {
        request.fields['status'] = data.status!;
      }


      if (buktiPembayaran != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'bukti_pembayaran',
          buktiPembayaran.path,
        ));
      }

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        final response = TransaksiPembelianResponseModel.fromJson(responseBody);
        return Right(response);
      } else {
        final error = json.decode(responseBody);
        return Left(error['message'] ?? 'Gagal memperbarui transaksi');
      }
    } catch (e) {
      return Left("Gagal update transaksi: $e");
    }
  }

  // Hapus transaksi
  Future<Either<String, String>> deleteTransaksi(int id) async {
    try {
      final token = await _secureStorage.read(key: "authToken");
      final uri = Uri.parse("${_serviceHttpClient.baseUrl}transaction/$id/delete");

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

}
