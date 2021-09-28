import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/constants.dart';

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
        child: Column(
          children: [
            Flexible(child: _buildMessages()),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
        itemCount: 6,
        itemBuilder: (_, index) {
          return Column(
            children: [
              // _chatDateString(index);
              _buildMessage(),
            ],
          );
          return _buildMessage();
        });
  }

  Container _buildMessage() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 2.5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IntrinsicWidth(
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Constants.orange.withOpacity(0.88),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam sodales enim ligula. Maecenas nec enim nec ante varius ullamcorper. Duis feugiat eros id arcu mattis, vel consequat diam malesuada. Aenean consectetur nibh lectus, eget rhoncus nibh facilisis at. Phasellus gravida tristique ipsum at fermentum.",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("12:00",
                      style: TextStyle(fontSize: 10, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _chatDateString(int index) {
  //   int numMillisPerDay = 1000 * 60 * 60 * 24;
  //
  //   int curDay =
  //       (controller.model.messages[index].timestamp.millisecondsSinceEpoch /
  //               numMillisPerDay)
  //           .floor();
  //   int prevDay = index == controller.model.messages.length - 1
  //       ? 0
  //       : (controller.model.messages[index + 1].timestamp
  //                   .millisecondsSinceEpoch /
  //               numMillisPerDay)
  //           .floor();
  //
  //   int today =
  //       (DateTime.now().millisecondsSinceEpoch / numMillisPerDay).floor();
  //
  //   String date = "";
  //
  //   if (curDay > prevDay) {
  //     if (curDay == today) date = "Today";
  //
  //     if (today - curDay == 1) date = "Yesterday";
  //
  //     if (today - curDay < 7)
  //       date = DateFormat("EEEE")
  //           .format(controller.model.messages[index].timestamp);
  //
  //     date = DateFormat("EEE, dd MMM")
  //         .format(controller.model.messages[index].timestamp);
  //   }
  //   if (date == "") return Container();
  //
  //   return Container(
  //     margin: EdgeInsets.all(5),
  //     padding: EdgeInsets.all(5),
  //     decoration: BoxDecoration(
  //       color: Constants.white.withOpacity(0.88),
  //       borderRadius: BorderRadius.circular(45),
  //     ),
  //     child: Text(
  //       date,
  //     ),
  //   );
  // }
}
