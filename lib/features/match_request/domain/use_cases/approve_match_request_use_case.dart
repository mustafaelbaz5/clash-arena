import '../repo/match_request_repo.dart';

class ApproveMatchRequestUseCase {
  final MatchRequestRepo repo;

  ApproveMatchRequestUseCase(this.repo);

  /// Returns the new match's id.
  Future<String> call(final String requestId) => repo.approve(requestId);
}
