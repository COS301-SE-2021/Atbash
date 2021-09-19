import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/models/AnalyticsPageModel.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mobile/util/Tuple.dart';

class AnalyticsPageController {
  final ChatService chatService = GetIt.I.get();
  final MessageService messageService = GetIt.I.get();
  final ContactService contactService = GetIt.I.get();

  final AnalyticsPageModel model = AnalyticsPageModel();

  AnalyticsPageController() {
    chatService.fetchByChatType(ChatType.general).then((chats) async {
      int totalTextMessagesSent = 0;
      int totalTextMessagesReceived = 0;
      int totalPhotosSent = 0;
      int totalPhotosReceived = 0;
      int totalMessagesLiked = 0;
      int totalMessagesTagged = 0;
      int totalMessagesDeleted = 0;
      final futures = chats.map((chat) async {
        final messages = await messageService.fetchAllByChatId(chat.id);
        model.chatMessageCount.add(Tuple(chat, messages.length));
        totalTextMessagesSent += messages
            .where((message) => !message.isIncoming && !message.isMedia)
            .length;
        totalTextMessagesReceived += messages
            .where((message) => message.isIncoming && !message.isMedia)
            .length;
        totalPhotosSent += messages
            .where((message) => !message.isIncoming && message.isMedia)
            .length;
        totalPhotosReceived += messages
            .where((message) => message.isIncoming && message.isMedia)
            .length;
        totalMessagesLiked += messages.where((message) => message.liked).length;
        totalMessagesTagged +=
            messages.where((message) => message.tags.isNotEmpty).length;
        totalMessagesDeleted +=
            messages.where((message) => message.deleted).length;
      });
      await Future.wait(futures);
      model.totalTextMessagesSent = totalTextMessagesSent;
      model.totalTextMessagesReceived = totalTextMessagesReceived;
      model.totalPhotosSent = totalPhotosSent;
      model.totalPhotosReceived = totalPhotosReceived;
      model.totalMessagesLiked = totalMessagesLiked;
      model.totalMessagesTagged = totalMessagesTagged;
      model.totalMessagesDeleted = totalMessagesDeleted;
      model.chatMessageCount.sort((a, b) => b.second.compareTo(a.second));
    });
  }
}
