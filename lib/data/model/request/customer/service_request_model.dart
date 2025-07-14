import 'dart:convert';
import 'dart:io';

class ServiceRequestModel {
    final String? jenisLaptop;
    final String? deskripsiKeluhan;
    final File? photo;

    ServiceRequestModel({
        this.jenisLaptop,
        this.deskripsiKeluhan,
        this.photo,
    });

    factory ServiceRequestModel.fromJsonString(String str) => ServiceRequestModel.fromMap(json.decode(str));

    String toJsonString() => json.encode(toMap());

    factory ServiceRequestModel.fromMap(Map<String, dynamic> json) => ServiceRequestModel(
        jenisLaptop: json["jenis_laptop"],
        deskripsiKeluhan: json["deskripsi_keluhan"],
        photo: json["photo"],
    );

    Map<String, dynamic> toMap() => {
        "jenis_laptop": jenisLaptop,
        "deskripsi_keluhan": deskripsiKeluhan,
        "photo": photo,
    };

    Map<String, dynamic> toJson() => toMap();
}
