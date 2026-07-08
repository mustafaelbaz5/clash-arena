import '../entities/group_entity.dart';

abstract class GroupsRepo {
  /// Groups the current user is a member of.
  Future<List<GroupEntity>> getMyGroups();

  Future<GroupEntity> createGroup({
    required final String name,
    final String? description,
    final bool isPublic,
    final int maxMembers,
  });

  /// Joins a group via its invite code. Throws [NotFoundException] if the
  /// code doesn't match any group, [ConflictException] if already a member.
  Future<GroupEntity> joinGroupByInviteCode(final String inviteCode);

  /// Persisted "current context" group id, used to scope matches/leaderboard.
  Future<String?> getActiveGroupId();

  Future<void> setActiveGroupId(final String groupId);
}
