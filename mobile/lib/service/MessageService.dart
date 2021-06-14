import 'package:http/http.dart' as http;
import 'package:mobile/domain/Message.dart';

class MessageService {
  Message sendMessage(String from, String to, String contents) {
    final message = Message(from, to, contents);

    final url = Uri.parse("http://localhost/rs/v1/messages");
    http.post(url, body: {"to": to, "contents": message.encodeBody()}).then(
            (value) {
          // TODO handle response
        });

    // TODO save to db

    return message;
  }
}
