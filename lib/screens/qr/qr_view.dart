import 'package:flutter/material.dart';
import 'package:gp_management/screens/qr/qr_scan_details.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR Code"),
        actions: [
          GestureDetector(
            child: Icon(Icons.flash_on_rounded),
            onTap: () async {
              await controller.toggleFlash();
            },
          ),
          GestureDetector(
              onTap: () async {
                await controller.flipCamera();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.flip_camera_android),
              ))
        ],
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
            borderColor: Theme.of(context).primaryColor, borderRadius: 8),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(
      (scanData) async {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    QrScanInfoScreen(code: scanData.code)));
        setState(() {
          readData = scanData.code;
        });
      },
    );
  }
}
