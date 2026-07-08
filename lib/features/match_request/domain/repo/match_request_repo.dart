import '../entities/match_request_entity.dart';

abstract class MatchRequestRepo {
  /// Requests where the current user is the opponent and still needs to act.
  Future<List<MatchRequestEntity>> getPendingForMe(final String groupId);

  /// Requests the current user sent, of any status, most recent first.
  Future<List<MatchRequestEntity>> getSentByMe(final String groupId);

  /// Members of [groupId] eligible to be picked as an opponent.
  Future<List<Map<String, dynamic>>> getGroupMembers(final String groupId);

  Future<void> createRequest({
    required final String groupId,
    required final String opponentId,
    required final int requesterScore,
    required final int opponentScore,
    final String? note,
  });

  /// Calls the `approve_match` Edge Function — the only path into `matches`.
  Future<void> approve(final String requestId);

  Future<void> reject(final String requestId);
}
