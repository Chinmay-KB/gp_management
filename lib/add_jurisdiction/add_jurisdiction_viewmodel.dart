import 'package:flutter/cupertino.dart';
import 'package:gp_management/app.locator.dart';
import 'package:gp_management/model/jurisdictions.dart';
import 'package:gp_management/services/firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stringr/stringr.dart';

class AddJurisdictionViewModel extends BaseViewModel {
  final _firestoreService = locator<FirestoreService>();
  final _snackbarService = locator<SnackbarService>();
  final _navigatorService = locator<NavigationService>();
  TextEditingController textEditingController = TextEditingController();

  createNewJurisdiction() async {
    setBusy(true);
    if (textEditingController.text.isNotEmpty &&
        textEditingController.text != '') {
      await _firestoreService.createNewJurisdiction(
          jurisdiction: Jurisdiction(
              jurisdiction: textEditingController.text.snakeCase(),
              name: textEditingController.text));
      _navigatorService.back();
      _snackbarService.showSnackbar(message: 'Jurisdiction created');
    } else {
      _snackbarService.showSnackbar(message: 'Enter a valid name');
    }
    setBusy(false);
  }
}
