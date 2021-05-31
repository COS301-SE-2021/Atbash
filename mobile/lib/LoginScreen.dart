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


    );
  }
}
