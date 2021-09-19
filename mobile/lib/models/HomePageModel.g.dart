// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HomePageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomePageModel on _HomePageModel, Store {
  Computed<List<Chat>>? _$orderedChatsComputed;

  @override
  List<Chat> get orderedChats =>
      (_$orderedChatsComputed ??= Computed<List<Chat>>(() => super.orderedChats,
              name: '_HomePageModel.orderedChats'))
          .value;

  final _$userDisplayNameAtom = Atom(name: '_HomePageModel.userDisplayName');

  @override
  String get userDisplayName {
    _$userDisplayNameAtom.reportRead();
    return super.userDisplayName;
  }

  @override
  set userDisplayName(String value) {
    _$userDisplayNameAtom.reportWrite(value, super.userDisplayName, () {
      super.userDisplayName = value;
    });
  }

  final _$userStatusAtom = Atom(name: '_HomePageModel.userStatus');

  @override
  String get userStatus {
    _$userStatusAtom.reportRead();
    return super.userStatus;
  }

  @override
  set userStatus(String value) {
    _$userStatusAtom.reportWrite(value, super.userStatus, () {
      super.userStatus = value;
    });
  }

  final _$userProfileImageAtom = Atom(name: '_HomePageModel.userProfileImage');

  @override
  Uint8List? get userProfileImage {
    _$userProfileImageAtom.reportRead();
    return super.userProfileImage;
  }

  @override
  set userProfileImage(Uint8List? value) {
    _$userProfileImageAtom.reportWrite(value, super.userProfileImage, () {
      super.userProfileImage = value;
    });
  }

  final _$profanityFilterAtom = Atom(name: '_HomePageModel.profanityFilter');

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

  final _$chatsAtom = Atom(name: '_HomePageModel.chats');

  @override
  ObservableList<Chat> get chats {
    _$chatsAtom.reportRead();
    return super.chats;
  }

  @override
  set chats(ObservableList<Chat> value) {
    _$chatsAtom.reportWrite(value, super.chats, () {
      super.chats = value;
    });
  }

  final _$_HomePageModelActionController =
      ActionController(name: '_HomePageModel');

  @override
  void addChat(Chat chat) {
    final _$actionInfo = _$_HomePageModelActionController.startAction(
        name: '_HomePageModel.addChat');
    try {
      return super.addChat(chat);
    } finally {
      _$_HomePageModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void replaceChats(Iterable<Chat> chats) {
    final _$actionInfo = _$_HomePageModelActionController.startAction(
        name: '_HomePageModel.replaceChats');
    try {
      return super.replaceChats(chats);
    } finally {
      _$_HomePageModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeChat(String chatId) {
    final _$actionInfo = _$_HomePageModelActionController.startAction(
        name: '_HomePageModel.removeChat');
    try {
      return super.removeChat(chatId);
    } finally {
      _$_HomePageModelActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
userDisplayName: ${userDisplayName},
userStatus: ${userStatus},
userProfileImage: ${userProfileImage},
profanityFilter: ${profanityFilter},
chats: ${chats},
orderedChats: ${orderedChats}
    ''';
  }
}
