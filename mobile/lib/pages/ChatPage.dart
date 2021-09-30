import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mobile/controllers/ChatPageController.dart';
import 'package:mobile/dialogs/ConfirmDialog.dart';
import 'package:mobile/dialogs/DeleteMessagesDialog.dart';
import 'package:mobile/dialogs/ImageViewDialog.dart';
import 'package:mobile/dialogs/InputDialog.dart';
import 'package:mobile/dialogs/MessageEditDialog.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/domain/ProfanityWord.dart';
import 'package:mobile/pages/ContactInfoPage.dart';
import 'package:mobile/util/Utils.dart';
import 'package:mobile/widgets/AvatarIcon.dart';
import 'package:mobile/util/Extensions.dart';
import 'package:mobx/mobx.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../constants.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final Chat? privateChat;
  final bool isInitiator;

  const ChatPage({Key? key, required this.chatId})
      : privateChat = null,
        isInitiator = false,
        super(key: key);

  ChatPage.privateChat({
    required this.chatId,
    this.privateChat,
    this.isInitiator = false,
  });

  @override
  _ChatPageState createState() => _ChatPageState(
        chatId: chatId,
        privateChat: privateChat,
        privateChatIsInitiator: isInitiator,
      );
}

class _ChatPageState extends State<ChatPage> {
  final ChatPageController controller;

  _ChatPageState({
    required String chatId,
    Chat? privateChat,
    required bool privateChatIsInitiator,
  }) : controller = ChatPageController(
          chatId: chatId,
          privateChat: privateChat,
          privateChatIsInitiator: privateChatIsInitiator,
        );

  late final ReactionDisposer _backgroundDisposer;
  bool _selecting = false;
  bool _replying = false;
  Message? _replyingMessage;

  final _inputController = TextEditingController();
  final _scrollController = ItemScrollController();

  ImageProvider? backgroundImage;

  @override
  void initState() {
    super.initState();
    _inputController.text = controller.getTypedMessage();

    _backgroundDisposer =
        reaction((_) => controller.model.wallpaperImage, (wallpaperImage) {
      if (wallpaperImage != null) {
        setState(() {
          backgroundImage = MemoryImage(base64Decode(wallpaperImage as String));
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.storeTypedMessage(_inputController.text);
    _backgroundDisposer();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.model.chatType == ChatType.private)
          controller.stopPrivateChat();
        Navigator.popUntil(context, ModalRoute.withName("/"));
        return false;
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: backgroundImage ?? AssetImage("assets/wallpaper.jpg"),
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
        Observer(builder: (_) {
          if (!controller.model.contactSaved) {
            return IconButton(
              onPressed: () {
                showInputDialog(
                  context,
                  "Add Contact",
                  hint: "Enter contact name",
                ).then((name) {
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
        Observer(builder: (_) {
          if (controller.model.chatType != ChatType.private &&
              controller.model.privateChatAccess)
            return IconButton(
              onPressed: () {
                controller.startPrivateChat(context);
              },
              icon: Icon(Icons.lock),
            );
          else
            return SizedBox.shrink();
        })
      ],
    );
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

  void _likeMessage(Message message) {
    if (!message.isIncoming) return;

    controller.likeMessage(message.id, !message.liked);
  }

  SafeArea _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          Flexible(child: _buildMessages()),
          if (_replying == true)
            Container(
              decoration: BoxDecoration(
                color: Constants.darkGrey.withOpacity(0.88),
              ),
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${_replyingMessage?.isIncoming == true ? controller.model.contactTitle : 'You'}\n${_replyingMessage?.contents ?? 'aa'}",
                      style: TextStyle(color: Colors.white),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _replying = false;
                        _replyingMessage = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return Observer(builder: (_) {
      return ScrollablePositionedList.builder(
        itemScrollController: _scrollController,
        itemCount: controller.model.messages.length + 1,
        itemBuilder: (_, index) {
          if (index == controller.model.messages.length) {
            return Observer(builder: (_) {
              if (controller.model.chatType == ChatType.private)
                return Center(
                  child: Container(
                    margin:
                        EdgeInsets.only(left: 60, right: 60, top: 5, bottom: 5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white12.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Private chats are end-to-end encrypted and are PERMANENTLY removed when either party leaves",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              return SizedBox.shrink();
            });
          }

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
                _buildMessage(controller.model.messages[index]),
              ],
            );
          return _buildMessage(controller.model.messages[index]);
        },
        reverse: true,
      );
    });
  }

  String _chatDateString(int index) {
    int numMillisPerDay = 1000 * 60 * 60 * 24;
    //int numMillisPerYear = numMillisPerDay * 365;

    int curDay =
        (controller.model.messages[index].timestamp.millisecondsSinceEpoch /
                numMillisPerDay)
            .floor();
    int prevDay = index == controller.model.messages.length - 1
        ? 0
        : (controller.model.messages[index + 1].timestamp
                    .millisecondsSinceEpoch /
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
        return intl.DateFormat("EEEE")
            .format(controller.model.messages[index].timestamp);

      //TODO: Order by year if it goes too far back
      // if (prevYear < curYear)
      //   return intl.DateFormat.yMMMd().format(_messages[index].first.timestamp);

      return intl.DateFormat("EEE, dd MMM")
          .format(controller.model.messages[index].timestamp);
    }

    //TODO: implement year differences. eg. Fri, 22 Mar = 22 Mar 2020

    return "";
  }

  ChatCard _buildMessage(Message message) {
    final repliedMessage = message.repliedMessageId != null
        ? controller.model.messages
            .firstWhereOrNull((m) => m.id == message.repliedMessageId)
        : null;

    return ChatCard(
      message,
      onTap: () {
        if (message.isMedia) {
          showImageViewDialog(context, base64Decode(message.contents),
              controller.model.blockSaveMedia);
        }
      },
      onDelete: () => _deleteSingleMessage(message),
      onDoubleTap: () => _likeMessage(message),
      onForwardPressed: () => controller.forwardMessage(
          context, message, controller.model.contactTitle),
      onEditPressed: () => _editMessage(message),
      onReplyPressed: () => _startReplying(message),
      onRepliedMessagePressed: () {
        _scrollController.jumpTo(
          index: controller.model.messages
              .indexWhere((m) => m.id == repliedMessage?.id),
          alignment: 0.5,
        );
      },
      onMediaDownload: () => _saveImage(base64Decode(message.contents)),
      contactTitle: controller.model.contactTitle,
      blurImages: controller.model.blurImages,
      profanityFilter: controller.model.profanityFilter,
      blockDeletingMessages: controller.model.blockDeletingMessages,
      blockEditingMessages: controller.model.blockEditingMessages,
      blockSaveMedia: controller.model.blockSaveMedia,
      chatType: controller.model.chatType,
      repliedMessage: repliedMessage,
      words: controller.model.profanityWords,
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
                    cursorColor: Constants.black,
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

    if (_replyingMessage != null) {
      controller.replyToMessage(contents, _replyingMessage?.id);
      setState(() {
        _replying = false;
        _replyingMessage = null;
      });
    } else
      controller.sendMessage(contents);
  }

  void _editMessage(Message message) {
    showEditMessageDialog(context, message.contents).then((newMessage) {
      if (newMessage != null &&
          newMessage.trim() != message.contents.trim() &&
          !message.isIncoming) controller.editMessage(message.id, newMessage);
    });
  }

  void _startReplying(Message message) {
    setState(() {
      _replying = true;
      _replyingMessage = message;
    });
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

  void _saveImage(Uint8List messageBytes) async {
    await ImageGallerySaver.saveImage(messageBytes);
    showSnackBar(context, "Image saved.");
  }
}

class ChatCard extends StatelessWidget {
  final Message _message;
  final void Function() onTap;
  final void Function() onDelete;
  final void Function() onDoubleTap;
  final void Function() onForwardPressed;
  final void Function() onEditPressed;
  final void Function() onReplyPressed;
  final void Function() onRepliedMessagePressed;
  final void Function() onMediaDownload;
  final bool blurImages;
  final bool profanityFilter;
  final bool blockEditingMessages;
  final bool blockDeletingMessages;
  final bool blockSaveMedia;
  final ChatType chatType;
  final Message? repliedMessage;
  final String contactTitle;
  final List<ProfanityWord> words;

  ChatCard(
    this._message, {
    required this.onTap,
    required this.onDelete,
    required this.onDoubleTap,
    required this.onForwardPressed,
    required this.onEditPressed,
    required this.onReplyPressed,
    required this.onRepliedMessagePressed,
    required this.onMediaDownload,
    this.blurImages = false,
    this.profanityFilter = false,
    this.chatType = ChatType.general,
    this.repliedMessage,
    this.blockDeletingMessages = false,
    this.blockEditingMessages = false,
    this.blockSaveMedia = false,
    required this.contactTitle,
    required this.words,
  });

  final dateFormatter = intl.DateFormat("Hm");

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final repliedMessage = this.repliedMessage;

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
                  //TODO swipe right to reply
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
                        if (!_message.deleted && !_message.isMedia)
                          FocusedMenuItem(
                            title: Text("Reply"),
                            onPressed: onReplyPressed,
                            trailingIcon: Icon(Icons.reply),
                          ),
                        if (!_message.deleted &&
                            _message.isMedia &&
                            !blockSaveMedia)
                          FocusedMenuItem(
                            title: Text("Download"),
                            onPressed: onMediaDownload,
                            trailingIcon: Icon(Icons.save_alt),
                          ),
                        // if (!_message.deleted && chatType == ChatType.general)
                        //   FocusedMenuItem(
                        //       title: Text("Tag"),
                        //       onPressed: () {},
                        //       trailingIcon: Icon(Icons.tag)),
                        if (!_message.deleted &&
                            !_message.isMedia &&
                            !_message.isIncoming &&
                            !blockEditingMessages)
                          FocusedMenuItem(
                              title: Text("Edit"),
                              onPressed: onEditPressed,
                              trailingIcon: Icon(Icons.edit)),
                        if (!_message.deleted && chatType == ChatType.general)
                          FocusedMenuItem(
                              title: Text("Forward"),
                              onPressed: () {
                                onForwardPressed();
                              },
                              trailingIcon: Icon(Icons.forward)),
                        if (!_message.deleted && !_message.isMedia)
                          FocusedMenuItem(
                              title: Text("Copy"),
                              onPressed: () => Clipboard.setData(
                                  ClipboardData(text: _message.contents)),
                              trailingIcon: Icon(Icons.copy)),
                        if (chatType == ChatType.general &&
                            !blockDeletingMessages)
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
                          if (_message.forwarded && _message.isIncoming)
                            Container(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.reply,
                                    textDirection: TextDirection.rtl,
                                    size: 16,
                                    color: Colors.white.withOpacity(0.69),
                                  ),
                                  Text(
                                    "Forwarded",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.69)),
                                  ),
                                ],
                              ),
                            ),
                          if (repliedMessage != null &&
                              repliedMessage.contents != "")
                            InkWell(
                              onTap: onRepliedMessagePressed,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: _message.isIncoming
                                      ? Constants.orange
                                      : Constants.darkGrey,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Text(
                                  "${repliedMessage.isIncoming ? contactTitle : "You"}\n${repliedMessage.contents}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          SizedBox(
                            height: 4,
                          ),
                          Container(
                            child: _renderMessageContents(words),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (_message.edited)
                                  Text(
                                    "Edited",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  ),
                                if (_message.edited)
                                  Expanded(child: Container()),
                                if (_message.edited)
                                  SizedBox(
                                    width: 10,
                                  ),
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

  Widget _renderMessageContents(List<ProfanityWord> words) {
    if (_message.isMedia) {
      if (blurImages) {
        return Row(
          children: [
            Text(
              "View image",
              style: TextStyle(
                color: Colors.white,
                fontStyle: _message.deleted ? FontStyle.italic : null,
              ),
            ),
            SizedBox(
              width: 2,
            ),
            Icon(
              Icons.remove_red_eye,
              size: 14,
              color: Colors.white,
            ),
          ],
        );
      }
      return Image.memory(
        base64Decode(_message.contents),
        height: 200,
      );
    } else {
      return Text(
        _message.deleted
            ? "This message was deleted"
            : profanityFilter
                ? _filterContents(_message.contents, words)
                : _message.contents,
        style: TextStyle(
          color: Colors.white,
          fontStyle: _message.deleted ? FontStyle.italic : null,
        ),
      );
    }
  }

  String _filterContents(String unfilteredContents, List<ProfanityWord> words) {
    // Constants.profanityRegex.forEach((regex) {
    //   unfilteredContents = unfilteredContents.replaceAllMapped(
    //       RegExp(regex, caseSensitive: false),
    //       (match) => List.filled(match.end - match.start, "*").join());
    // });
    // return unfilteredContents;
    words.forEach((profanityWord) {
      unfilteredContents = unfilteredContents.replaceAllMapped(
          RegExp(profanityWord.profanityWordRegex, caseSensitive: false),
          (match) => List.filled(match.end - match.start, "*").join());
    });
    return unfilteredContents;
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
