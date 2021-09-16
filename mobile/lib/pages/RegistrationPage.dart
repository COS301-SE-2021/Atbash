import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/controllers/RegistrationPageController.dart';
import 'package:mobile/pages/VerificationPage.dart';
import 'package:mobile/util/Utils.dart';

import '../constants.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final RegistrationPageController controller;

  _RegistrationPageState() : controller = RegistrationPageController();

  final _phoneNumberController = TextEditingController();

  bool loading = false;
  String selectedDialCode = "+27";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(
            flex: 2,
          ),
          SvgPicture.asset(
            "assets/atbash.svg",
            width: 256,
          ),
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 80),
            child: Container(
              padding: EdgeInsets.symmetric(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CountryCodePicker(
                    showDropDownButton: true,
                    padding: EdgeInsets.zero,
                    showFlag: false,
                    initialSelection: selectedDialCode,
                    onChanged: (countryCode) {
                      final dialCode = countryCode.dialCode;
                      if (dialCode != null) {
                        this.selectedDialCode = dialCode;
                      }
                    },
                  ),
                  Expanded(
                    child: Container(
                      child: TextField(
                        cursorColor: Constants.darkGrey.withOpacity(0.6),
                        cursorHeight: 20,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Phone Number",
                          hintStyle: TextStyle(
                            color: Constants.darkGrey.withOpacity(0.6),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Constants.orange,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        controller: _phoneNumberController,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          _buildRegisterButton(context),
          Spacer(
            flex: 2,
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
      return MaterialButton(
        color: Constants.orange,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "Register",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        onPressed: () => _register(context),
      );
    }
  }

  void _register(BuildContext context) {
    setState(() {
      loading = true;
    });

    final phoneNumber =
        selectedDialCode + cullToE164(_phoneNumberController.text);

    controller.register(phoneNumber).then((verificationCode) {
      FlutterSecureStorage()
          .write(key: "verification_code", value: verificationCode);

      if (verificationCode != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VerificationPage(code: verificationCode),
          ),
        );
      } else {
        showSnackBar(context, "This phone number is already registered");
        setState(() {
          loading = false;
        });
      }
    }).catchError((error) {
      setState(() {
        loading = false;
      });
    });
  }
}
