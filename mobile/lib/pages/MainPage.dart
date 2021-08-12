import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/dialogs/ConfirmDialog.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/models/ContactsModel.dart';
import 'package:mobile/models/UserModel.dart';
import 'package:mobile/pages/ChatPage.dart';
import 'package:mobile/pages/NewChatPage.dart';
import 'package:mobile/pages/SettingsPage.dart';
import 'package:mobile/services/AppService.dart';
import 'package:mobile/util/Tuple.dart';
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

  List<Tuple<Contact, bool>> _selectedContacts = [];
  late final ReactionDisposer _contactsDisposer;

  bool _searching = false;
  bool _selecting = false;

  final _searchController = TextEditingController();
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();

    _contactsDisposer = autorun((_) {
      setState(() {
        _selectedContacts = _contactsModel.filteredChatContacts
            .map((each) => Tuple(each, false))
            .toList();
      });
    });

    _searchFocusNode = FocusNode();

    _appService.goOnline();
  }

  @override
  void dispose() {
    super.dispose();
    _contactsDisposer();
    _searchFocusNode.dispose();
    _appService.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = true;

        if (_selecting) {
          _stopSelecting();
          shouldPop = false;
        }

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

  void _stopSelecting() {
    setState(() {
      _selecting = false;
      _selectedContacts.forEach((element) => element.second = false);
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
              Text(
                _userModel.displayName,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 2,
              ),
              if (_userModel.status.isNotEmpty)
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
      leading: _searching || _selecting
          ? IconButton(
              onPressed: () {
                if (_searching) _stopSearching();
                if (_selecting) _stopSelecting();
              },
              icon: Icon(Icons.arrow_back),
            )
          : null,
      actions: [
        if (!_selecting && !_searching)
          IconButton(
              onPressed: () {
                setState(() {
                  _searching = true;
                });
              },
              icon: Icon(Icons.search)),
        if (_selecting)
          IconButton(
            onPressed: () {
              final selectedChats = _selectedContacts
                  .where((element) => element.second == true)
                  .map((e) => e.first.phoneNumber)
                  .toList();

              showConfirmDialog(context,
                      "This will delete ${selectedChats.length} chat(s). Are you sure?")
                  .then((confirmed) {
                if (confirmed != null && confirmed) {
                  _contactsModel.deleteChatsWithContacts(selectedChats);
                }
              });
            },
            icon: Icon(Icons.delete),
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
          Expanded(
            child: ListView(
              children:
                  _selectedContacts.map((each) => _buildChat(each)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  InkWell _buildChat(Tuple<Contact, bool> contact) {
    return InkWell(
      onTap: () {
        if (_selecting) {
          setState(() {
            contact.second = !contact.second;
          });
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ChatPage(contact.first)));
        }
      },
      onLongPress: () {
        if (!_searching) {
          setState(() {
            _selecting = true;
            contact.second = true;
          });
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: AvatarIcon.fromString(contact.first.profileImage),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.first.displayName.isNotEmpty
                          ? contact.first.displayName
                          : contact.first.phoneNumber,
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
              if (_selecting)
                Checkbox(
                    value: contact.second,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          contact.second = value;
                        });
                      }
                    }),
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
