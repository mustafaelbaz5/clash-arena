import '../repo/match_request_repo.dart';

class RejectMatchRequestUseCase {
  final MatchRequestRepo repo;

  RejectMatchRequestUseCase(this.repo);

  Future<void> call(final String requestId) => repo.reject(requestId);
}
