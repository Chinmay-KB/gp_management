import 'package:flutter/material.dart';
import 'package:gp_management/model/info.dart';
import 'package:gp_management/model/jurisdictions.dart';
import 'package:gp_management/services/firestore_service.dart';
import 'package:gp_management/services/setup_locator.dart';
import 'package:stacked/stacked.dart';

class AddItemViewModel extends BaseViewModel {
  var formKey = GlobalKey<FormState>();
  var dataModel = Datum();
  TextEditingController purchaseDataController = TextEditingController();
  TextEditingController servicingDataController = TextEditingController();
  List<String> locations = [];
  late Jurisdictions jurisdictions;
  final firestoreService = locator<FirestoreService>();

  init() async {
    setBusy(true);
    jurisdictions = await firestoreService.getJurisdictionList();
    jurisdictions.jurisdictions
        .forEach((element) => locations.add(element.name));
    print("finished");
    setBusy(false);
  }

  selectPurchaseDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000, 1),
        lastDate: DateTime(2100));
    if (picked != null &&
        picked.millisecondsSinceEpoch.toString() !=
            purchaseDataController.text) {
      dataModel.purchase = picked.millisecondsSinceEpoch.toString();
      purchaseDataController.text =
          "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
    }
    notifyListeners();
  }

  selectServicingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000, 1),
        lastDate: DateTime(2100));
    if (picked != null &&
        picked.millisecondsSinceEpoch.toString() !=
            servicingDataController.text) {
      dataModel.servicing = picked.millisecondsSinceEpoch.toString();
      servicingDataController.text =
          "${picked.toLocal().day}/${picked.toLocal().month}/${picked.toLocal().year}";
    }
    notifyListeners();
  }

  submitData(BuildContext context) async {
    setBusy(true);
    String jurisdiction = jurisdictions.jurisdictions
        .firstWhere((element) => element.name == dataModel.location)
        .jurisdiction;

    await firestoreService.addData(jurisdiction, dataModel);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Data added successfully!")),
    );
    setBusy(false);
  }
}
