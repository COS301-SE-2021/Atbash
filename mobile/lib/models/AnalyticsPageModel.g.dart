// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AnalyticsPageModel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AnalyticsPageModel on _AnalyticsPageModel, Store {
  final _$chatMessageCountAtom =
      Atom(name: '_AnalyticsPageModel.chatMessageCount');

  @override
  ObservableList<Tuple<Chat, int>> get chatMessageCount {
    _$chatMessageCountAtom.reportRead();
    return super.chatMessageCount;
  }

  @override
  set chatMessageCount(ObservableList<Tuple<Chat, int>> value) {
    _$chatMessageCountAtom.reportWrite(value, super.chatMessageCount, () {
      super.chatMessageCount = value;
    });
  }

  final _$totalTextMessagesSentAtom =
      Atom(name: '_AnalyticsPageModel.totalTextMessagesSent');

  @override
  int get totalTextMessagesSent {
    _$totalTextMessagesSentAtom.reportRead();
    return super.totalTextMessagesSent;
  }

  @override
  set totalTextMessagesSent(int value) {
    _$totalTextMessagesSentAtom.reportWrite(value, super.totalTextMessagesSent,
        () {
      super.totalTextMessagesSent = value;
    });
  }

  final _$totalTextMessagesReceivedAtom =
      Atom(name: '_AnalyticsPageModel.totalTextMessagesReceived');

  @override
  int get totalTextMessagesReceived {
    _$totalTextMessagesReceivedAtom.reportRead();
    return super.totalTextMessagesReceived;
  }

  @override
  set totalTextMessagesReceived(int value) {
    _$totalTextMessagesReceivedAtom
        .reportWrite(value, super.totalTextMessagesReceived, () {
      super.totalTextMessagesReceived = value;
    });
  }

  final _$totalPhotosSentAtom =
      Atom(name: '_AnalyticsPageModel.totalPhotosSent');

  @override
  int get totalPhotosSent {
    _$totalPhotosSentAtom.reportRead();
    return super.totalPhotosSent;
  }

  @override
  set totalPhotosSent(int value) {
    _$totalPhotosSentAtom.reportWrite(value, super.totalPhotosSent, () {
      super.totalPhotosSent = value;
    });
  }

  final _$totalPhotosReceivedAtom =
      Atom(name: '_AnalyticsPageModel.totalPhotosReceived');

  @override
  int get totalPhotosReceived {
    _$totalPhotosReceivedAtom.reportRead();
    return super.totalPhotosReceived;
  }

  @override
  set totalPhotosReceived(int value) {
    _$totalPhotosReceivedAtom.reportWrite(value, super.totalPhotosReceived, () {
      super.totalPhotosReceived = value;
    });
  }

  final _$totalMessagesLikedAtom =
      Atom(name: '_AnalyticsPageModel.totalMessagesLiked');

  @override
  int get totalMessagesLiked {
    _$totalMessagesLikedAtom.reportRead();
    return super.totalMessagesLiked;
  }

  @override
  set totalMessagesLiked(int value) {
    _$totalMessagesLikedAtom.reportWrite(value, super.totalMessagesLiked, () {
      super.totalMessagesLiked = value;
    });
  }

  final _$totalMessagesTaggedAtom =
      Atom(name: '_AnalyticsPageModel.totalMessagesTagged');

  @override
  int get totalMessagesTagged {
    _$totalMessagesTaggedAtom.reportRead();
    return super.totalMessagesTagged;
  }

  @override
  set totalMessagesTagged(int value) {
    _$totalMessagesTaggedAtom.reportWrite(value, super.totalMessagesTagged, () {
      super.totalMessagesTagged = value;
    });
  }

  final _$totalMessagesDeletedAtom =
      Atom(name: '_AnalyticsPageModel.totalMessagesDeleted');

  @override
  int get totalMessagesDeleted {
    _$totalMessagesDeletedAtom.reportRead();
    return super.totalMessagesDeleted;
  }

  @override
  set totalMessagesDeleted(int value) {
    _$totalMessagesDeletedAtom.reportWrite(value, super.totalMessagesDeleted,
        () {
      super.totalMessagesDeleted = value;
    });
  }

  @override
  String toString() {
    return '''
chatMessageCount: ${chatMessageCount},
totalTextMessagesSent: ${totalTextMessagesSent},
totalTextMessagesReceived: ${totalTextMessagesReceived},
totalPhotosSent: ${totalPhotosSent},
totalPhotosReceived: ${totalPhotosReceived},
totalMessagesLiked: ${totalMessagesLiked},
totalMessagesTagged: ${totalMessagesTagged},
totalMessagesDeleted: ${totalMessagesDeleted}
    ''';
  }
}
