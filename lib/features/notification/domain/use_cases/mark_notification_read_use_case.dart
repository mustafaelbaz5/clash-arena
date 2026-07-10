import '../repo/notification_repo.dart';

class MarkNotificationReadUseCase {
  final NotificationRepo repo;

  MarkNotificationReadUseCase(this.repo);

  Future<void> call(final int notificationId) => repo.markAsRead(notificationId);
}
