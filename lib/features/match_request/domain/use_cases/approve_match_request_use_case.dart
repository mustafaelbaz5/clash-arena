import '../repo/match_request_repo.dart';

class ApproveMatchRequestUseCase {
  final MatchRequestRepo repo;

  ApproveMatchRequestUseCase(this.repo);

  Future<void> call(final String requestId) => repo.approve(requestId);
}
