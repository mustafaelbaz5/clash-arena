import '../entities/app_notification_entity.dart';
import '../repo/notification_repo.dart';

class GetMyNotificationsUseCase {
  final NotificationRepo repo;

  GetMyNotificationsUseCase(this.repo);

  Future<List<AppNotificationEntity>> call() => repo.getMyNotifications();
}
