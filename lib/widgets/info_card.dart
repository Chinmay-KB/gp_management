import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gp_management/model/info.dart';
import 'package:gp_management/screens/edit_item/edit_item_view.dart';
import 'package:gp_management/screens/view_items/view_items_viewmodel.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class InfoCard extends StatelessWidget {
  InfoCard(
      {Key? key,
      required this.index,
      required this.model,
      this.isSuperUser = false})
      : super(key: key);
  final ViewItemsViewModel model;
  final int index;
  final GlobalKey globalKey = new GlobalKey();
  bool isSuperUser;

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      Datum data = model.info!.data[index];
      final tempDir = await getTemporaryDirectory();
      final dirPath = '${tempDir.path}/${data.location}_${data.id}.png';
      final file = await new File(dirPath).create();
      await file.writeAsBytes(pngBytes);

      Share.shareFiles([dirPath],
          text:
              '${data.name}\nLocation-${data.location}\nFile No-${data.fileNumber}');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _savePng(BuildContext context) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      Datum data = model.info!.data[index];

      final directory = await getExternalStorageDirectory();

      final myImagePath = '${directory!.path}/GP_Management';
      final myImgDir = await new Directory(myImagePath).create();
      final dirPath = '$myImagePath/${data.location}_${data.id}.png';

      var kompresimg = new File(dirPath);
      kompresimg.writeAsBytesSync(pngBytes);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Successful')));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = model.info!.data[index];
    final purchaseDateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(data.purchase!));
    final purchase =
        "${purchaseDateTime.toLocal().day}/${purchaseDateTime.toLocal().month}/${purchaseDateTime.toLocal().year}";
    final servicingDateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(data.servicing!));
    final servicing = (servicingDateTime
                .compareTo(DateTime.fromMillisecondsSinceEpoch(0)) ==
            0)
        ? 'N/A'
        : "${servicingDateTime.toLocal().day}/${servicingDateTime.toLocal().month}/${servicingDateTime.toLocal().year}";
    return GestureDetector(
      onTap: () {
        showMaterialModalBottomSheet(
          enableDrag: false,
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: RepaintBoundary(
                  key: globalKey,
                  child: Container(
                    color: Colors.white,
                    child: QrImage(
                      data: '${data.id!}`${data.location}',
                      version: QrVersions.auto,
                      size: 300.0,
                    ),
                  ),
                ),
              ),
              Text(
                data.name!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.spaceBetween,
                runSpacing: 4,
                spacing: 16,
                children: [
                  Text('File no - ${data.fileNumber}',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  Text('Quantity - ${data.quantity}',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                ],
              ),
              Text('Purpose - ${data.purpose}',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Divider(
                  height: 0,
                ),
              ),
              Wrap(
                spacing: 16,
                children: [
                  Text('Next servicing date - $servicing',
                      style: TextStyle(
                        fontSize: 14,
                      )),
                  Text('Purchase date - $purchase',
                      style: TextStyle(
                        fontSize: 14,
                      )),
                ],
              ),
              Text(
                'Category - ${data.category}',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (isSuperUser)
                    TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => EditItemView(
                                      prefill: data,
                                      info: model.info!,
                                      index: index),
                                ),
                              )
                              .then(
                                  (value) => model.fetchDataForJurisdiction());
                        },
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.all(8)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xff556FB5),
                            ),
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white,
                            )),
                        icon: Icon(Icons.edit),
                        label: Text('Edit data')),
                  TextButton.icon(
                    onPressed: () {
                      _captureAndSharePng();
                    },
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(8)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xff556FB5),
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white,
                        )),
                    label: Text('Share QR'),
                    icon: Icon(Icons.share),
                  ),
                  // TextButton.icon(
                  //   onPressed: () {
                  //     _savePng(context);
                  //   },
                  //   label: Text('Save QR'),
                  //   icon: Icon(Icons.save),
                  // )
                ],
              )
            ],
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Wrap(
                  spacing: 16,
                  children: [
                    Text(
                      'Category - ${data.category}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text('Quantity - ${data.quantity}',
                        style: TextStyle(
                          fontSize: 16,
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
