import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp_management/model/info.dart';
import 'package:gp_management/model/jurisdictions.dart';
import 'package:gp_management/model/requests.dart';
import 'package:gp_management/model/userdata.dart';

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

  /// Check if the user exists on the database or not.
  Future<bool> checkUserExists(String uid) async {
    final _doc = await firestoreInstance.collection('users').doc(uid).get();
    return _doc.exists;
  }

  /// Creates a new user document for a new user
  Future<void> createNewUser(
      {required String uid, required UserData userData}) async {
    await firestoreInstance
        .collection('users')
        .withConverter<UserData>(
            fromFirestore: (snapshot, _) => UserData.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .doc(uid)
        .set(userData);
  }

  /// Creates a new user document for a new user
  Future<DocumentSnapshot<UserData>> getUserData({required String uid}) async =>
      firestoreInstance
          .collection('users')
          .withConverter<UserData>(
              fromFirestore: (snapshot, _) =>
                  UserData.fromMap(snapshot.data()!),
              toFirestore: (model, _) => model.toMap())
          .doc(uid)
          .get();

  Future<void> createNewRequest({required Request request}) async {
    await firestoreInstance
        .collection('users')
        .withConverter<Requests>(
            fromFirestore: (snapshot, _) => Requests.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .doc('pending_requests')
        .update(
      {
        "requests": FieldValue.arrayUnion(
          [request.toMap()],
        ),
      },
    );
  }

  Future<void> removePendingRequest({required Request request}) async {
    await firestoreInstance
        .collection('users')
        .withConverter<Requests>(
            fromFirestore: (snapshot, _) => Requests.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .doc('pending_requests')
        .update(
      {
        "requests": FieldValue.arrayRemove(
          [request.toMap()],
        ),
      },
    );
  }

  /// Creates a new user document for a new user
  Future<void> acceptUserRequest(
      {required String uid, required String jurisdiction}) async {
    await firestoreInstance
        .collection('users')
        .withConverter<UserData>(
            fromFirestore: (snapshot, _) => UserData.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .doc(uid)
        .update({
      'jurisdiction': FieldValue.arrayUnion([jurisdiction])
    });
  }
}
