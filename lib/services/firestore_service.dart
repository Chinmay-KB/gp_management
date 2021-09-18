import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp_management/model/info.dart';
import 'package:gp_management/model/jurisdictions.dart';
import 'package:gp_management/model/requests.dart';
import 'package:gp_management/model/userdata.dart';

class FirestoreService {
  var firestoreInstance = FirebaseFirestore.instance;
  final COLLECTION_DATA = 'data';
  final COLLECTION_REQUESTS = 'requests';
  final COLLECTION_UTIL = 'util';
  final COLLECTION_USERS = 'users';

  final DOC_PENDING_REQ = 'pending_requests';
  final DOC_JURISDICTION_DATA = 'jurisdiction_data';

  Future<Info> getDataForJurisdiction(String jurisdiction) async {
    var firebaseDb = await firestoreInstance
        .collection(COLLECTION_DATA)
        .doc(jurisdiction)
        .get();
    return infoFromJson(json.encode(firebaseDb.data()));
  }

  Future<Jurisdictions> getJurisdictionList() async {
    var firebaseDb = await firestoreInstance
        .collection(COLLECTION_UTIL)
        .doc(DOC_JURISDICTION_DATA)
        .get();
    return jurisdictionsFromJson(json.encode(firebaseDb.data()));
  }

  // Add data
  Future<bool> addData(String jurisdiction, Datum datum) async {
    await firestoreInstance
        .collection(COLLECTION_DATA)
        .doc(jurisdiction)
        .update({
      COLLECTION_DATA: FieldValue.arrayUnion([datum.toJson()])
    });
    return true;
  }

  // Edit data
  Future<bool> editData(String jurisdiction, Info infoList) async {
    await firestoreInstance
        .collection(COLLECTION_DATA)
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
      final firebaseDb = await firestoreInstance
          .collection(COLLECTION_DATA)
          .doc(jurisdiction)
          .get();
      final dataList = infoFromJson(json.encode(firebaseDb.data()));
      bool found = false;
      Datum datum = dataList.data.firstWhere((element) {
        if (element.id == id) {
          found = true;
          return true;
        }
        return false;
      }, orElse: () => Datum());
      return {'found': found, COLLECTION_DATA: datum.toJson()};
    } on Exception catch (_) {
      return {'found': false, COLLECTION_DATA: Datum()};
    }
  }

  /// Check if the user exists on the database or not.
  Future<bool> checkUserExists(String uid) async {
    final _doc =
        await firestoreInstance.collection(COLLECTION_USERS).doc(uid).get();
    return _doc.exists;
  }

  /// Creates a new user document for a new user
  Future<void> createNewUser(
      {required String uid, required UserData userData}) async {
    await firestoreInstance
        .collection(COLLECTION_USERS)
        .withConverter<UserData>(
            fromFirestore: (snapshot, _) => UserData.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .doc(uid)
        .set(userData);
  }

  /// Creates a new user document for a new user
  Future<DocumentSnapshot<UserData>> getUserData({required String uid}) async =>
      firestoreInstance
          .collection(COLLECTION_USERS)
          .withConverter<UserData>(
              fromFirestore: (snapshot, _) =>
                  UserData.fromMap(snapshot.data()!),
              toFirestore: (model, _) => model.toMap())
          .doc(uid)
          .get();

  Future<void> createNewRequest({required List<Request> requests}) async {
    List<Map<String, dynamic>> requestMap = [];
    requests.forEach((element) {
      requestMap.add(element.toMap());
    });
    await firestoreInstance
        .collection(COLLECTION_REQUESTS)
        .withConverter<Requests>(
            fromFirestore: (snapshot, _) => Requests.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .doc(DOC_PENDING_REQ)
        .update(
      {
        "requests": FieldValue.arrayUnion(
          requestMap,
        ),
      },
    );
  }

  Future<void> removePendingRequest({required List<Request> requests}) async {
    List<Map<String, dynamic>> requestMap = [];
    requests.forEach((element) {
      requestMap.add(element.toMap());
    });
    await firestoreInstance
        .collection(COLLECTION_REQUESTS)
        .withConverter<Requests>(
            fromFirestore: (snapshot, _) => Requests.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .doc(DOC_PENDING_REQ)
        .update(
      {
        "requests": FieldValue.arrayRemove(
          requestMap,
        ),
      },
    );
  }

  Future<DocumentSnapshot<Requests>> fetchPendingRequests() async =>
      await firestoreInstance
          .collection(COLLECTION_REQUESTS)
          .withConverter<Requests>(
              fromFirestore: (snapshot, _) =>
                  Requests.fromMap(snapshot.data()!),
              toFirestore: (model, _) => model.toMap())
          .doc(DOC_PENDING_REQ)
          .get();

  /// Creates a new user document for a new user
  Future<void> acceptUserRequest(
      {required String uid, required Jurisdiction jurisdiction}) async {
    await firestoreInstance
        .collection(COLLECTION_USERS)
        .withConverter<UserData>(
            fromFirestore: (snapshot, _) => UserData.fromMap(snapshot.data()!),
            toFirestore: (model, _) => model.toMap())
        .doc(uid)
        .update({
      'jurisdictions': FieldValue.arrayUnion([jurisdiction.toMap()])
    });
  }
}
