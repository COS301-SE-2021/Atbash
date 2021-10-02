import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/services/CommunicationService.dart';

import 'HomePage.dart';

class LockedAccountPage extends StatefulWidget {
  const LockedAccountPage({Key? key}) : super(key: key);

  @override
  _LockedAccountPageState createState() => _LockedAccountPageState();
}

class _LockedAccountPageState extends State<LockedAccountPage> {
  final CommunicationService communicationService = GetIt.I.get();

  void _onLockedAccountChangeToChild(value) {
    if (!value)
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        ),
        (route) => false,
      );
  }

  @override
  void initState() {
    super.initState();
    communicationService
        .onLockedAccountChangeToChild(_onLockedAccountChangeToChild);
  }

  @override
  void dispose() {
    super.dispose();
    communicationService
        .disposeOnLockedAccountChangeToChild(_onLockedAccountChangeToChild);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              "This account has been locked. Please ask the parent to unlock it for use again.",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
