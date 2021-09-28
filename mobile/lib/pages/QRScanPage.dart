import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanPage extends StatefulWidget {
  QRScanPage({Key? key}) : super(key: key);

  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: (controller) => _onQRViewCreated(context, controller),
      ),
    );
  }

  void _onQRViewCreated(BuildContext context, QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final code = scanData.code;

      if (code.startsWith("@b")) {
        final splitCode = code.split(",");
        final relayId = splitCode[1];

        FirebaseFirestore.instance.collection(relayId).add({
          "origin": "phone",
          "type": "connected",
        });

        Future.delayed(Duration.zero, () async {
          await controller.pauseCamera();
          Navigator.popUntil(context, ModalRoute.withName("/"));
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }
}
