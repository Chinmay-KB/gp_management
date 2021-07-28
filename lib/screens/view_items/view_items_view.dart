import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'view_items_viewmodel.dart';

class ViewItemsView extends StatelessWidget {
  const ViewItemsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewItemsViewModel>.reactive(
      viewModelBuilder: () => ViewItemsViewModel(),
      builder: (
        BuildContext context,
        ViewItemsViewModel model,
        Widget? child,
      ) {
        return Scaffold(
          body: Center(
            child: Text(
              'ViewItemsView',
            ),
          ),
        );
      },
    );
  }
}
