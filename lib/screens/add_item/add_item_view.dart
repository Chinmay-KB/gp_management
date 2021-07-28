import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'add_item_viewmodel.dart';

class AddItemView extends StatelessWidget {
  const AddItemView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddItemViewModel>.reactive(
      viewModelBuilder: () => AddItemViewModel(),
      builder: (
        BuildContext context,
        AddItemViewModel model,
        Widget? child,
      ) {
        return Scaffold(
          body: Center(
            child: Text(
              'AddItemView',
            ),
          ),
        );
      },
    );
  }
}
