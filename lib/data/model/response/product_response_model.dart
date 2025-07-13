import 'dart:convert';

class ProductResponseModel {
    final String? message;
    final int? statusCode;
    final Data? data;

    ProductResponseModel({
        this.message,
        this.statusCode,
        this.data,
    });

    factory ProductResponseModel.fromJson(String str) => ProductResponseModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProductResponseModel.fromMap(Map<String, dynamic> json) => ProductResponseModel(
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
    final String? namaProduk;
    final String? deskripsi;
    final int? stok;
    final int? harga;
    final String? fotoProduk;

    Data({
        this.id,
        this.namaProduk,
        this.deskripsi,
        this.stok,
        this.harga,
        this.fotoProduk,
    });

    factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        id: json["id"],
        namaProduk: json["nama_produk"],
        deskripsi: json["deskripsi"],
        stok: json["stok"] is int ? json["stok"] : int.tryParse(json["stok"].toString()),
        harga: json["harga"] is int ? json["harga"] : int.tryParse(json["harga"].toString()),
        fotoProduk: json["photo"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nama_produk": namaProduk,
        "deskripsi": deskripsi,
        "stok": stok,
        "harga": harga,
        "photo": fotoProduk,
    };
}
