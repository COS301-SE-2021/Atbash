import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Contact.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mobile/services/UserService.dart';
import 'package:mobile/widgets/ProfileIcon.dart';

class ChatPage extends StatefulWidget {
  final Contact contact;

  ChatPage(this.contact);

  @override
  _ChatPageState createState() => _ChatPageState(this.contact);
}

class _ChatPageState extends State<ChatPage> {
  bool loading = true;
  late final MessageService _messageService;

  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  List<Message> _messages = [];

  _ChatPageState(Contact contact) {
    _messageService = MessageService(contact);

    _messageService.listenForNewMessages((newMessage) {
      setState(() {
        _messages.addAll(newMessage);
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          EmptyProfileIcon(Colors.black),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.contact.displayName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }

  SafeArea _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          Flexible(
            child: ListView(
              children: _buildMessages(),
              controller: _scrollController,
              reverse: true,
            ),
          ),
          _buildInput()
        ],
      ),
    );
  }

  List<Align> _buildMessages() {
    return _messages.reversed.map((m) => _buildMessage(m)).toList();
  }

  Align _buildMessage(Message message) {
    Alignment alignment = Alignment.centerLeft;
    EdgeInsets padding = EdgeInsets.only(left: 16.0, right: 32.0);

    if (message.numberTo == widget.contact.phoneNumber) {
      alignment = Alignment.centerRight;
      padding = EdgeInsets.only(left: 32.0, right: 16.0);
    }

    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Wrap(
          children: [
            Card(
              color: Colors.orange,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  message.contents,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
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
    final from = GetIt.I.get<UserService>().getUser()?.phoneNumber;
    final to = widget.contact.phoneNumber;
    final contents = _inputController.text;
    if (from != null) {
      _messageService.sendMessage(from, to, contents);
    }
    _inputController.text = "";
  }
}
