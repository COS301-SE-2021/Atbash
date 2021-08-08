import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/pages/MainPage.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mobile/util/Utils.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final UserService _userService = GetIt.I.get();

  final _phoneNumberController = TextEditingController();

  bool loading = false;
  String selectedDialCode = "+27";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 0.0),
            child: SvgPicture.asset(
              "assets/atbash.svg",
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CountryCodePicker(
                  showFlag: false,
                  initialSelection: selectedDialCode,
                  onChanged: (countryCode) {
                    final dialCode = countryCode.dialCode;
                    if (dialCode != null) {
                      this.selectedDialCode = dialCode;
                    }
                  },
                ),
                Container(
                  width: 160,
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.phone,
                    controller: _phoneNumberController,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: _buildRegisterButton(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    if (loading) {
      return SpinKitThreeBounce(
        color: Colors.orange,
        size: 24.0,
      );
    } else {
      return ElevatedButton(
        onPressed: () => _register(context),
        child: Text("REGISTER"),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
          ),
        ),
      );
    }
  }

  void _register(BuildContext context) {
    setState(() {
      loading = true;
    });

    final phoneNumber =
        selectedDialCode + cullToE164(_phoneNumberController.text);

    FirebaseMessaging.instance.getToken().then((token) {
      final deviceToken = token;
      if (deviceToken != null) {
        _userService.register(phoneNumber, deviceToken).then(
          (successful) {
            if (successful) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MainPage()));
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Failed to register")));
            }
          },
        );
      }
    });
  }
}
