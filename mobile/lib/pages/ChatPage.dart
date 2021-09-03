import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mobile/controllers/ChatPageController.dart';
import 'package:mobile/dialogs/ConfirmDialog.dart';
import 'package:mobile/dialogs/DeleteMessagesDialog.dart';
import 'package:mobile/dialogs/ImageViewDialog.dart';
import 'package:mobile/dialogs/InputDialog.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/pages/ContactInfoPage.dart';
import 'package:mobile/util/Tuple.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/widgets/AvatarIcon.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class ChatPage extends StatefulWidget {
  final String chatId;

  const ChatPage({Key? key, required this.chatId}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState(chatId: chatId);
}

class _ChatPageState extends State<ChatPage> {
  final ChatPageController controller;

  _ChatPageState({required String chatId})
      : controller = ChatPageController(chatId: chatId);

  List<Tuple<Message, bool>> _messages = [];
  late final ReactionDisposer _messagesDisposer;
  bool _selecting = false;

  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _inputController.text = controller.getTypedMessage();
    _messagesDisposer = autorun((_) {
      setState(() {
        _messages =
            controller.model.messages.map((m) => Tuple(m, false)).toList();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.storeTypedMessage(_inputController.text);
    _messagesDisposer();
    controller.dispose();
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
          return Text(
            controller.model.contactTitle,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          );
        }),
        Observer(builder: (_) {
          final online = controller.model.online;

          if (online) {
            return Text(
              "Online",
              style: TextStyle(fontSize: 12, color: Colors.black),
            );
          } else {
            return SizedBox.shrink();
          }
        })
      ],
    );

    return AppBar(
      titleSpacing: 0,
      title: InkWell(
        highlightColor: _selecting ? Colors.transparent : null,
        splashFactory: _selecting ? NoSplash.splashFactory : null,
        enableFeedback: _selecting ? false : true,
        onTap: () {
          if (!_selecting)
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContactInfoPage(
                        phoneNumber: controller.contactPhoneNumber)));
        },
        child: Row(
          children: [
            Observer(
              builder: (_) =>
                  AvatarIcon.fromString(controller.model.contactProfileImage),
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: titleBar,
            ),
          ],
        ),
      ),
      actions: [
        if (!_selecting)
          Observer(builder: (_) {
            if (!controller.model.contactSaved) {
              return IconButton(
                onPressed: () {
                  showInputDialog(context, "Name?").then((name) {
                    if (name != null) {
                      controller.addSenderAsContact(name);
                    }
                  });
                },
                icon: Icon(Icons.person_add),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        if (_selecting)
          IconButton(
            onPressed: () => _deleteMessages(context),
            icon: Icon(Icons.delete),
          ),
        if (_selecting)
          IconButton(
            onPressed: () {
              _copyMessages();
            },
            icon: Icon(Icons.copy),
          ),
        if (!_selecting)
          Observer(builder: (_) {
            if (controller.model.chatType != ChatType.private)
              return IconButton(onPressed: () {}, icon: Icon(Icons.lock));
            else
              return SizedBox.shrink();
          })
      ],
    );
  }

  void _deleteMessages(BuildContext context) {
    final selectedMessages = _messages.where((m) => m.second);
    if (selectedMessages.isNotEmpty) {
      final selectedMessagesIds =
          selectedMessages.map((e) => e.first.id).toList();

      if (selectedMessages.any((m) => m.first.isIncoming || m.first.deleted)) {
        showConfirmDialog(
          context,
          "You are about to delete ${selectedMessagesIds.length} message(s). Are you sure?",
        ).then((confirmed) {
          if (confirmed == true) {
            controller.deleteMessagesLocally(selectedMessagesIds);
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
                .forEach((id) => controller.deleteMessagesRemotely([id]));
          } else if (response == DeleteMessagesResponse.DELETE_FOR_ME) {
            controller.deleteMessagesLocally(selectedMessagesIds);
          }

          if (response != DeleteMessagesResponse.CANCEL) {
            _stopSelecting();
          }
        });
      }
    } else {
      showSnackBar(context, "No messages selected");
    }
  }

  void _deleteSingleMessage(Message message) {
    if (message.isIncoming || message.deleted) {
      showConfirmDialog(
        context,
        "You are about to delete this message. Are you sure?",
      ).then((confirmed) {
        if (confirmed == true) {
          controller.deleteMessagesLocally([message.id]);
        }
      });
    } else {
      showConfirmDeleteDialog(
        context,
        "You are about to delete this message. Are you sure?",
      ).then((response) {
        if (response == DeleteMessagesResponse.DELETE_FOR_EVERYONE) {
          controller.deleteMessagesRemotely([message.id]);
        } else if (response == DeleteMessagesResponse.DELETE_FOR_ME) {
          controller.deleteMessagesLocally([message.id]);
        }
      });
    }
  }

  void _copyMessages() {
    final selectedMessages = _messages.where((m) => m.second).toList();

    if (selectedMessages.isNotEmpty) {
      String result = "";
      final format = intl.DateFormat("dd/MM HH:mm");

      selectedMessages.reversed.forEach((message) {
        if (!message.first.deleted) {
          result +=
              "[${format.format(message.first.timestamp)}] ${message.first.contents}\n";
        }
      });

      result = result.substring(0, result.length - 1);

      Clipboard.setData(ClipboardData(text: result));
      _stopSelecting();
    } else {
      showSnackBar(context, "No messages selected");
    }
  }

  void _likeMessage(Message message) {
    if (!message.isIncoming) return;

    controller.likeMessage(message.id, !message.liked);
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
    int numMillisPerDay = 1000 * 60 * 60 * 24;
    //int numMillisPerYear = numMillisPerDay * 365;

    int curDay = (_messages[index].first.timestamp.millisecondsSinceEpoch /
            numMillisPerDay)
        .floor();
    int prevDay = index == _messages.length - 1
        ? 0
        : (_messages[index + 1].first.timestamp.millisecondsSinceEpoch /
                numMillisPerDay)
            .floor();
    // int curYear = (_messages[index].first.timestamp.millisecondsSinceEpoch /
    //         numMillisPerYear)
    //     .floor();
    // int prevYear = index == _messages.length - 1
    //     ? DateTime.now().year
    //     : (_messages[index + 1].first.timestamp.millisecondsSinceEpoch /
    //             numMillisPerYear)
    //         .floor();

    int today =
        (DateTime.now().millisecondsSinceEpoch / numMillisPerDay).floor();

    if (curDay > prevDay) {
      if (curDay == today) return "Today";

      if (today - curDay == 1) return "Yesterday";

      if (today - curDay < 7)
        return intl.DateFormat("EEEE").format(_messages[index].first.timestamp);

      //TODO: Order by year if it goes too far back
      // if (prevYear < curYear)
      //   return intl.DateFormat.yMMMd().format(_messages[index].first.timestamp);

      return intl.DateFormat("EEE, dd MMM")
          .format(_messages[index].first.timestamp);
    }

    //TODO: implement year differences. eg. Fri, 22 Mar = 22 Mar 2020

    return "";
  }

  ChatCard _buildMessage(Tuple<Message, bool> message) {
    return ChatCard(
      message.first,
      onTap: () {
        if (_selecting) {
          setState(() {
            message.second = !message.second;
          });
        } else {
          if (message.first.isMedia) {
            showImageViewDialog(context, base64Decode(message.first.contents));
          }
        }
      },
      onSelect: () {
        setState(() {
          _selecting = true;
          message.second = true;
        });
      },
      onDelete: () => _deleteSingleMessage(message.first),
      selected: _selecting && message.second,
      onDoubleTap: () => _likeMessage(message.first),
      onForwardPressed: () =>
          controller.forwardMessage(context, message.first.contents),
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
              onPressed: _sendImage,
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

    if (contents.trim().isEmpty) return;

    _inputController.text = "";

    controller.sendMessage(contents);
  }

  void _sendImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final file = File(pickedImage.path);
      final imageBytes = await file.readAsBytes();
      controller.sendImage(imageBytes);
    }
  }
}

class ChatCard extends StatelessWidget {
  final Message _message;
  final void Function() onTap;
  final void Function() onSelect;
  final void Function() onDelete;
  final bool selected;
  final void Function() onDoubleTap;
  final void Function() onForwardPressed;

  ChatCard(
    this._message, {
    required this.onTap,
    required this.onSelect,
    required this.onDelete,
    required this.selected,
    required this.onDoubleTap,
    required this.onForwardPressed,
  });

  final dateFormatter = intl.DateFormat("Hm");

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 2.5),
        child: Align(
          alignment: _message.isIncoming
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: IntrinsicWidth(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _message.isIncoming
                        ? Constants.darkGrey.withOpacity(0.88)
                        : Constants.orange.withOpacity(0.88),
                  ),
                  child: InkWell(
                    onDoubleTap: onDoubleTap,
                    child: FocusedMenuHolder(
                      animateMenuItems: false,
                      blurSize: 2,
                      blurBackgroundColor: Constants.black,
                      menuWidth: MediaQuery.of(context).size.width * 0.4,
                      onPressed: onTap,
                      menuItemExtent: 40,
                      menuItems: [
                        FocusedMenuItem(
                            title: Text("Select"),
                            onPressed: onSelect,
                            trailingIcon: Icon(Icons.check_box_outline_blank)),
                        if (!_message.deleted)
                          FocusedMenuItem(
                              title: Text("Tag"),
                              onPressed: () {},
                              trailingIcon: Icon(Icons.tag)),
                        if (!_message.deleted)
                          FocusedMenuItem(
                              title: Text("Forward"),
                              onPressed: () {
                                onForwardPressed();
                              },
                              trailingIcon: Icon(Icons.forward)),
                        if (!_message.deleted)
                          FocusedMenuItem(
                              title: Text("Copy"),
                              onPressed: () => Clipboard.setData(
                                  ClipboardData(text: _message.contents)),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          //if(isForwarded)
                          // Container(
                          //   child: Row(
                          //     children: [
                          //       Icon(
                          //         Icons.reply,
                          //         textDirection: TextDirection.rtl,
                          //         size: 16,
                          //         color: Colors.white.withOpacity(0.69),
                          //       ),
                          //       Text(
                          //         "Forwarded",
                          //         style: TextStyle(
                          //             fontSize: 12,
                          //             color: Colors.white.withOpacity(0.69)),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            child: _renderMessageContents(),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  dateFormatter.format(_message.timestamp),
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                if (!_message.isIncoming)
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2),
                                    child: _readReceipt(),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_message.liked)
                  Container(
                    alignment: _message.isIncoming
                        ? Alignment.topLeft
                        : Alignment.topRight,
                    child: Icon(
                      Icons.favorite,
                      size: 16,
                      color: _message.isIncoming
                          ? Constants.orange
                          : Constants.darkGrey,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _renderMessageContents() {
    if (_message.isMedia) {
      return Image.memory(
        base64Decode(_message.contents),
        height: 200,
      );
    } else {
      return Text(
        _message.deleted ? "This message was deleted" : _message.contents,
        style: TextStyle(
          color: Colors.white,
          fontStyle: _message.deleted ? FontStyle.italic : null,
        ),
      );
    }
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
