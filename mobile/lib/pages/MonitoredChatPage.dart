import 'package:flutter/material.dart';

class MonitoredChatPage extends StatefulWidget {
  const MonitoredChatPage({Key? key}) : super(key: key);

  @override
  _MonitoredChatPageState createState() => _MonitoredChatPageState();
}

class _MonitoredChatPageState extends State<MonitoredChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("other recipient"),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
