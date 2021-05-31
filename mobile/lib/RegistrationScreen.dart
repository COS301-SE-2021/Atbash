import 'package:flutter/material.dart';


class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: (IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        )),
        backgroundColor: Colors.green,
      ),
      body: ListView(
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
                  "Full Name: ",
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
                  child: TextButton(
                    onPressed: () {

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

