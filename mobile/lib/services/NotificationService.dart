import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _lnp = FlutterLocalNotificationsPlugin();
  void Function(String? payload)? onNotificationPressed;

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

    final permissionGranted = await _lnp.initialize(
      initSettings,
      onSelectNotification: (payload) async {
        onNotificationPressed?.call(payload);
      },
    );

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
    Map<String, Object>? payload,
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
      payload: jsonEncode(payload),
    );
  }
}
