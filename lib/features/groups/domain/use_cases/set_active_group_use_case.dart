import '../repo/groups_repo.dart';

class SetActiveGroupUseCase {
  final GroupsRepo repo;

  SetActiveGroupUseCase(this.repo);

  Future<void> call(final String groupId) => repo.setActiveGroupId(groupId);
}
