import '../entities/group_entity.dart';
import '../repo/groups_repo.dart';

class CreateGroupUseCase {
  final GroupsRepo repo;

  CreateGroupUseCase(this.repo);

  Future<GroupEntity> call({
    required final String name,
    final String? description,
    final bool isPublic = false,
    final int maxMembers = 20,
  }) {
    return repo.createGroup(
      name: name,
      description: description,
      isPublic: isPublic,
      maxMembers: maxMembers,
    );
  }
}
