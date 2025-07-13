import 'dart:convert';

class ServiceByAdminResponseModel {
  final String? message;
  final int? statusCode;
  final DataServiceByAdmin? data;

  ServiceByAdminResponseModel({this.message, this.statusCode, this.data});

  factory ServiceByAdminResponseModel.fromJson(String str) =>
      ServiceByAdminResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ServiceByAdminResponseModel.fromMap(Map<String, dynamic> json) =>
      ServiceByAdminResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null
            ? null
            : DataServiceByAdmin.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "status_code": statusCode,
        "data": data?.toMap(),
      };
}

class DataServiceByAdmin {
  final int? serviceId;
  final String? namaServis;
  final int? biayaServis;
  final int? totalBiaya;
  final String? buktiPembayaran;
  final DateTime? createdAt;
  final int? id;

  final ServiceRequest? serviceRequest;
  final List<ServiceSparepart>? serviceSpareparts;

  DataServiceByAdmin({
    this.serviceId,
    this.namaServis,
    this.biayaServis,
    this.totalBiaya,
    this.buktiPembayaran,
    this.createdAt,
    this.id,
    this.serviceRequest,
    this.serviceSpareparts,
  });

  factory DataServiceByAdmin.fromMap(Map<String, dynamic> json) =>
      DataServiceByAdmin(
        serviceId: json["service_id"] is int
            ? json["service_id"]
            : int.tryParse(json["service_id"].toString()),
        namaServis: json["nama_servis"],
        biayaServis: json["biaya_servis"] is int
            ? json["biaya_servis"]
            : int.tryParse(json["biaya_servis"].toString()),
        totalBiaya: json["total_bayar"] is int
            ? json["total_bayar"]
            : int.tryParse(json["total_bayar"].toString()),
        buktiPembayaran: json["bukti_pembayaran"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
        serviceRequest: json["service_request"] != null
            ? ServiceRequest.fromMap(json["service_request"])
            : null,
        serviceSpareparts: json["service_spareparts"] != null
            ? List<ServiceSparepart>.from(
                json["service_spareparts"].map((x) => ServiceSparepart.fromMap(x)))
            : [],
      );

  Map<String, dynamic> toMap() => {
        "service_id": serviceId,
        "nama_servis": namaServis,
        "biaya_servis": biayaServis,
        "total_bayar": totalBiaya,
        "bukti_pembayaran": buktiPembayaran,
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "service_request": serviceRequest?.toMap(),
        "service_spareparts": serviceSpareparts?.map((x) => x.toMap()).toList(),
      };
}

class ServiceRequest {
  final int? id;
  final int? userId;
  final String? jenisLaptop;
  final String? deskripsiKeluhan;
  final String? photo;
  final String? status;
  final String? tanggalSelesai;
  final DateTime? createdAt;

  ServiceRequest({
    this.id,
    this.userId,
    this.jenisLaptop,
    this.deskripsiKeluhan,
    this.photo,
    this.status,
    this.tanggalSelesai,
    this.createdAt,
  });

  factory ServiceRequest.fromMap(Map<String, dynamic> json) => ServiceRequest(
        id: json["id"],
        userId: json["user_id"],
        jenisLaptop: json["jenis_laptop"],
        deskripsiKeluhan: json["deskripsi_keluhan"],
        photo: json["photo"],
        status: json["status"],
        tanggalSelesai: json["tanggal_selesai"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "jenis_laptop": jenisLaptop,
        "deskripsi_keluhan": deskripsiKeluhan,
        "photo": photo,
        "status": status,
        "tanggal_selesai": tanggalSelesai,
        "created_at": createdAt?.toIso8601String(),
      };
}

class ServiceSparepart {
  final int? id;
  final int? serviceByAdminId;
  final int? sparepartId;
  final Sparepart? sparepart;

  ServiceSparepart({
    this.id,
    this.serviceByAdminId,
    this.sparepartId,
    this.sparepart,
  });

  factory ServiceSparepart.fromMap(Map<String, dynamic> json) => ServiceSparepart(
        id: json["id"],
        serviceByAdminId: json["service_by_admin_id"],
        sparepartId: json["sparepart_id"],
        sparepart: json["sparepart"] != null
            ? Sparepart.fromMap(json["sparepart"])
            : null,
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "service_by_admin_id": serviceByAdminId,
        "sparepart_id": sparepartId,
        "sparepart": sparepart?.toMap(),
      };
}

class Sparepart {
  final int? id;
  final String? namaSparepart;
  final String? hargaSatuan;

  Sparepart({
    this.id,
    this.namaSparepart,
    this.hargaSatuan,
  });

  factory Sparepart.fromMap(Map<String, dynamic> json) => Sparepart(
        id: json["id"],
        namaSparepart: json["nama_sparepart"],
        hargaSatuan: json["harga_satuan"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nama_sparepart": namaSparepart,
        "harga_satuan": hargaSatuan,
      };
}
