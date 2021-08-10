import 'package:mobile/domain/Message.dart';

String cullToE164(String phoneNumber) {
  return phoneNumber.replaceAll(RegExp("(\s|[^0-9]|^0*)"), "");
}

ReadReceipt? parseReadReceipt(Object? value) {
  if (!(value is String)) {
    return null;
  }
  switch (value) {
    case "ReadReceipt.delivered":
      return ReadReceipt.delivered;
    case "ReadReceipt.undelivered":
      return ReadReceipt.undelivered;
    case "ReadReceipt.seen":
      return ReadReceipt.seen;
    default:
      return null;
  }
}
