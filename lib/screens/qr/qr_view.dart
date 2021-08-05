import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrView extends StatefulWidget {
  const QrView({Key? key}) : super(key: key);

  @override
  _QrViewState createState() => _QrViewState();
}

class _QrViewState extends State<QrView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  var readData = "-1";
  bool scanOver = false;
  late Widget qrWidget;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    qrWidget = QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner"),
      ),
      body: Column(
        children: [
          scanOver
              ? Container()
              : Flexible(
                  flex: 5,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 800),
                    child: qrWidget,
                  ),
                ),
          scanOver
              ? Text(readData)
              : Flexible(flex: 2, child: Text("Scan something"))
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      // await controller.pauseCamera();
      //do something
      if (scanData.code.length > 10) {
        if (scanData.code.substring(0, 10) == 'hfy376syds') {
          setState(() {
            readData = 'Found a matching QR ' + scanData.code;
            qrWidget = Container();
            scanOver = true;
          });
        } else
          setState(() {
            readData = 'Not valid QR but is lengthy';
          });
      } else
        setState(() {
          readData = 'Not valid QR';
        });
    });
  }
}
