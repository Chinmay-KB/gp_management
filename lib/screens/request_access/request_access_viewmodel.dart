import 'dart:developer';

import 'package:gp_management/app.locator.dart';
import 'package:gp_management/model/jurisdictions.dart';
import 'package:gp_management/model/requests.dart';
import 'package:gp_management/model/userdata.dart';
import 'package:gp_management/services/firestore_service.dart';
import 'package:gp_management/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class RequestAccessViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _firestoreService = locator<FirestoreService>();
  final _navigatorService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  List<JurisdictionPick> locations = [];
  String loadingMessage = "";

  init() async {
    setBusy(true);
    final _allJurisdictions = await _firestoreService.getJurisdictionList();
    final _userAllowedJurisdictions = _userService.userData!.jurisdictions;
    _allJurisdictions.jurisdictions.forEach((allElement) {
      bool _flag = false;
      if (_userAllowedJurisdictions != null) {
        _userAllowedJurisdictions.forEach((userElement) {
          if (userElement.name == allElement.name && !_flag) {
            _flag = true;
          }
          if (!_flag) {
            locations.add(
                JurisdictionPick(jurisdiction: allElement, isSelected: false));
            locations.add(
                JurisdictionPick(jurisdiction: allElement, isSelected: false));
            locations.add(
                JurisdictionPick(jurisdiction: allElement, isSelected: false));
          }
        });
      }
    });
    setBusy(false);
  }

  void toggleSelection(int index) {
    locations[index].toggleSelected();
    log('Toggled');
    notifyListeners();
  }

  Future<void> submitRequest() async {
    loadingMessage = "Sending Request";
    setBusy(true);
    List<Request> _requests = [];
    locations.forEach((element) {
      if (element.isSelected) {
        _requests.add(
          Request(
            jurisdiction: element.jurisdiction.jurisdiction,
            jurisdictionName: element.jurisdiction.name,
            user: UserData(
                email: _userService.userData!.email,
                uid: _userService.userData!.uid,
                superuser: false,
                name: _userService.userData!.name),
          ),
        );
      }
    });
    await _firestoreService.createNewRequest(requests: _requests);
    _navigatorService.back();
    _snackbarService.showSnackbar(message: 'Request sent');
    setBusy(false);
  }
}

class JurisdictionPick {
  Jurisdiction jurisdiction;
  bool isSelected;
  JurisdictionPick({required this.jurisdiction, required this.isSelected});
  void toggleSelected() => isSelected = !isSelected;
}
