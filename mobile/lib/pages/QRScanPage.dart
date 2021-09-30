import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanPage extends StatefulWidget {
  QRScanPage({Key? key}) : super(key: key);

  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final CommunicationService communicationService = GetIt.I.get();
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

        communicationService.connectToPc(relayId);

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
