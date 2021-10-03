import 'package:get_it/get_it.dart';
import 'package:mobile/domain/Chat.dart';
import 'package:mobile/domain/Message.dart';
import 'package:mobile/main.dart';
import 'package:mobile/models/HomePageModel.dart';
import 'package:mobile/services/ChatService.dart';
import 'package:mobile/services/CommunicationService.dart';
import 'package:mobile/services/ContactService.dart';
import 'package:mobile/services/MessageService.dart';
import 'package:mobile/services/ParentService.dart';
import 'package:mobile/services/ProfanityWordService.dart';
import 'package:mobile/services/SettingsService.dart';
import 'package:mobile/services/UserService.dart';

class HomePageController {
  final NavigationObserver navigationObserver = GetIt.I.get();

  final UserService userService = GetIt.I.get();
  final ChatService chatService = GetIt.I.get();
  final ContactService contactService = GetIt.I.get();
  final MessageService messageService = GetIt.I.get();
  final CommunicationService communicationService = GetIt.I.get();
  final SettingsService settingsService = GetIt.I.get();
  final ProfanityWordService profanityWordService = GetIt.I.get();
  final ParentService parentService = GetIt.I.get();

  final HomePageModel model = HomePageModel();

  HomePageController() {
    final CommunicationService communicationService = GetIt.I.get();

    communicationService.goOnline();

    contactService.onChanged(reload);
    chatService.onChanged(reload);
    communicationService.onMessage(_onMessage);
    communicationService.onAck(_onAck);
    communicationService.onAckSeen(_onAckSeen);
    communicationService.onMessageEdited(_onMessageEdited);
    navigationObserver.onRoutePop(reload);

    communicationService.onAllSettingsToChild(_onAllSettingsToChild);

    communicationService.onNewProfanityWordToChild(_onNewProfanityWordToChild);

    reload();
  }

  void _onNewProfanityWordToChild() {
    profanityWordService.fetchAll().then((words) {
      model.profanityWords.clear();
      model.profanityWords.addAll(words);
    });
  }

  void _onAllSettingsToChild(
    editableSettings,
    blurImages,
    safeMode,
    shareProfilePicture,
    shareStatus,
    shareReadReceipts,
    shareBirthday,
    lockedAccount,
    privateChatAccess,
    blockSaveMedia,
    blockEditingMessages,
    blockDeletingMessages,
  ) {
    model.profanityFilter = safeMode;
    model.blockSaveMedia = blockSaveMedia;
  }

  void dispose() {
    navigationObserver.disposeOnRoutePop(reload);
    chatService.disposeOnChanged(reload);
    contactService.disposeOnChanged(reload);
    communicationService.disposeOnMessage(_onMessage);
    communicationService
        .disposeOnNewProfanityWordToChild(_onNewProfanityWordToChild);
    communicationService.disposeOnAllSettingsToChild(_onAllSettingsToChild);
    communicationService.disposeOnAck(_onAck);
    communicationService.disposeOnAckSeen(_onAckSeen);
    communicationService.disposeOnMessageEdited(_onMessageEdited);
  }

  void sendOnline() {
    contactService.fetchAll().then((contacts) {
      contacts.forEach((contact) {
        communicationService.sendOnlineStatus(true, contact.phoneNumber);
      });
    });
  }

  void sendOffline() {
    contactService.fetchAll().then((contacts) {
      contacts.forEach((contact) {
        communicationService.sendOnlineStatus(false, contact.phoneNumber);
      });
    });
  }

  void _onMessage(Message m) {
    reload();
  }

  void _onAck(String messageId) {
    reload();
  }

  void _onAckSeen(List<String> messageIds) {
    reload();
  }

  void _onMessageEdited(String id, String contents) {
    reload();
  }

  void reload() {
    userService
        .getDisplayName()
        .then((displayName) => model.userDisplayName = displayName);

    userService.getStatus().then((status) => model.userStatus = status);

    userService
        .getProfileImage()
        .then((profileImage) => model.userProfileImage = profileImage);

    chatService
        .fetchByChatType(ChatType.general)
        .then((chats) => model.replaceChats(chats));

    settingsService
        .getSafeMode()
        .then((value) => model.profanityFilter = value);

    settingsService
        .getBlockSaveMedia()
        .then((value) => model.blockSaveMedia = value);

    profanityWordService.fetchAll().then((words) {
      model.profanityWords.clear();
      model.profanityWords.addAll(words);
    });
  }

  void deleteChat(String chatId) {
    parentService.fetchByEnabled().then((parent) {
      chatService.fetchById(chatId).then((chat) => communicationService
          .sendChatToParent(parent.phoneNumber, chat, "delete"));
    }).catchError((_) {});
    chatService.deleteById(chatId);
    messageService.deleteAllByChatId(chatId);
    model.removeChat(chatId);
  }
}
