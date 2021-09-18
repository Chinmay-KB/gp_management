import 'package:flutter/material.dart';
import 'package:gp_management/screens/pending_requests/pending_requests_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PendingRequestsView extends StatelessWidget {
  const PendingRequestsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PendingRequestsViewModel>.reactive(
      viewModelBuilder: () => PendingRequestsViewModel(),
      onModelReady: (model) => model.init(),
      builder: (
        BuildContext context,
        PendingRequestsViewModel model,
        Widget? child,
      ) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Pending Requests'),
            actions: [
              GestureDetector(
                onTap: model.acceptRequests,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.add),
                ),
              ),
              GestureDetector(
                onTap: model.acceptRequests,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.delete_forever_rounded),
                ),
              )
            ],
          ),
          body: model.isBusy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : model.requests != null
                  ? ListView.builder(
                      itemCount: model.requests!.requests.length,
                      itemBuilder: (context, index) => CheckboxListTile(
                        selected: model.selections[index],
                        title: Text(model.requests!.requests[index].user.name),
                        subtitle: Text(
                            model.requests!.requests[index].jurisdictionName),
                        onChanged: (bool? value) {
                          model.toggleSelection(index);
                        },
                        value: model.selections[index],
                      ),
                    )
                  : Text('No pending requests'),
        );
      },
    );
  }
}
