import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:mobile/controllers/HomePageController.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/pages/ChatPage.dart';
import 'package:mobile/widgets/AvatarIcon.dart';

import '../constants.dart';
import 'ContactsPage.dart';
import 'SettingsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomePageController();
  final DateFormat dateFormatter = DateFormat.Hm();

  bool _searching = false;
  String _filterQuery = "";

  final _searchController = TextEditingController();
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();

    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _searchFocusNode.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = true;

        if (_searching) {
          _stopSearching();
          shouldPop = false;
        }
        return shouldPop;
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(context),
      ),
    );
  }

  void _stopSearching() {
    setState(() {
      _searching = false;
      _filterQuery = "";
    });
    _searchController.text = "";
  }

  void _startSearching() {
    setState(() {
      _searching = true;
      _filterQuery = "";
    });
    _searchController.text = "";
    _searchFocusNode.requestFocus();
  }

  void _filter(String searchQuery) {
    setState(() {
      _filterQuery = searchQuery;
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    Widget title = Row(
      children: [
        Container(
            margin: EdgeInsets.only(right: 16.0),
            child: Observer(
                builder: (_) => AvatarIcon(controller.model.userProfileImage))),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Observer(builder: (_) {
                final displayName = controller.model.userDisplayName;
                if (displayName.isEmpty) {
                  return SizedBox.shrink();
                } else {
                  return Text(
                    displayName,
                    key: Key("displayName"),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  );
                }
              }),
              SizedBox(
                height: 2,
              ),
              Observer(
                builder: (_) {
                  final status = controller.model.userStatus;
                  if (status.isEmpty) {
                    return SizedBox.shrink();
                  } else {
                    return Text(
                      status,
                      key: Key("status"),
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ],
    );

    if (_searching) {
      title = TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: _filter,
        decoration: InputDecoration(border: InputBorder.none),
        key: Key("searchField"),
      );

      _searchFocusNode.requestFocus();
    }

    return AppBar(
      title: title,
      leading: _searching
          ? IconButton(
              onPressed: () {
                if (_searching) _stopSearching();
              },
              icon: Icon(Icons.arrow_back),
            )
          : null,
      actions: [
        if (!_searching)
          IconButton(
            onPressed: _startSearching,
            icon: Icon(Icons.search),
            key: Key("searchButton"),
          ),
        PopupMenuButton(
          icon: new Icon(Icons.more_vert),
          itemBuilder: (context) {
            return ["Settings"].map((menuItem) {
              return PopupMenuItem(
                child: Text(menuItem),
                value: menuItem,
              );
            }).toList();
          },
          onSelected: (value) {
            if (value == "Settings") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            }
          },
        ),
      ],
    );
  }

  SafeArea _buildBody() {
    return SafeArea(
      child: Observer(
        builder: (context) {
          return ListView(
            children: _buildChatList(_searching),
          );
        },
      ),
    );
  }

  List<InkWell> _buildChatList(bool filtered) {
    List<Chat> chats = controller.model.orderedChats;

    if (filtered) {
      final filterQuery = _filterQuery.toLowerCase();
      chats = chats
          .where((c) =>
              c.contactPhoneNumber.contains(filterQuery) ||
              c.contact?.displayName.contains(filterQuery) == true)
          .toList();
    }

    return chats.map((e) => _buildChatItem(e)).toList();
  }

  InkWell _buildChatItem(Chat chat) {
    final contact = chat.contact;
    final message = chat.mostRecentMessage;

    Widget _buildDisplayName() {
      if (contact != null && contact.displayName.isNotEmpty) {
        return Text(
          contact.displayName,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        );
      } else {
        return Text(
          chat.contactPhoneNumber,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        );
      }
    }

    Container? _buildOutgoingReadReceipt(Message message) {
      if (message.isIncoming) {
        return null;
      }

      final readReceipt = message.readReceipt;

      var icon = Icons.clear;
      if (readReceipt == ReadReceipt.delivered) {
        icon = Icons.done;
      } else if (readReceipt == ReadReceipt.seen) {
        icon = Icons.done_all;
      }

      return Container(
        margin: const EdgeInsets.only(right: 4),
        child: Icon(icon, size: 15, color: Colors.black),
      );
    }

    Text _buildMessagePreview(Message message) {
      var preview = "";

      if (message.deleted) {
        preview = "This message was deleted";
      } else if (message.isMedia) {
        preview = "\u{1f4f7} Photo";
      } else {
        preview = message.contents;
      }

      return Text(
        preview,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          color: Constants.darkGrey,
        ),
      );
    }

    Widget _buildRecentMessage() {
      if (message != null) {
        return Row(
          children: [
            _buildOutgoingReadReceipt(message) ?? SizedBox.shrink(),
            Expanded(child: _buildMessagePreview(message)),
          ],
        );
      } else {
        return SizedBox.shrink();
      }
    }

    Widget _buildReadReceipt() {
      if (message != null &&
          message.isIncoming &&
          message.readReceipt != ReadReceipt.seen) {
        return Icon(
          Icons.circle,
          color: Constants.orange,
          size: 16,
        );
      } else {
        return Icon(
          Icons.circle,
          color: Color.fromRGBO(0, 0, 0, 0),
          size: 16,
        );
      }
    }

    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatPage(chatId: chat.id)));
      },
      child: Slidable(
        actionPane: SlidableScrollActionPane(),
        secondaryActions: [
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              controller.deleteChat(chat.id);
            },
          ),
        ],
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: AvatarIcon.fromString(
                      contact != null ? contact.profileImage : ""),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDisplayName(),
                      SizedBox(
                        height: 2,
                      ),
                      _buildRecentMessage(),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      message != null
                          ? Text(
                              _createMessageDate(message.timestamp),
                            )
                          : SizedBox.shrink(),
                      _buildReadReceipt(),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              height: 6,
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContactsPage()),
        );
      },
      child: Icon(Icons.chat),
    );
  }
}

String _createMessageDate(DateTime timestamp) {
  int messageDay =
      (timestamp.millisecondsSinceEpoch / 1000 / 60 / 60 / 24).floor();

  int today =
      (DateTime.now().millisecondsSinceEpoch / 1000 / 60 / 60 / 24).floor();

  if (today == messageDay) return DateFormat.Hm().format(timestamp);

  if (today - messageDay == 1) return "Yesterday";

  if (today - messageDay < 7) return DateFormat.EEEE().format(timestamp);

  //TODO: implement year differences. eg. Fri, 22 Mar = 22 Mar 2020

  return DateFormat("y/MM/dd").format(timestamp);
}
