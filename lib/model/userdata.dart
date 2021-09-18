// To parse this JSON data, do
//
//     final userData = userDataFromMap(jsonString);

import 'package:gp_management/model/jurisdictions.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

UserData userDataFromMap(String str) => UserData.fromMap(json.decode(str));

String userDataToMap(UserData data) => json.encode(data.toMap());

class UserData {
  UserData(
      {this.jurisdictions,
      required this.email,
      required this.uid,
      required this.superuser,
      required this.name});

  List<Jurisdiction>? jurisdictions;
  String email;
  String uid;
  bool superuser;
  String name;

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
      jurisdictions: List<Jurisdiction>.from(
          json["jurisdictions"].map((x) => Jurisdiction.fromMap(x))),
      email: json["email"],
      uid: json["uid"],
      superuser: json["superuser"],
      name: json["name"]);

  Map<String, dynamic> toMap() => {
        "jurisdictions": jurisdictions != null
            ? List<dynamic>.from(jurisdictions!.map((x) => x.toMap()))
            : [],
        "email": email,
        "uid": uid,
        "superuser": superuser,
        "name": name
      };
}

// class Jurisdiction {
//     Jurisdiction({
//         required this.access,
//         required this.jurisdiction,
//         required this.name,
//     });

//     List<String> access;
//     String jurisdiction;
//     String name;

//     factory Jurisdiction.fromMap(Map<String, dynamic> json) => Jurisdiction(
//         access: List<String>.from(json["access"].map((x) => x)),
//         jurisdiction: json["jurisdiction"],
//         name: json["name"],
//     );

//     Map<String, dynamic> toMap() => {
//         "access": List<dynamic>.from(access.map((x) => x)),
//         "jurisdiction": jurisdiction,
//         "name": name,
//     };
// }
