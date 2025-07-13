import 'dart:convert';

class TransaksiPembelianResponseModel {
  final String? message;
  final int? statusCode;
  final Data? data;

  TransaksiPembelianResponseModel({this.message, this.statusCode, this.data});

  factory TransaksiPembelianResponseModel.fromJson(String str) =>
      TransaksiPembelianResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransaksiPembelianResponseModel.fromMap(Map<String, dynamic> json) =>
      TransaksiPembelianResponseModel(
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
  final int? productId;
  final int? userId;
  final String? namaUser;
  final String? namaProduk;
  final String? metodePembayaran;
  final String? status;
  final String? buktiPembayaran;
  final DateTime? createdAt;

  Data({
    this.id,
    this.productId,
    this.userId,
    this.namaUser,
    this.namaProduk,
    this.metodePembayaran,
    this.status,
    this.buktiPembayaran,
    this.createdAt,
  });

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    productId: json["product_id"],
    userId: json["user_id"],
    namaUser: json["nama_user"]?.toString(),
    namaProduk: json["nama_produk"]?.toString(),
    metodePembayaran: json["metode_pembayaran"],
    status: json["status"],
    buktiPembayaran: json["bukti_pembayaran"],
    id: json["id"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toMap() => {
    "product_id": productId,
    "user_id": userId,
    "nama_user": namaUser,
    "nama_produk": namaProduk,
    "metode_pembayaran": metodePembayaran,
    "status": status,
    "bukti_pembayaran": buktiPembayaran,
    "id": id,
    "created_at": createdAt?.toIso8601String(),
  };
}
