import 'dart:convert';

import 'package:gp_management/app.locator.dart';
import 'package:gp_management/model/info.dart';
import 'package:gp_management/services/firestore_service.dart';
import 'package:stacked/stacked.dart';

class QrViewModel extends BaseViewModel {
  final firestoreService = locator<FirestoreService>();
  late final Datum? data;

  init(String code) async {
    setBusy(true);
    try {
      var scanData = code.split('`');
      var result = await firestoreService.searchInfo(scanData[0], scanData[1]);
      if (result['found']) {
        data = Datum.fromJson(result['data']);
      } else
        data = null;
    } on Exception catch (_) {
      data = null;
      print("Exception caught");
      setBusy(false);
    }

    setBusy(false);
  }
}
