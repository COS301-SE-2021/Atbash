import 'Tag.dart';

class Message {
  final String id;
  final String senderPhoneNumber;
  final String recipientPhoneNumber;
  final String contents;
  final DateTime timestamp;
  final ReadReceipt readReceipt;
  final bool deleted;
  final bool liked;
  final List<Tag> tags;

  Message(
      {required this.id,
      required this.senderPhoneNumber,
      required this.recipientPhoneNumber,
      required this.contents,
      required this.timestamp,
      required this.readReceipt,
      required this.deleted,
      required this.liked,
      required this.tags});
}

enum ReadReceipt { undelivered, delivered, seen }
