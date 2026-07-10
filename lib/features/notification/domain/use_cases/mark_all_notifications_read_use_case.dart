import '../repo/notification_repo.dart';

class MarkAllNotificationsReadUseCase {
  final NotificationRepo repo;

  MarkAllNotificationsReadUseCase(this.repo);

  Future<void> call() => repo.markAllAsRead();
}
