import '../entities/match_request_entity.dart';
import '../repo/match_request_repo.dart';

class GetPendingRequestsUseCase {
  final MatchRequestRepo repo;

  GetPendingRequestsUseCase(this.repo);

  Future<List<MatchRequestEntity>> call(final String groupId) =>
      repo.getPendingForMe(groupId);
}
