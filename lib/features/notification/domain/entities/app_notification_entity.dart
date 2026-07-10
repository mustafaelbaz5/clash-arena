import 'package:equatable/equatable.dart';

enum AppNotificationType {
  welcome,
  update,
  security,
  promotion,
  system,
  matchRequest,
  matchApproved,
  matchRejected,
  groupInvite,
  leaderboardUpdate,
  unknown,
}

AppNotificationType _typeFromString(final String value) {
  switch (value) {
    case 'welcome':
      return AppNotificationType.welcome;
    case 'update':
      return AppNotificationType.update;
    case 'security':
      return AppNotificationType.security;
    case 'promotion':
      return AppNotificationType.promotion;
    case 'system':
      return AppNotificationType.system;
    case 'match_request':
      return AppNotificationType.matchRequest;
    case 'match_approved':
      return AppNotificationType.matchApproved;
    case 'match_rejected':
      return AppNotificationType.matchRejected;
    case 'group_invite':
      return AppNotificationType.groupInvite;
    case 'leaderboard_update':
      return AppNotificationType.leaderboardUpdate;
    default:
      return AppNotificationType.unknown;
  }
}

class AppNotificationEntity extends Equatable {
  final int id;
  final String userId;
  final String title;
  final String message;
  final AppNotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic> data;
  final String? groupId;
  final String? matchRequestId;

  const AppNotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.data = const {},
    this.groupId,
    this.matchRequestId,
  });

  static AppNotificationType typeFromString(final String value) =>
      _typeFromString(value);

  AppNotificationEntity copyWith({final bool? isRead}) {
    return AppNotificationEntity(
      id: id,
      userId: userId,
      title: title,
      message: message,
      type: type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      data: data,
      groupId: groupId,
      matchRequestId: matchRequestId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    message,
    type,
    isRead,
    createdAt,
    data,
    groupId,
    matchRequestId,
  ];
}
