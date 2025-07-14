import 'dart:convert';

/// Model response untuk SINGLE insert sparepart ke service
class ServiceSparepartResponseModel {
  final String? message;
  final int? statusCode;
  final Data? data;

  ServiceSparepartResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory ServiceSparepartResponseModel.fromJson(String str) =>
      ServiceSparepartResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ServiceSparepartResponseModel.fromMap(Map<String, dynamic> json) =>
      ServiceSparepartResponseModel(
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
  final int? serviceByAdminId;
  final int? sparepartId;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  Data({
    this.serviceByAdminId,
    this.sparepartId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        serviceByAdminId: json["service_by_admin_id"],
        sparepartId: json["sparepart_id"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "service_by_admin_id": serviceByAdminId,
        "sparepart_id": sparepartId,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}
