import 'package:mobile/domain/Message.dart';

//Use "encryptMessageContent" and "decryptMessageContents"
//for encrypting and decrypting messsages

class CommunicationService {
  Stream<Message> listenForMessages() async* {
    throw UnimplementedError();
  }

  void sendMessage() {
    throw UnimplementedError();
  }
}
