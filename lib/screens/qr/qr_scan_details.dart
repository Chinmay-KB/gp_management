import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gp_management/model/info.dart';
import 'package:gp_management/screens/qr/qr_viewmodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stacked/stacked.dart';

class QrScanInfoScreen extends StatelessWidget {
  final String code;
  final GlobalKey globalKey = new GlobalKey();

  QrScanInfoScreen({Key? key, required this.code}) : super(key: key);

  Future<void> _captureAndSharePng(Datum data) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QrViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(),
          body: model.isBusy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : model.data != null
                  ? Builder(builder: (context) {
                      Datum data = model.data!;
                      final purchaseDateTime =
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(data.purchase!));
                      final purchase =
                          "${purchaseDateTime.toLocal().day}/${purchaseDateTime.toLocal().month}/${purchaseDateTime.toLocal().year}";
                      final servicingDateTime =
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(data.servicing!));
                      final servicing = (servicingDateTime.compareTo(
                                  DateTime.fromMillisecondsSinceEpoch(0)) ==
                              0)
                          ? 'N/A'
                          : "${servicingDateTime.toLocal().day}/${servicingDateTime.toLocal().month}/${servicingDateTime.toLocal().year}";
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: RepaintBoundary(
                              key: globalKey,
                              child: Container(
                                color: Colors.white,
                                child: QrImage(
                                  data: data.id!,
                                  version: QrVersions.auto,
                                  size: 300.0,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            data.name!,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
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
                              TextButton.icon(
                                onPressed: () {
                                  _captureAndSharePng(data);
                                },
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(EdgeInsets.all(8)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color(0xff556FB5),
                                    ),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.white,
                                    )),
                                label: Text('Share QR'),
                                icon: Icon(Icons.share),
                              ),
                            ],
                          )
                        ],
                      );
                    })
                  : Text('No data found'),
        );
      },
      viewModelBuilder: () => QrViewModel(),
      onModelReady: (model) => model.init(code),
    );
  }
}
