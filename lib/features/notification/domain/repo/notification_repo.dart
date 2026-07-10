import '../entities/app_notification_entity.dart';

abstract class NotificationRepo {
  Future<List<AppNotificationEntity>> getMyNotifications();

  Future<void> markAsRead(final int notificationId);

  Future<void> markAllAsRead();
}
