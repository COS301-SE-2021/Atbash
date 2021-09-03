import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_ui/Domain/Message.dart';
import 'package:mobile_ui/Domain/constants.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.circle,
              size: 40,
              color: Colors.white,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Liam Mayston",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Online",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ChatCard(
                  message: messages[index],
                );
              },
            ),
          ),
          Container(
            color: Constants.darkGreyColor.withOpacity(0.88),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Constants.orangeColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Type message",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          cursorColor: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatCard extends StatefulWidget {
  const ChatCard({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  var isLiked = true;

  @override
  Widget build(BuildContext context) {
    bool rnd = Random().nextBool();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.5, horizontal: 15),
      child: Align(
        alignment: widget.message.isSender
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: IntrinsicWidth(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: InkWell(
                  onDoubleTap: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (rnd)
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.reply,
                                textDirection: TextDirection.rtl,
                                size: 16,
                                color: Colors.black.withOpacity(0.69),
                              ),
                              Text(
                                "Forwarded",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.69)),
                              ),
                            ],
                          ),
                        ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "12:34",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            if (!widget.message.isSender)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Icon(
                                  Icons.done_all,
                                  size: 16,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                        child: Text(widget.message.contents),
                        constraints: BoxConstraints(
                            maxWidth:
                                MediaQuery.of(context).size.width * (7 / 10)),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLiked)
                Container(
                  alignment: widget.message.isSender
                      ? Alignment.topLeft
                      : Alignment.topRight,
                  child: Icon(
                    Icons.favorite,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
