// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'services/auth_service.dart';
import 'services/firestore_service.dart';
import 'services/user_service.dart';

final locator = StackedLocator.instance;

void setupLocator({String? environment, EnvironmentFilter? environmentFilter}) {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerFactory(() => FirestoreService());
  locator.registerFactory(() => NavigationService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerFactory(() => AuthService());
  locator.registerSingleton(UserService());
}
