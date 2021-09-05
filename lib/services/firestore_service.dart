import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp_management/model/info.dart';
import 'package:gp_management/model/jurisdictions.dart';

class FirestoreService {
  var firestoreInstance = FirebaseFirestore.instance;

  Future<Info> getDataForJurisdiction(String jurisdiction) async {
    var firebaseDb =
        await firestoreInstance.collection('data').doc(jurisdiction).get();
    return infoFromJson(json.encode(firebaseDb.data()));
  }

  Future<Jurisdictions> getJurisdictionList() async {
    var firebaseDb = await firestoreInstance
        .collection('util')
        .doc('jurisdiction_data')
        .get();
    return jurisdictionsFromJson(json.encode(firebaseDb.data()));
  }

  // Add data
  Future<bool> addData(String jurisdiction, Datum datum) async {
    await firestoreInstance.collection('data').doc(jurisdiction).update({
      'data': FieldValue.arrayUnion([datum.toJson()])
    });
    return true;
  }

  // Edit data
  Future<bool> editData(String jurisdiction, Info infoList) async {
    await firestoreInstance
        .collection('data')
        .doc(jurisdiction)
        .update(infoList.toJson());
    return true;
  }

  Future<Map<String, dynamic>> searchInfo(String id, String location) async {
    try {
      Jurisdictions jurisdictions = await getJurisdictionList();
      String jurisdiction = jurisdictions.jurisdictions
          .firstWhere((element) => element.name == location)
          .jurisdiction;
      final firebaseDb =
          await firestoreInstance.collection('data').doc(jurisdiction).get();
      final dataList = infoFromJson(json.encode(firebaseDb.data()));
      bool found = false;
      Datum datum = dataList.data.firstWhere((element) {
        if (element.id == id) {
          found = true;
          return true;
        }
        return false;
      }, orElse: () => Datum());
      return {'found': found, 'data': datum.toJson()};
    } on Exception catch (_) {
      return {'found': false, 'data': Datum()};
    }
  }
}
