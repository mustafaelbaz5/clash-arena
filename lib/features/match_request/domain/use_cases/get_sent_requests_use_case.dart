import '../entities/match_request_entity.dart';
import '../repo/match_request_repo.dart';

class GetSentRequestsUseCase {
  final MatchRequestRepo repo;

  GetSentRequestsUseCase(this.repo);

  Future<List<MatchRequestEntity>> call(final String groupId) =>
      repo.getSentByMe(groupId);
}
