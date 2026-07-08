import '../../domain/entities/group_entity.dart';

class GroupModel extends GroupEntity {
  const GroupModel({
    required super.id,
    required super.name,
    required super.createdBy,
    required super.isPublic,
    required super.maxMembers,
    required super.createdAt,
    super.inviteCode,
    super.description,
    super.avatarUrl,
    super.archivedAt,
    super.myRole,
  });

  /// Builds from a raw `groups` row, optionally attaching the caller's role
  /// (present when the row came from a `group_members` join).
  factory GroupModel.fromJson(
    final Map<String, dynamic> json, {
    final String? myRole,
  }) {
    return GroupModel(
      id: json['id'] as String,
      name: json['name'] as String,
      inviteCode: json['invite_code'] as String?,
      createdBy: json['created_by'] as String,
      isPublic: json['is_public'] as bool? ?? false,
      maxMembers: json['max_members'] as int? ?? 20,
      description: json['description'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      archivedAt: json['archived_at'] == null
          ? null
          : DateTime.parse(json['archived_at'] as String),
      myRole: myRole ?? json['role'] as String?,
    );
  }

  Map<String, dynamic> toInsertJson() => {
    'name': name,
    'description': description,
    'is_public': isPublic,
    'max_members': maxMembers,
  };
}
