import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mobile/dialogs/ConfirmDialog.dart';
import 'package:mobile/dialogs/DeleteMessagesDialog.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/AppService.dart';
import 'package:mobile/util/Tuple.dart';
import 'package:mobile/widgets/AvatarIcon.dart';
import 'package:mobx/mobx.dart';

import '../constants.dart';

class ChatPage extends StatefulWidget {
  final Contact contact;

  ChatPage(this.contact);

  @override
  _ChatPageState createState() => _ChatPageState(this.contact);
}

class _ChatPageState extends State<ChatPage> {
  final AppService _appService = GetIt.I.get();

  final Contact _contact;

  List<Tuple<Message, bool>> _selectedMessages = [];
  late final ReactionDisposer _messagesDisposer;
  bool _selecting = false;

  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  _ChatPageState(this._contact);

  @override
  void initState() {
    super.initState();

    _messagesDisposer = autorun((_) {
      _appService.sendSeenAcknowledgementForContact(_contact.phoneNumber);

      setState(() {
        _selectedMessages = _appService.chatModel.chatMessages
            .map((m) => Tuple(m, false))
            .toList();
      });
    });

    _appService.chatModel.initContact(_contact.phoneNumber);
  }

  @override
  void dispose() {
    super.dispose();

    _messagesDisposer();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selecting) {
          setState(() {
            _selecting = false;
            _selectedMessages.forEach((m) => m.second = false);
          });
          return false;
        }

        return true;
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    Widget titlebar = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.contact.displayName.isNotEmpty
              ? widget.contact.displayName
              : widget.contact.phoneNumber,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        Text(
          _contact.status,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
    if (_contact.status.isEmpty) {
      titlebar = Text(
        widget.contact.displayName.isNotEmpty
            ? widget.contact.displayName
            : widget.contact.phoneNumber,
        overflow: TextOverflow.ellipsis,
      );
    }

    return AppBar(
      titleSpacing: 0,
      title: Row(
        children: [
          AvatarIcon.fromString(_contact.profileImage),
          SizedBox(
            width: 3,
          ),
          Expanded(
            child: titlebar,
          ),
        ],
      ),
      actions: [
        if (_selecting)
          IconButton(
            onPressed: () => _deleteMessages(context),
            icon: Icon(Icons.delete),
          )
      ],
    );
  }

  void _deleteMessages(BuildContext context) {
    final selectedMessages = _selectedMessages.where((m) => m.second);
    final selectedMessagesIds =
        selectedMessages.map((e) => e.first.id).toList();

    if (selectedMessages
        .any((m) => m.first.senderPhoneNumber == _contact.phoneNumber)) {
      showConfirmDialog(
        context,
        "You are about to delete ${selectedMessagesIds.length} message(s). Are you sure?",
      ).then((confirmed) {
        if (confirmed != null && confirmed) {
          _appService.chatModel.deleteMessages(selectedMessagesIds);
          setState(() {
            _selecting = false;
          });
        }
      });
    } else {
      showConfirmDeleteDialog(
        context,
        "You are about to delete ${selectedMessagesIds.length} message(s). Are you sure?",
      ).then((response) {
        if (response != null) {
          if (response == DeleteMessagesResponse.DELETE_FOR_EVERYONE) {
            _appService.requestDeleteMessages(
              _contact.phoneNumber,
              selectedMessagesIds,
            );

            _appService.chatModel.markMessagesDeleted(selectedMessagesIds);
          } else if (response == DeleteMessagesResponse.DELETE_FOR_ME) {
            _appService.chatModel.deleteMessages(selectedMessagesIds);
          }

          if (response != DeleteMessagesResponse.CANCEL) {
            setState(() {
              _selecting = false;
            });
          }
        }
      });
    }
  }

  SafeArea _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          Flexible(
            child: _buildMessages(),
          ),
          _buildInput()
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.pixels.floor() == metrics.maxScrollExtent.floor()) {
          _appService.chatModel.fetchNextMessagesPage();
        }
        return true;
      },
      child: ListView.builder(
        itemCount: _selectedMessages.length,
        itemBuilder: (context, index) {
          return _buildMessage(_selectedMessages[index]);
        },
        controller: _scrollController,
        reverse: true,
      ),
    );
  }

  ChatCard _buildMessage(Tuple<Message, bool> message) {
    return ChatCard(
      message.first,
      contact: _contact,
      onTap: () {
        setState(() {
          message.second = !message.second;
        });
      },
      onLongPress: () {
        setState(() {
          _selecting = true;
          message.second = true;
        });
      },
      selected: _selecting ? message.second : null,
    );
  }

  Container _buildInput() {
    return Container(
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              padding: EdgeInsets.only(
                top: 10,
                left: 5,
              ),
              onPressed: () {},
              icon: Icon(Icons.add_circle_outline),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(5, 20, 5, 10),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "Type message",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    maxLines: 4,
                    minLines: 1,
                    controller: _inputController,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.only(top: 10),
              onPressed: _sendMessage,
              icon: Icon(Icons.send),
            )
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final recipientNumber = _contact.phoneNumber;
    final contents = _inputController.text;

    if (contents.isEmpty) return;

    _appService.sendMessage(recipientNumber, contents).then((message) {
      _appService.chatModel.addMessage(message);
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 150),
        curve: Curves.easeIn,
      );
    });
    _inputController.text = "";
  }
}

class ChatCard extends StatelessWidget {
  final Contact contact;
  final Message _message;
  final void Function() onTap;
  final void Function() onLongPress;
  final bool? selected;

  ChatCard(
    this._message, {
    required this.contact,
    required this.onTap,
    required this.onLongPress,
    this.selected,
  });

  final dateFormatter = DateFormat("Hm");

  @override
  Widget build(BuildContext context) {
    var alignment = Alignment.centerRight;
    var padding = EdgeInsets.only(left: 100, right: 20);
    var color = Constants.orangeColor;

    if (_contactIsSender) {
      alignment = Alignment.centerLeft;
      padding = padding.flipped;
      color = Constants.darkGreyColor;
    }

    return Container(
      color: selected != null && selected == true
          ? Color.fromRGBO(116, 152, 214, 0.3)
          : null,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: padding,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Card(
              color: color.withOpacity(0.8),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 25, 8, 8),
                    child: Text(
                      _message.contents,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        dateFormatter.format(_message.timestamp),
                        style: TextStyle(fontSize: 11, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(35, 7, 8, 0),
                      child: _readReceipt(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool get _contactIsSender =>
      _message.senderPhoneNumber == contact.phoneNumber;

  Icon? _readReceipt() {
    if (_contactIsSender) {
      return null;
    }

    var icon = Icons.bookmark_border;
    // TODO read receipt logic
    return Icon(
      icon,
      size: 15,
      color: Colors.white,
    );
  }
}
