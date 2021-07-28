import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'qr_viewmodel.dart';

class QrView extends StatelessWidget {
  const QrView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QrViewModel>.reactive(
      viewModelBuilder: () => QrViewModel(),
      builder: (
        BuildContext context,
        QrViewModel model,
        Widget? child,
      ) {
        return Scaffold(
          body: Center(
            child: Text(
              'QrView',
            ),
          ),
        );
      },
    );
  }
}
