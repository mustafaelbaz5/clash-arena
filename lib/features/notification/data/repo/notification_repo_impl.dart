import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/networking/network_info.dart';
import '../../domain/entities/app_notification_entity.dart';
import '../../domain/repo/notification_repo.dart';
import '../remote/app_notification_remote_ds.dart';

class NotificationRepoImpl implements NotificationRepo {
  final AppNotificationRemoteDs remoteDs;
  final NetworkInfo networkInfo;

  NotificationRepoImpl({required this.remoteDs, required this.networkInfo});

  @override
  Future<List<AppNotificationEntity>> getMyNotifications() async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      return await remoteDs.fetchMyNotifications();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<void> markAsRead(final int notificationId) async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      await remoteDs.markAsRead(notificationId);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      await remoteDs.markAllAsRead();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
