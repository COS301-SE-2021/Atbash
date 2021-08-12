import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_ui/Domain/constants.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(
            flex: 2,
          ),
          Image.asset(
            "assets/logo.png",
            width: 256,
          ),
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 80),
            child: Container(
              padding: EdgeInsets.symmetric(),
              child: TextField(
                cursorColor: Constants.darkGreyColor.withOpacity(0.6),
                cursorHeight: 20,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  hintStyle: TextStyle(
                    color: Constants.darkGreyColor.withOpacity(0.6),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Constants.orangeColor,
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
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          RegistrationButton(),
          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }
}

class RegistrationButton extends StatelessWidget {
  const RegistrationButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Constants.orangeColor,
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
      onPressed: () {},
    );
  }
}
