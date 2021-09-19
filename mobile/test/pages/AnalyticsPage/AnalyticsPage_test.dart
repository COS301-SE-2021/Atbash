import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([ContactService, MessageService, ChatService])
void main() {}
