import 'package:gp_management/model/userdata.dart';
import 'dart:convert';

Requests requestsFromMap(String str) => Requests.fromMap(json.decode(str));

String requestsToMap(Requests data) => json.encode(data.toMap());

class Requests {
  Requests({
    required this.requests,
  });

  List<Request> requests;

  factory Requests.fromMap(Map<String, dynamic> json) => Requests(
        requests:
            List<Request>.from(json["requests"].map((x) => Request.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "requests": List<dynamic>.from(requests.map((x) => x.toMap())),
      };
}

class Request {
  Request({
    required this.jurisdiction,
    required this.jurisdictionName,
    required this.user,
  });

  String jurisdiction;
  UserData user;
  String jurisdictionName;

  factory Request.fromMap(Map<String, dynamic> json) => Request(
        jurisdiction: json["jurisdiction"],
        jurisdictionName: json["jurisdiction_name"],
        user: UserData.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "jurisdiction": jurisdiction,
        "user": user.toMap(),
        "jurisdiction_name": jurisdictionName
      };
}
