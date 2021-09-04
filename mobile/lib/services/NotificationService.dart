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
}
