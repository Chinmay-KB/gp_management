import 'package:flutter/material.dart';
import 'package:gp_management/add_jurisdiction/add_jurisdiction_viewmodel.dart';
import 'package:stacked/stacked.dart';

class AddJurisdictionView extends StatelessWidget {
  const AddJurisdictionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddJurisdictionViewModel>.reactive(
      viewModelBuilder: () => AddJurisdictionViewModel(),
      builder: (
        BuildContext context,
        AddJurisdictionViewModel model,
        Widget? child,
      ) {
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: model.textEditingController,
                  decoration: InputDecoration(
                    labelText: 'Enter jurisdiction name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              OutlinedButton(
                  onPressed: model.createNewJurisdiction, child: Text('Submit'))
            ],
          ),
        );
      },
    );
  }
}
