import 'package:flutter/material.dart';
import 'package:mobile/RegistrationScreen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
            child: Column(
              children: [
                Text(
                  "Username: ",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                TextField()
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
            child: Column(
              children: [
                Text(
                  "Password: ",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                TextField()
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton(
                    onPressed: () {
                      var result = Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationScreen()));
                      result.then((value) => print(value));
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
