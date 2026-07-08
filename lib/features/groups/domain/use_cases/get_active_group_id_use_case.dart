import '../repo/groups_repo.dart';

class GetActiveGroupIdUseCase {
  final GroupsRepo repo;

  GetActiveGroupIdUseCase(this.repo);

  Future<String?> call() => repo.getActiveGroupId();
}
