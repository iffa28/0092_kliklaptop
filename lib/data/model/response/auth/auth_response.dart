import 'dart:convert';

class AuthResponse {
    final String? message;
    final int? statusCode;
    final User? user;

    AuthResponse({
        this.message,
        this.statusCode,
        this.user,
    });

    factory AuthResponse.fromJson(String str) => AuthResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory AuthResponse.fromMap(Map<String, dynamic> json) => AuthResponse(
        message: json["message"],
        statusCode: json["status_code"],
        user: json["data"] == null ? null : User.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "status_code": statusCode,
        "data": user?.toMap(),
    };
}

class User {
    final int? id;
    final String? name;
    final String? email;
    final String? role;
    final String? token;

    User({
        this.id,
        this.name,
        this.email,
        this.role,
        this.token,
    });

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        token: json["token"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "token": token,
    };
}
