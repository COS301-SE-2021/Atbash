import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/models/ChatListModel.dart';
import 'package:mobile/models/UserModel.dart';
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
  final UserModel _userModel = GetIt.I.get();
  final ChatListModel _chatListModel = GetIt.I.get();
  final DateFormat dateFormatter = DateFormat.Hm();

  bool _searching = false;
  String _filterQuery = "";

  final _searchController = TextEditingController();
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();

    _chatListModel.init();

    _searchFocusNode = FocusNode();
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
                builder: (_) =>
                    AvatarIcon.fromString(_userModel.profileImage))),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Observer(builder: (_) {
                final displayName = _userModel.displayName;
                if (displayName == null || displayName.isEmpty) {
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
                  final status = _userModel.status;
                  if (status == null || status.isEmpty) {
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
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.orange,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    //TODO Add functionality for chats button
                  },
                  child: Container(
                    child: Text("Chats"),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                InkWell(
                  onTap: () {
                    //TODO Add functionality for private chats button
                  },
                  child: Container(
                    child: Text("Private Chats"),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(child: Observer(
            builder: (context) {
              return ListView(
                children: _buildChatList(_searching),
              );
            },
          )),
        ],
      ),
    );
  }

  List<InkWell> _buildChatList(bool filtered) {
    List<Chat> chats = _chatListModel.chats;

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

    Widget _buildRecentMessage() {
      if (message != null) {
        return Text(
          message.deleted ? "This message was deleted" : message.contents,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            color: Constants.darkGrey,
          ),
        );
      } else {
        return SizedBox.shrink();
      }
    }

    Widget _buildReadReceipt() {
      if (message != null && message.readReceipt != ReadReceipt.seen) {
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
            MaterialPageRoute(builder: (context) => ChatPage(chat: chat)));
      },
      child: Slidable(
        actionPane: SlidableScrollActionPane(),
        secondaryActions: [
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              _chatListModel.deleteChat(chat.id);
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
                              dateFormatter.format(message.timestamp),
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
