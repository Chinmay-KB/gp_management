import 'package:gp_management/app.locator.dart';
import 'package:gp_management/app.router.dart';
import 'package:gp_management/model/info.dart';
import 'package:gp_management/model/jurisdictions.dart';
import 'package:gp_management/services/auth_service.dart';
import 'package:gp_management/services/firestore_service.dart';
import 'package:gp_management/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SuperUserItemsViewModel extends BaseViewModel {
  final _navigatorService = locator<NavigationService>();
  final _userService = locator<UserService>();
  final _authService = locator<AuthService>();

  late Jurisdictions jurisdictions;
  List<String> locations = [];
  bool loading = false;
  late Info info;
  late String currentLocation;

  final firestoreService = locator<FirestoreService>();

  init() async {
    setBusy(true);
    locations.clear();
    jurisdictions = await firestoreService.getJurisdictionList();
    jurisdictions.jurisdictions
        .forEach((element) => locations.add(element.name));
    currentLocation = locations[0];
    print("finished");
    await fetchDataForJurisdiction();
    setBusy(false);
  }

  Future<void> fetchDataForJurisdiction() async {
    String jurisdiction = jurisdictions.jurisdictions
        .firstWhere((element) => element.name == currentLocation)
        .jurisdiction;
    loading = true;
    notifyListeners();
    print('Jurisdiction got is $jurisdiction');
    info = await firestoreService.getDataForJurisdiction(jurisdiction);
    loading = false;
    notifyListeners();
  }

  logout() async {
    await _authService.signOutFromGoogle();
    _navigatorService.pushNamedAndRemoveUntil(Routes.splashView,
        predicate: (route) => false);
  }

  navigateToPendingRequests() {
    _navigatorService.back();
    _navigatorService.navigateTo(Routes.pendingRequestsView);
  }

  navigateToCreateJurisdiction() {
    _navigatorService.back();
    _navigatorService.navigateTo(Routes.addJurisdictionView)!.then((value) {
      init();
    });
  }
}
