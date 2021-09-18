import 'package:gp_management/screens/add_item/add_item_view.dart';
import 'package:gp_management/screens/edit_item/edit_item_view.dart';
import 'package:gp_management/screens/pending_requests/pending_requests_view.dart';
import 'package:gp_management/screens/qr/qr_scan_details.dart';
import 'package:gp_management/screens/qr/qr_view.dart';
import 'package:gp_management/screens/request_access/request_access_view.dart';
import 'package:gp_management/screens/splash/splash_view.dart';
import 'package:gp_management/screens/superuser_view/superuser_items_view.dart';
import 'package:gp_management/screens/view_items/view_items_view.dart';
import 'package:gp_management/services/auth_service.dart';
import 'package:gp_management/services/firestore_service.dart';
import 'package:gp_management/services/user_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(routes: [
  MaterialRoute(page: AddItemView),
  MaterialRoute(page: EditItemView),
  // MaterialRoute(page: LoginView),
  MaterialRoute(page: QrView),
  MaterialRoute(page: ViewItemsView),
  MaterialRoute(page: SuperUserItemsView),
  MaterialRoute(page: QrScanInfoScreen),
  MaterialRoute(page: RequestAccessView),
  MaterialRoute(page: PendingRequestsView),
  MaterialRoute(page: SplashView, initial: true)
], dependencies: [
  Factory(classType: FirestoreService),
  Factory(classType: NavigationService),
  LazySingleton(classType: SnackbarService),
  Factory(classType: AuthService),
  Singleton(classType: UserService)
])
class AppSetup {}
