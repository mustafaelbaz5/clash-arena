import '../repo/match_request_repo.dart';

class GetOpponentOptionsUseCase {
  final MatchRequestRepo repo;

  GetOpponentOptionsUseCase(this.repo);

  Future<List<Map<String, dynamic>>> call(final String groupId) =>
      repo.getGroupMembers(groupId);
}
