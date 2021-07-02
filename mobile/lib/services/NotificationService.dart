import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<bool> init() async {
    final androidInitSettings = AndroidInitializationSettings("atbash_64");

    final iosInitSettings = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: null,
    );

    final initializationSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    final permissionGranted =
        await _localNotificationsPlugin.initialize(initializationSettings);
    // TODO should handle onSelectNotification

    if (permissionGranted == null) {
      return false;
    } else {
      return permissionGranted;
    }
  }

  void showNotification(
    int id,
    String title,
    String body,
    String payload,
    bool withSound,
  ) {
    final androidNotificationDetails = AndroidNotificationDetails(
      "message",
      "Messages",
      "Triggered when receiving a message",
      importance: Importance.high,
      priority: Priority.high,
      playSound: withSound,
    );

    final iosNotificationDetails = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: withSound,
    );

    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    _localNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
