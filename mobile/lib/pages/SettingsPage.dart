import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/services/UserService.dart';

class SettingsPage extends StatelessWidget {
  final _userService = GetIt.I.get<UserService>();

  final _displayNameController = TextEditingController();
  final _statusController = TextEditingController();

  SettingsPage() {
    _displayNameController.text = _userService.getUser()?.displayName ?? "";
    _statusController.text = _userService.getUser()?.status ?? "";
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

                  _userService.setDisplayName(displayName);
                  _userService.setStatus(status);

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
}
