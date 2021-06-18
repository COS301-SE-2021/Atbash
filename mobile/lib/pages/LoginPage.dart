import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/pages/MainPage.dart';
import 'package:mobile/pages/RegistrationPage.dart';
import 'package:mobile/services/UserService.dart';

class LoginPage extends StatelessWidget {
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                  hintText: "Password",
                ),
                textAlign: TextAlign.center,
                obscureText: true,
                controller: _passwordController,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: ElevatedButton(
                onPressed: () => _login(context),
                child: Text("LOGIN"),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
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
            )
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context) {
    final phoneNumber = _phoneNumberController.text.trim();
    final password = _passwordController.text.trim();
    GetIt.I.get<UserService>().login(phoneNumber, password).then((successful) {
      if (successful) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      }
    });
  }

  void _register(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegistrationPage()));
  }
}
