// To parse this JSON data, do
//
//     final jurisdictions = jurisdictionsFromJson(jsonString);

import 'dart:convert';

Jurisdictions jurisdictionsFromJson(String str) =>
    Jurisdictions.fromJson(json.decode(str));

String jurisdictionsToJson(Jurisdictions data) => json.encode(data.toJson());

class Jurisdictions {
  Jurisdictions({
    required this.jurisdictions,
  });

  List<Jurisdiction> jurisdictions;

  factory Jurisdictions.fromJson(Map<String, dynamic> json) => Jurisdictions(
        jurisdictions: List<Jurisdiction>.from(
            json["jurisdictions"].map((x) => Jurisdiction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "jurisdictions":
            List<dynamic>.from(jurisdictions.map((x) => x.toJson())),
      };
}

class Jurisdiction {
  Jurisdiction({this.access, required this.jurisdiction, required this.name});

  List<String>? access;
  String jurisdiction;
  String name;

  factory Jurisdiction.fromJson(Map<String, dynamic> json) => Jurisdiction(
      access: List<String>.from(json["access"].map((x) => x)),
      jurisdiction: json["jurisdiction"],
      name: json["name"]);

  Map<String, dynamic> toJson() => {
        "access": List<dynamic>.from(access!.map((x) => x)),
        "jurisdiction": jurisdiction,
        "name": name
      };

  factory Jurisdiction.fromMap(Map<String, dynamic> json) => Jurisdiction(
        access: List<String>.from(json["access"].map((x) => x)),
        jurisdiction: json["jurisdiction"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "access": List<dynamic>.from(access!.map((x) => x)),
        "jurisdiction": jurisdiction,
        "name": name,
      };
}
