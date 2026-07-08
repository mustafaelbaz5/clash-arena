import 'package:equatable/equatable.dart';

class GroupEntity extends Equatable {
  final String id;
  final String name;
  final String? inviteCode;
  final String? createdBy;
  final bool isPublic;
  final int maxMembers;
  final String? description;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? archivedAt;

  /// Current user's role in this group. Null when not applicable
  /// (e.g. public group search results before joining).
  final String? myRole;

  const GroupEntity({
    required this.id,
    required this.name,
    required this.isPublic,
    required this.maxMembers,
    required this.createdAt,
    this.createdBy,
    this.inviteCode,
    this.description,
    this.avatarUrl,
    this.archivedAt,
    this.myRole,
  });

  bool get isArchived => archivedAt != null;

  @override
  List<Object?> get props => [
    id,
    name,
    inviteCode,
    createdBy,
    isPublic,
    maxMembers,
    description,
    avatarUrl,
    createdAt,
    archivedAt,
    myRole,
  ];
}
