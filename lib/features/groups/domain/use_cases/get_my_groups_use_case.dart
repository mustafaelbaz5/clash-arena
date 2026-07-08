import '../entities/group_entity.dart';
import '../repo/groups_repo.dart';

class GetMyGroupsUseCase {
  final GroupsRepo repo;

  GetMyGroupsUseCase(this.repo);

  Future<List<GroupEntity>> call() => repo.getMyGroups();
}
