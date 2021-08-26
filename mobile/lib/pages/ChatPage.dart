import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mobile/dialogs/ConfirmDialog.dart';
import 'package:mobile/dialogs/DeleteMessagesDialog.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/models/MessagesModel.dart';
import 'package:mobile/models/UserModel.dart';
import 'package:mobile/util/Tuple.dart';
import 'package:mobile/widgets/AvatarIcon.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  const ChatPage({Key? key, required this.chat}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final MessagesModel messagesModel = GetIt.I.get();
  final UserModel userModel = GetIt.I.get();

  List<Tuple<Message, bool>> _messages = [];
  late final ReactionDisposer _messagesDisposer;
  bool _selecting = false;

  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    messagesModel.enterChat(widget.chat);

    _messagesDisposer = autorun((_) {
      setState(() {
        _messages = messagesModel.messages.map((m) => Tuple(m, false)).toList();
      });
    });
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
          _stopSelecting();
          return false;
        }

        return true;
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/wallpaper.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _buildAppBar(context),
          body: _buildBody(),
        ),
      ),
    );
  }

  void _stopSelecting() {
    setState(() {
      _selecting = false;
      _messages.forEach((m) => m.second = false);
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    Widget titleBar = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Observer(builder: (_) {
          final contact = widget.chat.contact;

          return Text(
            contact != null && contact.displayName.isNotEmpty
                ? contact.displayName
                : widget.chat.contactPhoneNumber,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          );
        }),
        Observer(builder: (_) {
          final contact = widget.chat.contact;

          if (contact != null && contact.status.isNotEmpty) {
            return Text(
              contact.status,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        })
      ],
    );

    return AppBar(
      titleSpacing: 0,
      title: Row(
        children: [
          Observer(
            builder: (_) =>
                AvatarIcon.fromString(widget.chat.contact?.profileImage),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: titleBar,
          ),
        ],
      ),
      actions: [
        if (_selecting)
          IconButton(
            onPressed: () => _deleteMessages(context),
            icon: Icon(Icons.delete),
          ),
      ],
    );
  }

  void _deleteMessages(BuildContext context) {
    final selectedMessages = _messages.where((m) => m.second);
    final selectedMessagesIds =
        selectedMessages.map((e) => e.first.id).toList();

    if (selectedMessages.any((m) => m.first.isIncoming || m.first.deleted)) {
      showConfirmDialog(
        context,
        "You are about to delete ${selectedMessagesIds.length} message(s). Are you sure?",
      ).then((confirmed) {
        if (confirmed == true) {
          selectedMessagesIds
              .forEach((id) => messagesModel.deleteMessageLocally(id));
          _stopSelecting();
        }
      });
    } else {
      showConfirmDeleteDialog(
        context,
        "You are about to delete ${selectedMessagesIds.length} message(s). Are you sure?",
      ).then((response) {
        if (response == DeleteMessagesResponse.DELETE_FOR_EVERYONE) {
          selectedMessagesIds
              .forEach((id) => messagesModel.sendDeleteMessageRequest(id));
        } else if (response == DeleteMessagesResponse.DELETE_FOR_ME) {
          selectedMessagesIds
              .forEach((id) => messagesModel.deleteMessageLocally(id));
        }

        if (response != DeleteMessagesResponse.CANCEL) {
          _stopSelecting();
        }
      });
    }
  }

  void _deleteSingleMessage(Message message) {
    if (message.isIncoming || message.deleted) {
      showConfirmDialog(
        context,
        "You are about to delete this message. Are you sure?",
      ).then((confirmed) {
        if (confirmed == true) {
          messagesModel.deleteMessageLocally(message.id);
        }
      });
    } else {
      showConfirmDeleteDialog(
        context,
        "You are about to delete this message. Are you sure?",
      ).then((response) {
        if (response == DeleteMessagesResponse.DELETE_FOR_EVERYONE) {
          messagesModel.sendDeleteMessageRequest(message.id);
        } else if (response == DeleteMessagesResponse.DELETE_FOR_ME) {
          messagesModel.deleteMessageLocally(message.id);
        }
        setState(() {});
      });
    }
  }

  SafeArea _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          Flexible(child: _buildMessages()),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.pixels.floor() == metrics.maxScrollExtent.floor()) {
          // TODO tell model to fetch more messages
        }
        return true;
      },
      child: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (_, index) {
          String dateString = _chatDateString(index);

          if (dateString != "")
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Constants.white.withOpacity(0.88),
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: Text(
                    dateString,
                  ),
                ),
                _buildMessage(_messages[index]),
              ],
            );
          return _buildMessage(_messages[index]);
        },
        controller: _scrollController,
        reverse: true,
      ),
    );
  }

  String _chatDateString(int index) {
    String ans = "";

    int curDay = (_messages[index].first.timestamp.millisecondsSinceEpoch /
            1000 /
            60 /
            60 /
            24)
        .floor();
    int prevDay = index == _messages.length - 1
        ? 0
        : (_messages[index + 1].first.timestamp.millisecondsSinceEpoch /
                1000 /
                60 /
                60 /
                24)
            .floor();
    int today =
        (DateTime.now().millisecondsSinceEpoch / 1000 / 60 / 60 / 24).floor();

    if (curDay > prevDay) {
      if (curDay == today) return "Today";

      if (today - curDay < 7)
        return DateFormat("EEEE").format(_messages[index].first.timestamp);

      return DateFormat("EEE, dd MMM").format(_messages[index].first.timestamp);
    }

    return ans;
  }

  ChatCard _buildMessage(Tuple<Message, bool> message) {
    return ChatCard(
      message.first,
      contactPhoneNumber: widget.chat.contactPhoneNumber,
      onTap: () {
        setState(() {
          message.second = !message.second;
        });
      },
      onSelect: () {
        setState(() {
          _selecting = true;
          message.second = true;
        });
      },
      onDelete: () => _deleteSingleMessage(message.first),
      selected: _selecting && message.second,
    );
  }

  Container _buildInput() {
    return Container(
      color: Constants.darkGrey.withOpacity(0.88),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              padding: EdgeInsets.only(
                top: 10,
                left: 5,
              ),
              onPressed: () {},
              icon: Icon(
                Icons.add_circle_outline,
                color: Constants.white,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(5, 20, 5, 10),
                decoration: BoxDecoration(
                  color: Constants.orange,
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
              icon: Icon(
                Icons.send,
                color: Constants.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final contents = _inputController.text;

    _inputController.text = "";

    userModel.phoneNumber.then((userPhoneNumber) {
      if (userPhoneNumber == null) {
        throw StateError(
            "User phone number was null when trying to send a message");
      }

      messagesModel.sendMessage(widget.chat.id, contents);
    });
  }
}

class ChatCard extends StatelessWidget {
  final String contactPhoneNumber;
  final Message _message;
  final void Function() onTap;
  final void Function() onSelect;
  final void Function() onDelete;
  final bool selected;

  ChatCard(
    this._message, {
    required this.contactPhoneNumber,
    required this.onTap,
    required this.onSelect,
    required this.onDelete,
    required this.selected,
  });

  final dateFormatter = DateFormat("Hm");

  @override
  Widget build(BuildContext context) {
    var alignment = Alignment.centerRight;
    var padding = EdgeInsets.only(left: 100, right: 20);
    var color = Constants.orange;

    if (_message.isIncoming) {
      alignment = Alignment.centerLeft;
      padding = padding.flipped;
      color = Constants.darkGrey;
    }

    return Container(
      color: selected ? Color.fromRGBO(116, 152, 214, 0.3) : null,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: padding,
          child: FocusedMenuHolder(
            blurSize: 2,
            blurBackgroundColor: Constants.black,
            menuWidth: MediaQuery.of(context).size.width * 0.4,
            onPressed: onTap,
            menuItemExtent: 40,
            menuItems: <FocusedMenuItem>[
              FocusedMenuItem(
                  title: Text("Select"),
                  onPressed: onSelect,
                  trailingIcon: Icon(Icons.check_box_outline_blank)),
              FocusedMenuItem(
                  title: Text("Tag"),
                  onPressed: () {},
                  trailingIcon: Icon(Icons.tag)),
              FocusedMenuItem(
                  title: Text("Forward"),
                  onPressed: () {},
                  trailingIcon: Icon(Icons.forward)),
              FocusedMenuItem(
                  title: Text("Copy"),
                  onPressed: () =>
                      Clipboard.setData(ClipboardData(text: _message.contents)),
                  trailingIcon: Icon(Icons.copy)),
              FocusedMenuItem(
                  title: Text(
                    "Delete",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: onDelete,
                  trailingIcon: Icon(
                    Icons.delete,
                    color: Constants.white,
                  ),
                  backgroundColor: Colors.redAccent),
            ],
            child: Card(
              color: color.withOpacity(0.8),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 25, 8, 8),
                    child: Text(
                      _message.deleted
                          ? "This message was deleted"
                          : _message.contents,
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: _message.deleted ? FontStyle.italic : null,
                      ),
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
                      padding: const EdgeInsets.fromLTRB(40, 5.5, 8, 0),
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

  Icon? _readReceipt() {
    if (_message.isIncoming) {
      return null;
    }

    var icon = Icons.clear;
    if (_message.readReceipt == ReadReceipt.delivered) {
      icon = Icons.done;
    } else if (_message.readReceipt == ReadReceipt.seen) {
      icon = Icons.done_all;
    }
    return Icon(
      icon,
      size: 15,
      color: Colors.white,
    );
  }
}
