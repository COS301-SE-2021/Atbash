import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/models/ContactsModel.dart';
import 'package:mobile/models/UserModel.dart';
import 'package:mobile/pages/ChatPage.dart';
import 'package:mobile/pages/NewChatPage.dart';
import 'package:mobile/pages/SettingsPage.dart';
import 'package:mobile/services/AppService.dart';
import 'package:mobile/widgets/AvatarIcon.dart';
import 'package:mobile/constants.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final UserModel _userModel = GetIt.I.get();
  final ContactsModel _contactsModel = GetIt.I.get();
  final AppService _appService = GetIt.I.get();

  bool _searching = false;

  final _searchController = TextEditingController();
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();

    _searchFocusNode = FocusNode();

    _appService.goOnline();
  }

  @override
  void dispose() {
    super.dispose();
    _searchFocusNode.dispose();
    _appService.disconnect();
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
      _contactsModel.filter = "";
      _searchController.text = "";
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    Widget title = Row(
      children: [
        Container(
            margin: EdgeInsets.only(right: 16.0),
            child:
                Observer(builder: (_) => AvatarIcon(_userModel.profileImage))),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Observer(
                builder: (_) => Text(
                  _userModel.displayName,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Observer(
                builder: (_) => Text(
                  _userModel.status,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
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
              onPressed: () {
                setState(() {
                  _searching = true;
                });
              },
              icon: Icon(Icons.search)),
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

  void _filter(String searchQuery) {
    _contactsModel.filter = searchQuery;
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
                Container(
                  //TODO Add functionality for chats button
                  child: Text("Chats"),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Container(
                  //TODO Add functionality for private chats button
                  child: Text("Private Chats"),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Expanded(child: Observer(
            builder: (context) {
              return ListView(
                children: _contactsModel.filteredChatContacts
                    .map((each) => _buildChat(each))
                    .toList(),
              );
            },
          )),
        ],
      ),
    );
  }

  InkWell _buildChat(Contact contact) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatPage(contact)));
      },
      child: Slidable(
        actionPane: SlidableScrollActionPane(),
        secondaryActions: [
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              _contactsModel.deleteChatsWithContacts([contact.phoneNumber]);
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
                  child: AvatarIcon.fromString(contact.profileImage),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.displayName.isNotEmpty
                            ? contact.displayName
                            : contact.phoneNumber,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        //TODO Create preview message logic here
                        "This is a preview of the message. It can get really long but that's ok! Our app is built for these kinds of problems.",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Constants.darkGreyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //TODO Create timestamp logic here
                      Text("10:00"),
                      Icon(
                        Icons.circle,
                        //TODO Create read receipts logic here
                        color: Constants.orangeColor,
                      ),
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
          MaterialPageRoute(builder: (context) => NewChatPage()),
        );
      },
      child: Icon(Icons.chat),
    );
  }
}
