import 'dart:convert';

class TransaksiPembelianRequestModel {
    final int? productId;
    final String? metodePembayaran;
    final String? buktiPembayaran;

    TransaksiPembelianRequestModel({
        this.productId,
        this.metodePembayaran,
        this.buktiPembayaran,
    });

    factory TransaksiPembelianRequestModel.fromJsonString(String str) => TransaksiPembelianRequestModel.fromMap(json.decode(str));

    String toJsonString() => json.encode(toMap());

    factory TransaksiPembelianRequestModel.fromMap(Map<String, dynamic> json) => TransaksiPembelianRequestModel(
        productId: json["product_id"],
        metodePembayaran: json["metode_pembayaran"],
        buktiPembayaran: json["bukti_pembayaran"],
    );

    Map<String, dynamic> toMap() => {
        "product_id": productId,
        "metode_pembayaran": metodePembayaran,
        "bukti_pembayaran": buktiPembayaran,
    };

    Map<String, dynamic> toJson() => toMap();
}
