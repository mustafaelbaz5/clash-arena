import '../repo/match_request_repo.dart';

class CreateMatchRequestUseCase {
  final MatchRequestRepo repo;

  CreateMatchRequestUseCase(this.repo);

  Future<void> call({
    required final String groupId,
    required final String opponentId,
    required final int requesterScore,
    required final int opponentScore,
    final String? note,
  }) {
    return repo.createRequest(
      groupId: groupId,
      opponentId: opponentId,
      requesterScore: requesterScore,
      opponentScore: opponentScore,
      note: note,
    );
  }
}
