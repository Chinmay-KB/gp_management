import 'package:gp_management/app.locator.dart';
import 'package:gp_management/app.router.dart';
import 'package:gp_management/model/info.dart';
import 'package:gp_management/services/auth_service.dart';
import 'package:gp_management/services/firestore_service.dart';
import 'package:gp_management/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ViewItemsViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _navigatorService = locator<NavigationService>();
  final _authService = locator<AuthService>();
  List<String> locations = [];
  bool loading = false;
  late Info info;
  late String currentLocation;
  late int jurisdictionCount;

  final firestoreService = locator<FirestoreService>();

  init() async {
    setBusy(true);
    locations.clear();
    if (_userService.userData!.jurisdictions != null)
      _userService.userData!.jurisdictions!
          .forEach((element) => locations.add(element.name));

    if (locations.isNotEmpty) {
      currentLocation = locations[0];
      await fetchDataForJurisdiction();
    }

    setBusy(false);
  }

  // bool checkAllowedJurisdiction() {
  //   String jurisdiction = jurisdictions.jurisdictions
  //       .firstWhere((element) => element.name == currentLocation)
  //       .jurisdiction;
  //   bool _flag = false;
  //   _userService.userData!.jurisdictions.forEach((element) {
  //     if (element.jurisdiction == jurisdiction && !_flag) _flag = true;
  //   });
  //   return _flag;
  // }

  Future<void> fetchDataForJurisdiction() async {
    String jurisdiction = _userService.userData!.jurisdictions!
        .firstWhere((element) => element.name == currentLocation)
        .jurisdiction;
    loading = true;
    notifyListeners();
    print('Jurisdiction got is $jurisdiction');
    info = await firestoreService.getDataForJurisdiction(jurisdiction);
    loading = false;
    notifyListeners();
  }

  navigateToRequestView() {
    _navigatorService.back();
    _navigatorService.navigateTo(Routes.requestAccessView);
  }

  logout() async {
    await _authService.signOutFromGoogle();
    _navigatorService.pushNamedAndRemoveUntil(Routes.splashView,
        predicate: (route) => false);
  }
}
