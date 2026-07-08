import '../entities/group_entity.dart';
import '../repo/groups_repo.dart';

class JoinGroupUseCase {
  final GroupsRepo repo;

  JoinGroupUseCase(this.repo);

  Future<GroupEntity> call(final String inviteCode) =>
      repo.joinGroupByInviteCode(inviteCode.trim().toUpperCase());
}
