import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/dialogs/ConfirmDialog.dart';
import 'package:mobile/dialogs/DeleteMessagesDialog.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/AppService.dart';
import 'package:mobile/util/Tuple.dart';
import 'package:mobile/widgets/AvatarIcon.dart';
import 'package:mobx/mobx.dart';

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
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.contact.displayName.isNotEmpty
                ? widget.contact.displayName
                : widget.contact.phoneNumber,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _contact.status,
            style: TextStyle(
                fontSize: 14.0, color: Color.fromRGBO(61, 61, 61, 1.0)),
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
      title: Row(
        children: [
          AvatarIcon.fromString(_contact.profileImage),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: titlebar,
            ),
          )
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

  Container _buildMessage(Tuple<Message, bool> message) {
    Alignment alignment = Alignment.centerLeft;
    EdgeInsets padding = EdgeInsets.only(left: 16.0, right: 32.0);

    if (message.first.recipientPhoneNumber == widget.contact.phoneNumber) {
      alignment = Alignment.centerRight;
      padding = EdgeInsets.only(left: 32.0, right: 16.0);
    }

    return Container(
      alignment: alignment,
      color: message.second ? Color.fromRGBO(116, 152, 214, 0.3) : null,
      child: Padding(
        padding: padding,
        child: Wrap(
          children: [
            InkWell(
              onTap: () {
                if (_selecting) {
                  setState(() {
                    message.second = !message.second;
                  });
                }
              },
              onLongPress: () {
                setState(() {
                  _selecting = true;
                  message.second = true;
                });
              },
              child: Card(
                color: _messageColor(message.first),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    message.first.deleted
                        ? "This message was deleted."
                        : message.first.contents,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontStyle:
                          message.first.deleted ? FontStyle.italic : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _messageColor(Message m) {
    if (m.senderPhoneNumber == widget.contact.phoneNumber) {
      return Colors.orange;
    } else if (m.readReceipt == ReadReceipt.delivered) {
      return Colors.orange;
    } else {
      return Colors.orangeAccent;
    }
  }

  Container _buildInput() {
    return Container(
      color: Colors.orange,
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Colors.white54,
              child: TextField(
                maxLines: 4,
                minLines: 1,
                controller: _inputController,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: Icon(Icons.send),
          )
        ],
      ),
    );
  }

  void _sendMessage() {
    final recipientNumber = _contact.phoneNumber;
    final contents = _inputController.text;

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
