import 'package:flutter/material.dart';
import 'package:mobile/controllers/BlockedContactsPageController.dart';

class BlockedContactsPage extends StatefulWidget {
  const BlockedContactsPage({Key? key}) : super(key: key);

  @override
  _BlockedContactsPageState createState() => _BlockedContactsPageState();
}

class _BlockedContactsPageState extends State<BlockedContactsPage> {
  final BlockedContactsPageController controller;

  _BlockedContactsPageState() : controller = BlockedContactsPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Blocked Contacts"),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Container();
        });
  }
}
