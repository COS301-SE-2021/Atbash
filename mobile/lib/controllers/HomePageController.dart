import 'package:get_it/get_it.dart';
import 'package:mobile/main.dart';
import 'package:mobile/models/HomePageModel.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mobile/services/UserService.dart';

class HomePageController {
  final NavigationObserver navigationObserver = GetIt.I.get();

  final UserService userService = GetIt.I.get();
  final ChatService chatService = GetIt.I.get();
  final MessageService messageService = GetIt.I.get();

  final HomePageModel model = HomePageModel();

  HomePageController() {
    chatService.onChanged(reload);
    navigationObserver.onRoutePop(reload);
    reload();
  }

  void dispose() {
    navigationObserver.disposeOnRoutePop(reload);
    chatService.disposeOnChanged(reload);
  }

  void reload() {
    userService
        .getDisplayName()
        .then((displayName) => model.userDisplayName = displayName);

    userService.getStatus().then((status) => model.userStatus = status);

    userService
        .getProfileImage()
        .then((profileImage) => model.userProfileImage = profileImage);

    chatService.fetchAll().then((chats) => model.replaceChats(chats));
  }

  void deleteChat(String chatId) {
    chatService.deleteById(chatId);
    messageService.deleteAllByChatId(chatId);
    model.removeChat(chatId);
  }
}
