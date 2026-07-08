import '../repo/groups_repo.dart';

/// Resolves the current active group id, self-healing when nothing has
/// been persisted yet (e.g. first launch after joining a group, or a user
/// who has never opened the Groups screen) by falling back to the user's
/// earliest group membership and persisting that as the new active group.
///
/// Returns null only when the user has no group memberships at all.
class GetActiveGroupIdUseCase {
  final GroupsRepo repo;

  GetActiveGroupIdUseCase(this.repo);

  Future<String?> call() async {
    final stored = await repo.getActiveGroupId();
    if (stored != null) return stored;

    final groups = await repo.getMyGroups();
    if (groups.isEmpty) return null;

    final fallback = groups.first.id;
    await repo.setActiveGroupId(fallback);
    return fallback;
  }
}
