import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/models/ContactsModel.dart';
import 'package:mobile/models/UserModel.dart';
import 'package:mobile/services/AppService.dart';

import '../constants.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final ContactsModel _contactsModel = GetIt.I.get();
  final AppService _appService = GetIt.I.get();
  final UserModel _userModel = GetIt.I.get();

  final picker = ImagePicker();
  final _displayNameController = TextEditingController();
  final _statusController = TextEditingController();
  Uint8List? _selectedProfileImage;

  @override
  void initState() {
    super.initState();
    _displayNameController.text = _userModel.displayName;

    _statusController.text = _userModel.status;

    _selectedProfileImage = _userModel.profileImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Info"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(15),
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  CircleAvatar(
                    backgroundColor: Constants.orangeColor,
                    radius: 64,
                    child: (_selectedProfileImage == null ||
                            _selectedProfileImage!.isEmpty)
                        ? Text("Picture")
                        : null,
                    backgroundImage: _buildAvatarImage(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        splashRadius: 24,
                        color: Colors.black.withOpacity(0.7),
                        iconSize: 32,
                        onPressed: () {
                          _loadPicker(ImageSource.gallery);
                        },
                        icon: Icon(Icons.photo_library),
                      ),
                      SizedBox(
                        width: 48,
                      ),
                      IconButton(
                        splashRadius: 24,
                        color: Colors.black.withOpacity(0.7),
                        iconSize: 32,
                        onPressed: () {
                          _imgFromCamera(context);
                        },
                        icon: Icon(Icons.photo_camera),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 40,
                    ),
                    child: Container(
                      child: TextField(
                        controller: _displayNameController,
                        decoration: InputDecoration(
                          hintText: "Display Name",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 80,
                    ),
                    child: Container(
                      child: TextField(
                        controller: _statusController,
                        decoration: InputDecoration(
                          hintText: "Status",
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Constants.orangeColor,
                    onPressed: () {
                      final displayName = _displayNameController.text;
                      final status = _statusController.text;
                      final profileImage =
                          _selectedProfileImage ?? Uint8List(0);

                      if (displayName.isNotEmpty) {
                        _userModel.setDisplayName(displayName);
                      }

                      if (status.isNotEmpty) {
                        _userModel.setStatus(status);
                      }

                      _userModel.setProfileImage(profileImage);

                      _contactsModel.contacts.forEach((contact) {
                        _appService.sendStatus(
                          contact.phoneNumber,
                          status,
                          contact.symmetricKey,
                        );
                        // TODO re-enable once sendProfileImage is fixed
                        // _appService.sendProfileImage(
                        //   contact.phoneNumber,
                        //   base64Encode(profileImage),
                        //   contact.symmetricKey,
                        // );
                      });

                      Navigator.pop(context);
                    },
                    child: Text("Save"),
                  ),
                ],
              ),
            ),
          ),
        ),
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

  Future _imgFromCamera(BuildContext context) async {
    try {
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
