import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/services/UserService.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _userService = GetIt.I.get<UserService>();
  final picker = ImagePicker();
  final _displayNameController = TextEditingController();
  final _statusController = TextEditingController();
  Uint8List? _selectedProfileImage;

  _SettingsPageState() {
    _displayNameController.text = _userService.getUser()?.displayName ?? "";
    _statusController.text = _userService.getUser()?.status ?? "";
    try {
      _selectedProfileImage =
          base64Decode(_userService
              .getUser()
              ?.imageData ?? "");
    }
    on Exception{
      _selectedProfileImage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Settings"),
    );
  }

  Container _buildBody(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Column(children: <Widget>[
              CircleAvatar(
                radius: 80,
                child: (_selectedProfileImage == null || _selectedProfileImage!.isEmpty) ? Text("Picture") : null,
                backgroundImage: _buildAvatarImage(),
              ),
              const SizedBox(height: 10.0),
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
                    iconSize: 50,
                    icon: Icon(Icons.photo_library),
                    onPressed: () {
                      _loadPicker(ImageSource.gallery);
                    },
                    tooltip: "Add image using your gallery.",
                  ),
                  IconButton(
                    iconSize: 50,
                    icon: Icon(Icons.photo_camera),
                    onPressed: () {
                      _imgFromCamera(context);
                    },
                    tooltip: "Add image using your camera.",
                  ),
                ],
              ),
            ]),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Column(
              children: [
                Text(
                  "Change display name",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _displayNameController,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Column(
              children: [
                Text(
                  "Change status",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _statusController,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            child: Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  final displayName = _displayNameController.text;
                  final status = _statusController.text;
                  final profileImage =
                      base64Encode(_selectedProfileImage ?? []);

                  _userService.setDisplayName(displayName);
                  _userService.setStatus(status);
                  _userService.setProfileImage(profileImage);

                  Navigator.pop(context);
                },
                child: Text("SUBMIT"),
              ),
            ),
          )
        ],
      ),
    );
  }

  MemoryImage? _buildAvatarImage() {
    final image = _selectedProfileImage;
    return (image != null && image.isNotEmpty) ? MemoryImage(image) : null;
  }

  Future _loadPicker(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      final imageBytes = await file.readAsBytes();
      setState(() {
        _selectedProfileImage = imageBytes;
      });
    }
  }

  // Future _imgFromGallery() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //   // setState(() {
  //   //   if (pickedFile != null) {
  //   //     _image = File(pickedFile.path);
  //   //   } else {
  //   //     print('No image selected.');
  //   //   }
  //   // });
  // }

  Future _imgFromCamera(BuildContext context) async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.camera);

      // setState(() {
      //   if (pickedFile != null) {
      //     _image = File(pickedFile.path);
      //   } else {
      //     print('No image selected.');
      //   }
      // });
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
