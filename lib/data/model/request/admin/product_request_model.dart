import 'dart:convert';
import 'dart:io';

class ProductRequestModel {
  final String? namaProduk;
  final String? deskripsi;
  final int? harga;
  final int? stok;
  final File? fotoProduk;

  ProductRequestModel({
    this.namaProduk,
    this.deskripsi,
    this.harga,
    this.stok,
    this.fotoProduk,
  });

  factory ProductRequestModel.fromJsonString(String str) =>
      ProductRequestModel.fromMap(json.decode(str));

  String toJsonString() => json.encode(toMap());

  factory ProductRequestModel.fromMap(Map<String, dynamic> json) =>
      ProductRequestModel(
        namaProduk: json["nama_produk"],
        deskripsi: json["deskripsi"],
        harga: json["harga"] is int
            ? json["harga"]
            : int.tryParse(json["harga"].toString()),
        stok: json["stok"],
        fotoProduk: null,
      );

  Map<String, dynamic> toMap() => {
    "nama_produk": namaProduk,
    "deskripsi": deskripsi,
    "harga": harga,
    "stok": stok,
    "foto_produk": fotoProduk,
  };

  Map<String, dynamic> toJson() => toMap();
}
