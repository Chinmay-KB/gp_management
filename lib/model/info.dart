// To parse this JSON data, do
//
//     final info = infoFromJson(jsonString);

import 'dart:convert';

Info infoFromJson(String str) => Info.fromJson(json.decode(str));

String infoToJson(Info data) => json.encode(data.toJson());

class Info {
  Info({
    required this.data,
  });

  List<Datum> data;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum(
      {this.fileNumber,
      this.quantity,
      this.purpose,
      this.name,
      this.location,
      this.id,
      this.category,
      this.servicing,
      this.purchase});

  String? fileNumber;
  String? quantity;
  String? purpose;
  String? name;
  String? location;
  String? id;
  String? category;
  String? servicing;
  String? purchase;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      fileNumber: json["file_number"],
      quantity: json["quantity"],
      purpose: json["purpose"],
      name: json["name"],
      location: json["location"],
      id: json["id"],
      category: json["category"],
      servicing: json["servicing"],
      purchase: json["purchase"]);

  Map<String, dynamic> toJson() => {
        "file_number": fileNumber,
        "quantity": quantity,
        "purpose": purpose,
        "name": name,
        "location": location,
        "id": id,
        "category": category,
        "servicing": servicing,
        "purchase": purchase
      };
}
