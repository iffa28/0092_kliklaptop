import 'dart:convert';

class ServiceRequestResponseModel {
    final String? message;
    final int? statusCode;
    final Data? data;

    ServiceRequestResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

    factory ServiceRequestResponseModel.fromJson(String str) => ServiceRequestResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ServiceRequestResponseModel.fromMap(Map<String, dynamic> json) => ServiceRequestResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? null : Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "status_code": statusCode,
        "data": data?.toMap(),
    };
}

class Data {
    final int? id;
    final String? jenisLaptop;
    final String? deskripsiKeluhan;
    final String? photo;
    final String? status;
    final DateTime? createdAt;

    Data({
        this.id,
        this.jenisLaptop,
        this.deskripsiKeluhan,
        this.photo,
        this.status,
        this.createdAt,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        jenisLaptop: json["jenis_laptop"],
        deskripsiKeluhan: json["deskripsi_keluhan"],
        photo: json["photo"],
        status: json["status"],
        createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "jenis_laptop": jenisLaptop,
        "deskripsi_keluhan": deskripsiKeluhan,
        "photo": photo,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
    };
}
