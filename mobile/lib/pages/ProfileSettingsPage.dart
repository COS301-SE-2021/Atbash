import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile/constants.dart';
import 'package:mobile/controllers/ProfileSettingsPageController.dart';
import 'package:mobile/pages/HomePage.dart';
import 'package:mobile/widgets/AvatarIcon.dart';
import 'package:mobx/mobx.dart';

class ProfileSettingsPage extends StatefulWidget {
  final bool setup;
  final ProfileSettingsPageController? controller;

  const ProfileSettingsPage({Key? key, required this.setup, this.controller})
      : super(key: key);

  @override
  _ProfileSettingsPageState createState() =>
      _ProfileSettingsPageState(controller: controller);
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final ProfileSettingsPageController controller;

  _ProfileSettingsPageState({ProfileSettingsPageController? controller})
      : controller = controller ?? ProfileSettingsPageController();

  final picker = ImagePicker();
  final _displayNameController = TextEditingController();
  final _statusController = TextEditingController();
  DateTime? chosenBirthday;

  late final ReactionDisposer _userDisposer;
  Uint8List? _selectedProfileImage;

  @override
  void initState() {
    super.initState();

    _userDisposer = autorun((_) {
      chosenBirthday = controller.model.birthday;
      _displayNameController.text = controller.model.displayName;
      _statusController.text = controller.model.status;
      setState(() {
        _selectedProfileImage = controller.model.profilePicture;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userDisposer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(15),
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Profile info",
                    style: TextStyle(
                      fontSize: 20,
                      color: Constants.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (widget.setup)
                    Text(
                      "Please provide a name as well as an optional profile picture and status.",
                      textAlign: TextAlign.center,
                      key: Key('infoText'),
                    ),
                  SizedBox(
                    height: 30,
                  ),
                  AvatarIcon(
                    _selectedProfileImage,
                    radius: 64,
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 40,
                    ),
                    child: TextField(
                      controller: _displayNameController,
                      decoration: InputDecoration(
                        hintText: "Display Name",
                      ),
                      textAlign: TextAlign.center,
                      key: Key("displayNameText"),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 80,
                    ),
                    child: TextField(
                      controller: _statusController,
                      decoration: InputDecoration(
                        hintText: "Status",
                      ),
                      textAlign: TextAlign.center,
                      key: Key("statusText"),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text("Birthday"),
                  TextButton(
                    onPressed: () {
                      DatePicker.showDatePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime(1900, 1, 1),
                        maxTime: DateTime.now(),
                        onConfirm: (date) {
                          setState(() {
                            chosenBirthday = date;
                          });
                        },
                        currentTime: DateTime.now(),
                      );
                    },
                    child: Text(_chosenBirthdayToString()),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Constants.orange,
                    onPressed: () {
                      final displayName = _displayNameController.text;
                      final status = _statusController.text;
                      final profileImage =
                          _selectedProfileImage ?? Uint8List(0);
                      final birthday = chosenBirthday;

                      if (displayName.isNotEmpty)
                        controller.setDisplayName(displayName);

                      if (status.isNotEmpty) controller.setStatus(status);

                      controller.setProfilePicture(profileImage);

                      if (birthday != null) controller.setBirthday(birthday);

                      if (widget.setup) {
                        showDialog(
                            context: context,
                            builder: (BuildContext buildContext) {
                              return AlertDialog(
                                title: Text(
                                    "If you wish to import your contact list, please grant the app permission in the next popup."),
                                key: Key("alertDialog"),
                              );
                            }).then((_) {
                          controller.importContacts().then((_) =>
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage())));
                        });
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(widget.setup ? "Next" : "Save"),
                    key: Key('button'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _chosenBirthdayToString() {
    final birthday = chosenBirthday;

    if (birthday != null) {
      return DateFormat.yMMMd().format(birthday);
    } else {
      return "Select Birthday";
    }
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
      //TODO implement this setState for taking pictures
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
