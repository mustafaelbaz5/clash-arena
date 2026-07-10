import 'package:bloc/bloc.dart';
import 'package:clash_arena/core/errors/failure.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/app_notification_entity.dart';
import '../../domain/use_cases/get_my_notifications_use_case.dart';
import '../../domain/use_cases/mark_all_notifications_read_use_case.dart';
import '../../domain/use_cases/mark_notification_read_use_case.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetMyNotificationsUseCase getMyNotifications;
  final MarkNotificationReadUseCase markNotificationRead;
  final MarkAllNotificationsReadUseCase markAllNotificationsRead;

  NotificationCubit({
    required this.getMyNotifications,
    required this.markNotificationRead,
    required this.markAllNotificationsRead,
  }) : super(NotificationInitial());

  Future<void> loadNotifications() async {
    emit(NotificationLoading());
    try {
      final notifications = await getMyNotifications();
      emit(NotificationLoaded(notifications));
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(NotificationFailure(error: failure));
    }
  }

  Future<void> markAsRead(final AppNotificationEntity notification) async {
    if (notification.isRead) return;
    final current = state;
    if (current is! NotificationLoaded) return;

    // Optimistic update: no need to round-trip a full refetch for a read flag.
    emit(
      NotificationLoaded([
        for (final n in current.notifications)
          if (n.id == notification.id) n.copyWith(isRead: true) else n,
      ]),
    );

    try {
      await markNotificationRead(notification.id);
    } catch (_) {
      // Best-effort: leave the optimistic state as-is rather than flashing
      // the unread badge back on for a transient network hiccup.
    }
  }

  Future<void> markAllAsRead() async {
    final current = state;
    if (current is! NotificationLoaded) return;

    emit(
      NotificationLoaded([
        for (final n in current.notifications) n.copyWith(isRead: true),
      ]),
    );

    try {
      await markAllNotificationsRead();
    } catch (_) {
      // Best-effort, same rationale as markAsRead.
    }
  }
}
