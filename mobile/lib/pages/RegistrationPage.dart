import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/services/UserService.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _phoneNumberController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(const Radius.circular(32.0)),
                ),
                hintText: "Phone number",
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.phone,
              controller: _phoneNumberController,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(const Radius.circular(32.0)),
                ),
                hintText: "Display name",
              ),
              textAlign: TextAlign.center,
              controller: _displayNameController,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(const Radius.circular(32.0)),
                ),
                hintText: "Password",
              ),
              textAlign: TextAlign.center,
              controller: _passwordController,
              obscureText: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: () => _register(context),
                    child: Text("REGISTER"),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _register(BuildContext context) {
    final userService = GetIt.I.get<UserService>();

    final phoneNumber = _phoneNumberController.text.trim();
    final password = _passwordController.text.trim();

    FirebaseMessaging.instance.getToken().then((token) {
      final deviceToken = token;
      if (deviceToken != null) {
        userService.register(phoneNumber, deviceToken, password).then(
          (successful) {
            if (successful) {
              Navigator.pop(context);
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
