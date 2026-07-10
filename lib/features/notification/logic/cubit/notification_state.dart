part of 'notification_cubit.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationLoading extends NotificationState {}

final class NotificationLoaded extends NotificationState {
  final List<AppNotificationEntity> notifications;

  NotificationLoaded(this.notifications);

  int get unreadCount => notifications.where((final n) => !n.isRead).length;
}

final class NotificationFailure extends NotificationState {
  final Failure error;

  NotificationFailure({required this.error});
}
