import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _lnp = FlutterLocalNotificationsPlugin();

  Future<bool> init() async {
    final androidInitSettings = AndroidInitializationSettings("atbash_64");

    final iosInitSettings = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: null,
    );

    final initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    final permissionGranted = await _lnp.initialize(initSettings);

    if (permissionGranted == null) {
      return false;
    } else {
      return permissionGranted;
    }
  }

  void showNotification({
    required String title,
    required String body,
    bool withSound = false,
  }) {
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

    _lnp.show(
      Random().nextInt(25000),
      title,
      body,
      notificationDetails,
    );
  }
}
