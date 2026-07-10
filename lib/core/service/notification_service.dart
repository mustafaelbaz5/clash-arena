import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../config/app_config.dart';
import '../networking/notification_remote_ds.dart';

class NotificationService {
  NotificationService({required this.notificationRemoteDs});

  final NotificationRemoteDs notificationRemoteDs;

  final _fcm = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _requestPermission();
    await _setupLocalNotifications();
    _setupForegroundHandler();
  }

  Future<void> _requestPermission() async {
    await _fcm.requestPermission(alert: true, badge: true, sound: true);
  }

  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();

    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
  }

  // ── 2. Token Management ───────────────────────────────────────────────────

  Future<void> saveToken({required final String userId}) async {
    try {
      final token = await _fcm.getToken();
      if (token == null) return;

      final platform = Platform.isAndroid ? 'android' : 'ios';

      await notificationRemoteDs.saveToken(
        userId: userId,
        token: token,
        deviceType: platform,
      );

      // Listen for token refresh
      _fcm.onTokenRefresh.listen((final newToken) async {
        await notificationRemoteDs.saveToken(
          userId: userId,
          token: newToken,
          deviceType: platform,
        );
      });

      if (AppConfig.enableLogging) {
        // ignore: avoid_print
        print('FCM Token saved: $token');
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        // ignore: avoid_print
        print('Failed to save FCM token: $e');
      }
    }
  }

  Future<void> deleteToken({required final String userId}) async {
    try {
      final token = await _fcm.getToken();
      if (token == null) return;

      await notificationRemoteDs.deleteToken(userId: userId, token: token);

      await _fcm.deleteToken();
    } catch (e) {
      if (AppConfig.enableLogging) {
        // ignore: avoid_print
        print('Failed to delete FCM token: $e');
      }
    }
  }

  // ── 3. Message Handling ───────────────────────────────────────────────────

  void _setupForegroundHandler() {
    FirebaseMessaging.onMessage.listen((final message) {
      final notification = message.notification;
      if (notification == null) return;
      _showLocalNotification(notification);
    });
  }

  Future<void> _showLocalNotification(
    final RemoteNotification notification,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'match_channel',
      'Match Notifications',
      channelDescription: 'Notifications for match results',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: const NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
