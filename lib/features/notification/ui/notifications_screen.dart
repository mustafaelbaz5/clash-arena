import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/extensions/context_ext.dart';
import '../../../core/utils/extensions/datetime_ext.dart';
import '../domain/entities/app_notification_entity.dart';
import '../logic/cubit/notification_cubit.dart';
import 'notification_details_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            tooltip: 'Mark all as read',
            icon: const Icon(Icons.done_all),
            onPressed: () => context.read<NotificationCubit>().markAllAsRead(),
          ),
        ],
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (final context, final state) {
          if (state is NotificationFailure) {
            context.showErrorSnackBar(state.error.message);
          }
        },
        builder: (final context, final state) {
          if (state is NotificationLoading || state is NotificationInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotificationFailure) {
            return Center(child: Text(state.error.message));
          }
          final loaded = state as NotificationLoaded;
          if (loaded.notifications.isEmpty) {
            return const Center(child: Text('No notifications yet.'));
          }
          return RefreshIndicator(
            onRefresh: () =>
                context.read<NotificationCubit>().loadNotifications(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: loaded.notifications.length,
              separatorBuilder: (final _, final _) => const SizedBox(height: 8),
              itemBuilder: (final context, final index) =>
                  _NotificationTile(notification: loaded.notifications[index]),
            ),
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification});

  final AppNotificationEntity notification;

  @override
  Widget build(final BuildContext context) {
    return Card(
      elevation: 0,
      color: notification.isRead
          ? context.customColors.divider.withValues(alpha: 0.2)
          : context.colorScheme.primaryContainer,
      child: ListTile(
        leading: Icon(_iconFor(notification.type)),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
        subtitle: Text(notification.message),
        trailing: Text(
          notification.createdAt.timeAgo,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: () {
          context.read<NotificationCubit>().markAsRead(notification);
          context.push(NotificationDetailsScreen(notification: notification));
        },
      ),
    );
  }

  IconData _iconFor(final AppNotificationType type) {
    switch (type) {
      case AppNotificationType.matchRequest:
        return Icons.sports_soccer;
      case AppNotificationType.matchApproved:
        return Icons.check_circle_outline;
      case AppNotificationType.matchRejected:
        return Icons.cancel_outlined;
      case AppNotificationType.groupInvite:
        return Icons.group_add_outlined;
      case AppNotificationType.leaderboardUpdate:
        return Icons.leaderboard_outlined;
      case AppNotificationType.welcome:
        return Icons.waving_hand_outlined;
      case AppNotificationType.security:
        return Icons.security_outlined;
      case AppNotificationType.update:
      case AppNotificationType.promotion:
      case AppNotificationType.system:
      case AppNotificationType.unknown:
        return Icons.notifications_outlined;
    }
  }
}
