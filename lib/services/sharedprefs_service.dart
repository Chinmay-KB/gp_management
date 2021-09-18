// import 'dart:convert';

// import 'package:gp_management/app.locator.dart';
// import 'package:gp_management/services/auth_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPrefsService {
//   final _authService = locator<AuthService>();
//   late bool? isSuperUser;

//   Future<void> init() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (_authService.checkLoggedIn()) {
//       isSuperUser = prefs.getBool('isSuperUser');
//     } else
//       isSuperUser = null;
//   }

//   Future<void> storeUserData(bool isSuperUser) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('isSuperUser', isSuperUser);
//   }

//   Future<void> removeUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.remove('isSuperUser');
//   }
// }
