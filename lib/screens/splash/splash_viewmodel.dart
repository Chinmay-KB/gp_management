import 'package:gp_management/app.router.dart';
import 'package:gp_management/model/userdata.dart';
import 'package:gp_management/services/auth_service.dart';
import 'package:gp_management/services/firestore_service.dart';
import 'package:gp_management/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app.locator.dart';

class SplashViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _navigationService = locator<NavigationService>();
  final _firebaseService = locator<FirestoreService>();
  final _snackbarService = locator<SnackbarService>();
  final _userService = locator<UserService>();

  late bool isLoggedIn;

  Future<void> init() async {
    setBusy(true);
    await Future.delayed(const Duration(seconds: 1));
    isLoggedIn = _authService.checkLoggedIn();
    if (isLoggedIn) {
      final _uid = (await _authService.getUser())!.uid;
      _userService.userData =
          (await _firebaseService.getUserData(uid: _uid)).data();
      if (_userService.userData!.superuser) {
        _navigationService.pushNamedAndRemoveUntil(Routes.superUserItemsView,
            predicate: (route) => false);
      } else {
        _navigationService.pushNamedAndRemoveUntil(Routes.viewItemsView,
            predicate: (route) => false);
      }
    } else {
      // _navigationService.navigateTo(Routes.loginView);
    }
    setBusy(false);
  }

  /// Handles login, and the respective navigation
  Future<void> onLogin() async {
    setBusy(true);
    await _authService.signInwithGoogle();
    if (_authService.checkLoggedIn()) {
      final _userData = await _authService.getUser();
      final _userExists =
          await _firebaseService.checkUserExists(_userData!.uid);
      if (!_userExists) {
        await _firebaseService.createNewUser(
            uid: _userData.uid,
            userData: UserData(
              email: _userData.email!,
              name: _userData.displayName!,
              jurisdictions: [],
              superuser: false,
              uid: _userData.uid,
            ));
        _userService.userData = UserData(
          email: _userData.email!,
          name: _userData.displayName!,
          jurisdictions: [],
          superuser: false,
          uid: _userData.uid,
        );
      }
      {
        final _data =
            (await _firebaseService.getUserData(uid: _userData.uid)).data();
        _userService.userData = _data;

        if (_data!.superuser) {
          _navigationService.pushNamedAndRemoveUntil(Routes.superUserItemsView,
              predicate: (route) => false);
        } else {
          _navigationService.pushNamedAndRemoveUntil(Routes.viewItemsView,
              predicate: (route) => false);
        }
      }
    } else {
      _snackbarService.showSnackbar(message: 'Error');
    }
  }

  /// Handles logout, not necessary in this screen
  onLogout() async {
    await _authService.signOutFromGoogle();
    if (!_authService.checkLoggedIn()) {
      _snackbarService.showCustomSnackBar(message: 'Logged out');
    } else {
      _snackbarService.showCustomSnackBar(message: 'Error');
    }
  }
}
