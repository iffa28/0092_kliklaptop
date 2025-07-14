import 'dart:convert';

class ServiceSparepartRequestModel {
    final int? serviceByAdminId;
    final int? sparepartId;

    ServiceSparepartRequestModel({
        this.serviceByAdminId,
        this.sparepartId,
    });

    factory ServiceSparepartRequestModel.fromJson(String str) => ServiceSparepartRequestModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ServiceSparepartRequestModel.fromMap(Map<String, dynamic> json) => ServiceSparepartRequestModel(
        serviceByAdminId: json["service_by_admin_id"],
        sparepartId: json["sparepart_id"],
    );

    Map<String, dynamic> toMap() => {
        "service_by_admin_id": serviceByAdminId,
        "sparepart_id": sparepartId,
    };
}
