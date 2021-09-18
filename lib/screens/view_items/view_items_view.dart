import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gp_management/model/info.dart';
import 'package:gp_management/screens/edit_item/edit_item_view.dart';
import 'package:gp_management/screens/qr/qr_view.dart';
import 'package:gp_management/services/user_service.dart';
import 'package:gp_management/widgets/info_card.dart';
import 'package:gp_management/widgets/side_drawer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';

import '../../app.locator.dart';
import 'view_items_viewmodel.dart';

class ViewItemsView extends StatelessWidget {
  ViewItemsView({Key? key}) : super(key: key);
  final _userService = locator<UserService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ViewItemsViewModel>.reactive(
      viewModelBuilder: () => ViewItemsViewModel(),
      onModelReady: (model) => model.init(),
      builder: (
        BuildContext context,
        ViewItemsViewModel model,
        Widget? child,
      ) {
        return Scaffold(
          drawer: SafeArea(
            child: SideDrawer(
              isSuperUser: false,
              onAbout: () {},
              onLogout: model.logout,
              onRequestAccess: model.navigateToRequestView,
            ),
          ),
          appBar: AppBar(
            title: Text(
              'GP Management',
              // style: TextStyle(
              //   color: Colors.white,
              // ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  child: Icon(
                    Icons.qr_code,
                    size: 28,
                  ),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => QrView()))
                      .then((value) => model.fetchDataForJurisdiction()),
                ),
              ),
            ],
          ),
          body: model.isBusy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : model.locations.isNotEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField<String>(
                            value: model.currentLocation,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 9),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                labelText: "Location"),
                            onChanged: (salutation) {
                              model.currentLocation = salutation!;
                              model.fetchDataForJurisdiction();
                            },
                            validator: (value) =>
                                value == null ? 'Choose a location' : null,
                            items: model.locations
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(
                          child: model.loading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : model.info.data.length == 0
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Icon(
                                            Icons.warning_rounded,
                                            size: 48,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          Text(
                                              'No items found for this location')
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemBuilder: (context, index) {
                                        return InfoCard(
                                          index: index,
                                          model: model,
                                        );
                                      },
                                      itemCount: model.info.data.length,
                                    ),
                        )
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 48,
                          ),
                          Text('You do not have access to any jurisdiction',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
