// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'add_jurisdiction/add_jurisdiction_view.dart';
import 'model/info.dart';
import 'screens/add_item/add_item_view.dart';
import 'screens/edit_item/edit_item_view.dart';
import 'screens/pending_requests/pending_requests_view.dart';
import 'screens/qr/qr_scan_details.dart';
import 'screens/qr/qr_view.dart';
import 'screens/request_access/request_access_view.dart';
import 'screens/splash/splash_view.dart';
import 'screens/superuser_view/superuser_items_view.dart';
import 'screens/view_items/view_items_view.dart';

class Routes {
  static const String addItemView = '/add-item-view';
  static const String editItemView = '/edit-item-view';
  static const String qrView = '/qr-view';
  static const String viewItemsView = '/view-items-view';
  static const String superUserItemsView = '/super-user-items-view';
  static const String qrScanInfoScreen = '/qr-scan-info-screen';
  static const String requestAccessView = '/request-access-view';
  static const String pendingRequestsView = '/pending-requests-view';
  static const String addJurisdictionView = '/add-jurisdiction-view';
  static const String splashView = '/';
  static const all = <String>{
    addItemView,
    editItemView,
    qrView,
    viewItemsView,
    superUserItemsView,
    qrScanInfoScreen,
    requestAccessView,
    pendingRequestsView,
    addJurisdictionView,
    splashView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.addItemView, page: AddItemView),
    RouteDef(Routes.editItemView, page: EditItemView),
    RouteDef(Routes.qrView, page: QrView),
    RouteDef(Routes.viewItemsView, page: ViewItemsView),
    RouteDef(Routes.superUserItemsView, page: SuperUserItemsView),
    RouteDef(Routes.qrScanInfoScreen, page: QrScanInfoScreen),
    RouteDef(Routes.requestAccessView, page: RequestAccessView),
    RouteDef(Routes.pendingRequestsView, page: PendingRequestsView),
    RouteDef(Routes.addJurisdictionView, page: AddJurisdictionView),
    RouteDef(Routes.splashView, page: SplashView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    AddItemView: (data) {
      var args = data.getArgs<AddItemViewArguments>(
        orElse: () => AddItemViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AddItemView(key: args.key),
        settings: data,
      );
    },
    EditItemView: (data) {
      var args = data.getArgs<EditItemViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => EditItemView(
          key: args.key,
          prefill: args.prefill,
          info: args.info,
          index: args.index,
        ),
        settings: data,
      );
    },
    QrView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const QrView(),
        settings: data,
      );
    },
    ViewItemsView: (data) {
      var args = data.getArgs<ViewItemsViewArguments>(
        orElse: () => ViewItemsViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => ViewItemsView(key: args.key),
        settings: data,
      );
    },
    SuperUserItemsView: (data) {
      var args = data.getArgs<SuperUserItemsViewArguments>(
        orElse: () => SuperUserItemsViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => SuperUserItemsView(key: args.key),
        settings: data,
      );
    },
    QrScanInfoScreen: (data) {
      var args = data.getArgs<QrScanInfoScreenArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => QrScanInfoScreen(
          key: args.key,
          code: args.code,
        ),
        settings: data,
      );
    },
    RequestAccessView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const RequestAccessView(),
        settings: data,
      );
    },
    PendingRequestsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const PendingRequestsView(),
        settings: data,
      );
    },
    AddJurisdictionView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AddJurisdictionView(),
        settings: data,
      );
    },
    SplashView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const SplashView(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// AddItemView arguments holder class
class AddItemViewArguments {
  final Key? key;
  AddItemViewArguments({this.key});
}

/// EditItemView arguments holder class
class EditItemViewArguments {
  final Key? key;
  final Datum prefill;
  final Info info;
  final int index;
  EditItemViewArguments(
      {this.key,
      required this.prefill,
      required this.info,
      required this.index});
}

/// ViewItemsView arguments holder class
class ViewItemsViewArguments {
  final Key? key;
  ViewItemsViewArguments({this.key});
}

/// SuperUserItemsView arguments holder class
class SuperUserItemsViewArguments {
  final Key? key;
  SuperUserItemsViewArguments({this.key});
}

/// QrScanInfoScreen arguments holder class
class QrScanInfoScreenArguments {
  final Key? key;
  final String code;
  QrScanInfoScreenArguments({this.key, required this.code});
}
