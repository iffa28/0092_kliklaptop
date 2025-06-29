import 'dart:convert';

class RegisterRequest {
    final String? username;
    final String? email;
    final String? password;

    RegisterRequest({
        this.username,
        this.email,
        this.password,
    });

    factory RegisterRequest.fromJson(String str) => RegisterRequest.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory RegisterRequest.fromMap(Map<String, dynamic> json) => RegisterRequest(
        username: json["username"],
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toMap() => {
        "username": username,
        "email": email,
        "password": password,
    };
}
