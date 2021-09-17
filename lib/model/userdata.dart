// To parse this JSON data, do
//
//     final userData = userDataFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserData userDataFromMap(String str) => UserData.fromMap(json.decode(str));

String userDataToMap(UserData data) => json.encode(data.toMap());

class UserData {
  UserData({
    required this.jurisdiction,
    required this.name,
    required this.email,
    required this.superuser,
    required this.uid,
  });

  List<String> jurisdiction;
  String name;
  String email;
  String uid;
  bool superuser;

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
      jurisdiction: List<String>.from(json["jurisdiction"].map((x) => x)),
      name: json["name"],
      email: json["email"],
      superuser: json["superuser"],
      uid: json["uid"]);

  Map<String, dynamic> toMap() => {
        "jurisdiction": List<dynamic>.from(jurisdiction.map((x) => x)),
        "name": name,
        "email": email,
        "superuser": superuser,
        "uid": uid
      };
}
