import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile/pages/ProfileSettingsPage.dart';
import 'package:mobile/util/Utils.dart';

class VerificationPage extends StatefulWidget {
  late final String actualCode;

  VerificationPage({Key? key, String? code}) : super(key: key) {
    if (code != null) {
      actualCode = code;
    } else {
      FlutterSecureStorage()
          .read(key: "verification_code")
          .then((verificationCode) => actualCode = verificationCode!);
    }
  }

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final codeController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Enter the code we SMSed to you to verify your phone number",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                width: 200,
                child: TextField(
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(isDense: true),
                  enabled: !loading,
                  onChanged: (text) {
                    if (text.length == 6) {
                      _verify();
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 16),
                child: !loading
                    ? ElevatedButton(
                        onPressed: _verify,
                        child: Text("VERIFY"),
                      )
                    : SpinKitThreeBounce(
                        color: Colors.orange,
                        size: 24.0,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verify() async {
    final code = codeController.text;

    if (code.length != 6) {
      showSnackBar(context, "Invalid code");
      return;
    }

    setState(() {
      loading = true;
    });

    await Future.delayed(Duration(seconds: 2));

    if (code == widget.actualCode) {
      FlutterSecureStorage().write(key: "verified_flag", value: "");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileSettingsPage(setup: true),
        ),
      );
    } else {
      codeController.text = "";

      showSnackBar(context, "Invalid code");
    }

    setState(() {
      loading = false;
    });
  }
}
