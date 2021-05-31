import 'package:flutter/material.dart';

class RegistrationScreen extends StatelessWidget {
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

        ],
      ),
    );
  }
}
