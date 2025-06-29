import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kliklaptop/data/model/request/auth/login_request.dart';
import 'package:kliklaptop/data/model/request/auth/register_request.dart';
import 'package:kliklaptop/data/model/response/auth/auth_response.dart';
import 'package:kliklaptop/presentation/services/service_http_client.dart';

class AuthRepository {
  final ServiceHttpClient _serviceHttpClient;
  final secureStorage = FlutterSecureStorage();

  AuthRepository(this._serviceHttpClient);

  /// Login
  Future<Either<String, AuthResponse>> login(
    LoginRequest model,
  ) async {
    try {
      final response = await _serviceHttpClient.post('login', model.toMap());

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final loginResponse = AuthResponse.fromMap(jsonResponse);
        await secureStorage.write(
          key: "authToken",
          value: loginResponse.user!.token,
        );
        await secureStorage.write(
          key: "userRole",
          value: loginResponse.user!.role,
        );
        log("Login successful: ${loginResponse.message}");
        return Right(loginResponse);
      } else {
        log("Login failed: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Login failed");
      }
    } catch (e) {
      log("Error in login: $e");
      return Left("An error occurred while logging in.");
    }
  }

    // Register
    Future<Either<String, String>> register(
      RegisterRequest requestModel,
    ) async {
      try {
        final response = await _serviceHttpClient.post(
          "register",
          requestModel.toMap(),
        );
        final jsonResponse = json.decode(response.body);
        if (response.statusCode == 201) {
          final registerResponse = jsonResponse['message'] as String;
          log("Registration successful: $registerResponse");
          return Right(registerResponse);
        } else {
          log("Registration failed: ${jsonResponse['message']}");
          return Left(jsonResponse['message'] ?? "Registration failed");
        }
      } catch (e) {
        log("Error in registration: $e");
        return Left("An error occurred while registering.");
      }
    }
  
}
