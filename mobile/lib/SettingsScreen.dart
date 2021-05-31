import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  File? _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text("Settings"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
              child: Column(
                children: [
                  Text(
                    "Change display name:",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  TextField()
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
              child: Column(children: [
                Text(
                  "Change status:",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                TextField()
              ]),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
              child: Column(children: [
                Text(
                  "Change profile picture:",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: Icon(Icons.photo_library),
                        onPressed: () {
                          _imgFromGallery();
                        }),
                    IconButton(
                        icon: Icon(Icons.photo_camera),
                        onPressed: () {
                          _imgFromCamera(context);
                        }),
                  ],
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _imgFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _imgFromCamera(BuildContext context) async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.camera);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    } catch (e) {
      showAlertDialog(context);
    }
  }

  showAlertDialog(BuildContext context) {
    // Create button

    showDialog(
        context: context,
        builder: (BuildContext context) {
          Widget okButton = TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          );

          AlertDialog alert = AlertDialog(
            title: Text("ALERT"),
            content: Text("Your device does not have a functional camera."),
            actions: [
              okButton,
            ],
          );
          return alert;
        });
  }
}
