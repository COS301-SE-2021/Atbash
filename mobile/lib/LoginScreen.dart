import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back),
          )
        ],
        title: Text("Atbash Login"),
        backgroundColor: Colors.green,
      ),

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

        ],
      ),
    );
  }
}
