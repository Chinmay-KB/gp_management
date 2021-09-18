import 'dart:developer';

import 'package:gp_management/app.locator.dart';
import 'package:gp_management/model/jurisdictions.dart';
import 'package:gp_management/model/requests.dart';
import 'package:gp_management/services/firestore_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PendingRequestsViewModel extends BaseViewModel {
  final _navigatorService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _firestoreService = locator<FirestoreService>();

  late Requests? requests;
  List<bool> selections = [];

  init() async {
    selections.clear();
    setBusy(true);
    requests = (await _firestoreService.fetchPendingRequests()).data();
    log('Fetched');
    selections = List.generate(requests!.requests.length, (index) => false);
    setBusy(false);
  }

  toggleSelection(int index) {
    selections[index] = !selections[index];
    notifyListeners();
  }

  acceptRequests() async {
    setBusy(true);
    List<Request> _removeRequests = [];
    for (int i = 0; i < requests!.requests.length; i++) {
      if (selections[i]) {
        final _data = requests!.requests[i];
        await _firestoreService.acceptUserRequest(
          uid: _data.user.uid,
          jurisdiction: Jurisdiction(
              jurisdiction: _data.jurisdiction, name: _data.jurisdictionName),
        );
        _removeRequests.add(_data);
      }
    }
    if (_removeRequests.isNotEmpty)
      await _firestoreService.removePendingRequest(requests: _removeRequests);

    init();
  }

  deleteRequests() async {
    setBusy(true);
    List<Request> _removeRequests = [];
    for (int i = 0; i < requests!.requests.length; i++) {
      if (selections[i]) {
        final _data = requests!.requests[i];
        // await _firestoreService.acceptUserRequest(
        //   uid: _data.user.uid,
        //   jurisdiction: Jurisdiction(
        //       jurisdiction: _data.jurisdiction, name: _data.jurisdictionName),
        // );
        _removeRequests.add(_data);
      }
    }
    if (_removeRequests.isNotEmpty)
      await _firestoreService.removePendingRequest(requests: _removeRequests);

    init();
  }
}
