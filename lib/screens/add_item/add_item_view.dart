import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:sweetsheet/sweetsheet.dart';

import 'add_item_viewmodel.dart';

class AddItemView extends StatelessWidget {
  AddItemView({Key? key}) : super(key: key);

  final SweetSheet _sweetSheet = SweetSheet();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddItemViewModel>.reactive(
      viewModelBuilder: () => AddItemViewModel(),
      onModelReady: (model) => model.init(),
      builder: (
        BuildContext context,
        AddItemViewModel model,
        Widget? child,
      ) {
        return WillPopScope(
          onWillPop: () async {
            late bool popOrNot;
            await _sweetSheet.show(
              context: context,
              title: Text(
                "Warning",
                style: GoogleFonts.oxygen(),
              ),
              description: Text(
                'You will lose all the data you have added. Go back?',
                style: GoogleFonts.oxygen(),
              ),
              color: CustomSheetColor(
                  main: Theme.of(context).primaryColor,
                  accent: Theme.of(context).accentColor,
                  icon: Colors.white),
              // icon: Icons.portable_wifi_off,
              positive: SweetSheetAction(
                onPressed: () {
                  popOrNot = true;
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                title: 'Yes',
              ),
              negative: SweetSheetAction(
                onPressed: () {
                  popOrNot = false;
                  Navigator.of(context).pop();
                },
                title: 'No',
              ),
            );
            return false;
            //return popOrNot;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text("Add new item"),
              centerTitle: true,
            ),
            body: (model.isBusy)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Form(
                      key: model.formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'Name',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    validator: (value) {
                                      value = value ?? "";
                                      if (value.isEmpty) return "Enter Name";
                                    },
                                    onSaved: (value) =>
                                        model.dataModel.name = value,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      labelText: 'File no',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    validator: (value) {
                                      value = value ?? "";
                                      if (value.isEmpty)
                                        return "Enter file number";
                                    },
                                    onSaved: (value) =>
                                        model.dataModel.fileNumber = value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    readOnly: true,
                                    onTap: () =>
                                        model.selectPurchaseDate(context),
                                    controller: model.purchaseDataController,
                                    decoration: InputDecoration(
                                      labelText: 'Purchase Date',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    validator: (value) {
                                      value = value ?? "";
                                      if (value.isEmpty)
                                        return "Enter Purchase Date";
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Quantity',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    validator: (value) {
                                      value = value ?? "";
                                      if (value.isEmpty)
                                        return "Enter quantity";
                                    },
                                    onSaved: (value) =>
                                        model.dataModel.quantity = value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              maxLines: null,
                              decoration: InputDecoration(
                                labelText: 'Purpose',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              validator: (value) {
                                value = value ?? "";
                                if (value.isEmpty) return "Enter purpose";
                              },
                              onSaved: (value) =>
                                  model.dataModel.purpose = value,
                            ),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Switch(
                                      value: model.addServicingDate,
                                      onChanged: model.setServicingBool),
                                  Text('Add servicing date')
                                ],
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    enabled: model.addServicingDate,
                                    readOnly: true,
                                    onTap: () =>
                                        model.selectServicingDate(context),
                                    controller: model.servicingDataController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Next servicing date',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    validator: (value) {
                                      value = value ?? "";
                                      if (value.isEmpty &&
                                          model.addServicingDate)
                                        return "Enter servicing date";
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  labelText: "Category"),
                              onChanged: (salutation) {
                                model.dataModel.category = salutation;
                              },
                              validator: (value) =>
                                  value == null ? 'Choose a category' : null,
                              items: [
                                'Furniture',
                                'Vehicle',
                                'Stationery',
                                'Electronics'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  labelText: "Location"),
                              onChanged: (salutation) {
                                model.dataModel.location = salutation;
                              },
                              validator: (value) =>
                                  value == null ? 'Choose a location' : null,
                              items: model.locations
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: TextDropdownFormField(
                          //     options: ["A", "B", "C"],
                          //     decoration: InputDecoration(
                          //         border: OutlineInputBorder(
                          //             borderRadius: BorderRadius.circular(8)),
                          //         suffixIcon: Icon(Icons.arrow_drop_down),
                          //         labelText: "Category"),
                          //     dropdownHeight: 150,
                          //     validator: (value) {
                          //       value = value ?? "";
                          //       if (value.isEmpty) return "Select a category";
                          //     },
                          //     onSaved: (value) => model.dataModel.category = value,
                          //   ),
                          // ),
                          ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (model.formKey.currentState!.validate()) {
                                model.formKey.currentState!.save();
                                model.submitData(context);
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.

                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
