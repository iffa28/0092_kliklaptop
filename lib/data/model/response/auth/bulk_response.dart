import 'dart:convert';

/// Model response untuk BULK insert sparepart ke service
class BulkSparepartResponseModel {
  final String? message;
  final int? statusCode;
  final int? successCount;
  final List<FailedItem>? failedItems;

  BulkSparepartResponseModel({
    this.message,
    this.statusCode,
    this.successCount,
    this.failedItems,
  });

  factory BulkSparepartResponseModel.fromJson(String str) =>
      BulkSparepartResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BulkSparepartResponseModel.fromMap(Map<String, dynamic> json) =>
      BulkSparepartResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        successCount: json["success_count"],
        failedItems: json["failed_items"] == null
            ? []
            : List<FailedItem>.from(
                json["failed_items"].map((x) => FailedItem.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "message": message,
        "status_code": statusCode,
        "success_count": successCount,
        "failed_items": failedItems?.map((x) => x.toMap()).toList(),
      };
}

class FailedItem {
  final int? index;
  final List<String>? errors;

  FailedItem({this.index, this.errors});

  factory FailedItem.fromMap(Map<String, dynamic> json) => FailedItem(
        index: json["index"],
        errors: json["errors"] == null
            ? []
            : List<String>.from(json["errors"]),
      );

  Map<String, dynamic> toMap() => {
        "index": index,
        "errors": errors,
      };
}
