import 'package:flutter/material.dart';
import 'package:gp_management/screens/request_access/request_access_viewmodel.dart';
import 'package:stacked/stacked.dart';

class RequestAccessView extends StatelessWidget {
  const RequestAccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RequestAccessViewModel>.reactive(
      viewModelBuilder: () => RequestAccessViewModel(),
      onModelReady: (model) => model.init(),
      builder: (
        BuildContext context,
        RequestAccessViewModel model,
        Widget? child,
      ) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Request Access'),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                    onTap: model.submitRequest,
                    child: Icon(Icons.send_rounded)),
              )
            ],
          ),
          body: model.isBusy
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: model.locations.length,
                  itemBuilder: (context, index) => CheckboxListTile(
                        selected: model.locations[index].isSelected,
                        title: Text(model.locations[index].jurisdiction.name),
                        onChanged: (bool? value) {
                          model.toggleSelection(index);
                        },
                        value: model.locations[index].isSelected,
                      )),
        );
      },
    );
  }
}
