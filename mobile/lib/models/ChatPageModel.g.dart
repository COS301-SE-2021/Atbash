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

  final _$profanityWordsAtom = Atom(name: '_ChatPageModel.profanityWords');

  @override
  List<ProfanityWord> get profanityWords {
    _$profanityWordsAtom.reportRead();
    return super.profanityWords;
  }

  @override
  set profanityWords(List<ProfanityWord> value) {
    _$profanityWordsAtom.reportWrite(value, super.profanityWords, () {
      super.profanityWords = value;
    });
  }

  final _$onlineAtom = Atom(name: '_ChatPageModel.online');

  @override
  bool get online {
    _$onlineAtom.reportRead();
    return super.online;
  }

  @override
  set online(bool value) {
    _$onlineAtom.reportWrite(value, super.online, () {
      super.online = value;
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

  final _$wallpaperImageAtom = Atom(name: '_ChatPageModel.wallpaperImage');

  @override
  String? get wallpaperImage {
    _$wallpaperImageAtom.reportRead();
    return super.wallpaperImage;
  }

  @override
  set wallpaperImage(String? value) {
    _$wallpaperImageAtom.reportWrite(value, super.wallpaperImage, () {
      super.wallpaperImage = value;
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

  final _$contactSavedAtom = Atom(name: '_ChatPageModel.contactSaved');

  @override
  bool get contactSaved {
    _$contactSavedAtom.reportRead();
    return super.contactSaved;
  }

  @override
  set contactSaved(bool value) {
    _$contactSavedAtom.reportWrite(value, super.contactSaved, () {
      super.contactSaved = value;
    });
  }

  final _$chatTypeAtom = Atom(name: '_ChatPageModel.chatType');

  @override
  ChatType get chatType {
    _$chatTypeAtom.reportRead();
    return super.chatType;
  }

  @override
  set chatType(ChatType value) {
    _$chatTypeAtom.reportWrite(value, super.chatType, () {
      super.chatType = value;
    });
  }

  final _$blurImagesAtom = Atom(name: '_ChatPageModel.blurImages');

  @override
  bool get blurImages {
    _$blurImagesAtom.reportRead();
    return super.blurImages;
  }

  @override
  set blurImages(bool value) {
    _$blurImagesAtom.reportWrite(value, super.blurImages, () {
      super.blurImages = value;
    });
  }

  final _$profanityFilterAtom = Atom(name: '_ChatPageModel.profanityFilter');

  @override
  bool get profanityFilter {
    _$profanityFilterAtom.reportRead();
    return super.profanityFilter;
  }

  @override
  set profanityFilter(bool value) {
    _$profanityFilterAtom.reportWrite(value, super.profanityFilter, () {
      super.profanityFilter = value;
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
  void replaceMessages(Iterable<Message> messages) {
    final _$actionInfo = _$_ChatPageModelActionController.startAction(
        name: '_ChatPageModel.replaceMessages');
    try {
      return super.replaceMessages(messages);
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
  void setLikedById(String messageID, bool liked) {
    final _$actionInfo = _$_ChatPageModelActionController.startAction(
        name: '_ChatPageModel.setLikedById');
    try {
      return super.setLikedById(messageID, liked);
    } finally {
      _$_ChatPageModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEditedById(String messageID, String newMessage) {
    final _$actionInfo = _$_ChatPageModelActionController.startAction(
        name: '_ChatPageModel.setEditedById');
    try {
      return super.setEditedById(messageID, newMessage);
    } finally {
      _$_ChatPageModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
contactTitle: ${contactTitle},
profanityWords: ${profanityWords},
online: ${online},
contactStatus: ${contactStatus},
wallpaperImage: ${wallpaperImage},
contactProfileImage: ${contactProfileImage},
contactSaved: ${contactSaved},
chatType: ${chatType},
blurImages: ${blurImages},
profanityFilter: ${profanityFilter},
messages: ${messages}
    ''';
  }
}
