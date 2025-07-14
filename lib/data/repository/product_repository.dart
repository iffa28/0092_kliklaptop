import 'dart:convert';
import 'dart:io';
import 'package:kliklaptop/data/model/request/admin/product_request_model.dart';
import 'package:kliklaptop/data/model/response/product_response_model.dart';
import 'package:kliklaptop/presentation/services/service_http_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';

class ProductRepository {
  final ServiceHttpClient _httpClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ProductRepository(this._httpClient);

  /// Menambahkan produk
  Future<Either<String, ProductResponseModel>> addProduct({
    required Data data,
    File? photoFile,
  }) async {
    try {
      final token = await _secureStorage.read(key: "authToken");
      final uri = Uri.parse("${_httpClient.baseUrl}admin/product/add-product");

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['nama_produk'] = data.namaProduk ?? ''
        ..fields['deskripsi'] = data.deskripsi ?? ''
        ..fields['stok'] = data.stok?.toString() ?? ''
        ..fields['harga'] = data.harga?.toString() ?? '';

      if (photoFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('foto_produk', photoFile.path),
        );
      }

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 201) {
        final productResponse = ProductResponseModel.fromJson(responseBody);
        return Right(productResponse);
      } else {
        final error = json.decode(responseBody);
        return Left(error['message'] ?? 'Gagal menyimpan produk');
      }
    } catch (e) {
      return Left("Gagal mengirim produk: $e");
    }
  }

  Future<Either<String, List<Data>>> getAllProducts() async {
    try {
      // ambil role yang sudah disimpan saat login
      final role = await _secureStorage.read(key: 'userRole');
      final isAdmin = role?.toLowerCase() == 'admin';

      final path = isAdmin ? "admin/product" : "product";
      final response = await _httpClient.get(path);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<Data> products = (decoded['data'] as List)
            .map((item) => Data.fromMap(item))
            .toList();
        return Right(products);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal mengambil produk');
      }
    } catch (e) {
      return Left("Terjadi error saat mengambil produk: $e");
    }
  }

  /// Mengambil produk berdasarkan ID
  Future<Either<String, ProductResponseModel>> getProductById(int id) async {
    try {
      final response = await _httpClient.get("admin/product/$id");

      if (response.statusCode == 200) {
        final productResponse = ProductResponseModel.fromJson(response.body);
        return Right(productResponse);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal mengambil data produk');
      }
    } catch (e) {
      return Left("Terjadi error saat mengambil produk: $e");
    }
  }

  // Update produk
  Future<Either<String, ProductResponseModel>> updateProduct({
    required Data productData,
    File? photoFile,
  }) async {
    try {
      final token = await _secureStorage.read(key: "authToken");
      final uri = Uri.parse(
        "${_httpClient.baseUrl}admin/product/update/$id",
      );

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['_method'] = 'PUT'
        ..fields['nama_produk'] = productData.namaProduk ?? ''
        ..fields['deskripsi'] = productData.deskripsi ?? ''
        ..fields['stok'] = productData.stok?.toString() ?? ''
        ..fields['harga'] = productData.harga?.toString() ?? '';

      if (photoFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('foto_produk', photoFile.path),
        );
      }

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        final result = ProductResponseModel.fromJson(responseBody);
        return Right(result);
      } else {
        final error = json.decode(responseBody);
        return Left(error['message'] ?? 'Gagal memperbarui produk');
      }
    } catch (e) {
      return Left("Gagal update produk: $e");
    }
  }

  // Hapus produk
  Future<Either<String, ProductResponseModel>> deleteProduct(int id) async {
    try {
      final token = await _secureStorage.read(key: "authToken");
      final uri = Uri.parse("${_httpClient.baseUrl}admin/product/$id/delete");

      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final result = ProductResponseModel.fromJson(response.body);
        return Right(result);
      } else {
        final error = json.decode(response.body);
        return Left(error['message'] ?? 'Gagal menghapus produk');
      }
    } catch (e) {
      return Left("Terjadi error saat menghapus produk: $e");
    }
  }
}
