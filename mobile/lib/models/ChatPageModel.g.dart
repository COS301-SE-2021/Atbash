// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatPageModel on _ChatPageModel, Store {
  final _$contactTitleAtom = Atom(name: '_ChatPageModel.contactTitle');

  @override
  String get contactTitle {
    _$contactTitleAtom.reportRead();
    return super.contactTitle;
  }

  @override
  set contactTitle(String value) {
    _$contactTitleAtom.reportWrite(value, super.contactTitle, () {
      super.contactTitle = value;
    });
  }

  final _$contactStatusAtom = Atom(name: '_ChatPageModel.contactStatus');

  @override
  String get contactStatus {
    _$contactStatusAtom.reportRead();
    return super.contactStatus;
  }

  @override
  set contactStatus(String value) {
    _$contactStatusAtom.reportWrite(value, super.contactStatus, () {
      super.contactStatus = value;
    });
  }

  final _$contactProfileImageAtom =
      Atom(name: '_ChatPageModel.contactProfileImage');

  @override
  String get contactProfileImage {
    _$contactProfileImageAtom.reportRead();
    return super.contactProfileImage;
  }

  @override
  set contactProfileImage(String value) {
    _$contactProfileImageAtom.reportWrite(value, super.contactProfileImage, () {
      super.contactProfileImage = value;
    });
  }

  final _$messagesAtom = Atom(name: '_ChatPageModel.messages');

  @override
  ObservableList<Message> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(ObservableList<Message> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  final _$_ChatPageModelActionController =
      ActionController(name: '_ChatPageModel');

  @override
  void addMessage(Message message) {
    final _$actionInfo = _$_ChatPageModelActionController.startAction(
        name: '_ChatPageModel.addMessage');
    try {
      return super.addMessage(message);
    } finally {
      _$_ChatPageModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeMessageById(String messageId) {
    final _$actionInfo = _$_ChatPageModelActionController.startAction(
        name: '_ChatPageModel.removeMessageById');
    try {
      return super.removeMessageById(messageId);
    } finally {
      _$_ChatPageModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setReadReceiptById(String messageId, ReadReceipt readReceipt) {
    final _$actionInfo = _$_ChatPageModelActionController.startAction(
        name: '_ChatPageModel.setReadReceiptById');
    try {
      return super.setReadReceiptById(messageId, readReceipt);
    } finally {
      _$_ChatPageModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDeletedById(String messageId) {
    final _$actionInfo = _$_ChatPageModelActionController.startAction(
        name: '_ChatPageModel.setDeletedById');
    try {
      return super.setDeletedById(messageId);
    } finally {
      _$_ChatPageModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
contactTitle: ${contactTitle},
contactStatus: ${contactStatus},
contactProfileImage: ${contactProfileImage},
messages: ${messages}
    ''';
  }
}
