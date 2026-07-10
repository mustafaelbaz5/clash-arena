import '../../domain/entities/app_notification_entity.dart';

class AppNotificationModel extends AppNotificationEntity {
  const AppNotificationModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.message,
    required super.type,
    required super.isRead,
    required super.createdAt,
    super.data,
    super.groupId,
    super.matchRequestId,
  });

  factory AppNotificationModel.fromJson(final Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: AppNotificationEntity.typeFromString(json['type'] as String),
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      data: json['data'] == null
          ? const {}
          : Map<String, dynamic>.from(json['data'] as Map),
      groupId: json['group_id'] as String?,
      matchRequestId: json['match_request_id'] as String?,
    );
  }
}
