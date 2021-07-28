import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp_management/model/info.dart';
import 'package:gp_management/model/jurisdictions.dart';

class FirestoreService {
  var firestoreInstance = FirebaseFirestore.instance;

  // Add data
  Future getData() async {
    var firebaseDb1 = await firestoreInstance
        .collection('util')
        .doc('jurisdiction_data')
        .get();
    var firebaseDb2 =
        await firestoreInstance.collection('data').doc('ps_seppa').get();
    print(json.encode(firebaseDb1.data()));
    print(json.encode(firebaseDb2.data()));
    return firebaseDb1.data();
  }

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
        .update({'data': infoList.toJson()});
    return true;
  }
}
