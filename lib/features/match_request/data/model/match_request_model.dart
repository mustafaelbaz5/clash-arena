import '../../domain/entities/match_request_entity.dart';

class MatchRequestModel extends MatchRequestEntity {
  const MatchRequestModel({
    required super.id,
    required super.groupId,
    required super.requesterId,
    required super.requesterName,
    required super.opponentId,
    required super.opponentName,
    required super.requesterScore,
    required super.opponentScore,
    required super.status,
    required super.createdAt,
    super.requesterImage,
    super.opponentImage,
    super.note,
    super.matchId,
    super.expiresAt,
    super.respondedAt,
  });

  /// [users] maps user id -> {name, profile_image}, fetched separately
  /// since `match_requests` has two FKs into `users` and we don't rely on
  /// PostgREST's FK-disambiguation aliases (constraint names aren't known
  /// here).
  factory MatchRequestModel.fromJson(
    final Map<String, dynamic> json,
    final Map<String, Map<String, dynamic>> users,
  ) {
    final requester = users[json['requester_id']] ?? const {};
    final opponent = users[json['opponent_id']] ?? const {};

    return MatchRequestModel(
      id: json['id'] as String,
      groupId: json['group_id'] as String,
      requesterId: json['requester_id'] as String,
      requesterName: requester['name'] as String? ?? 'Unknown',
      requesterImage: requester['profile_image'] as String?,
      opponentId: json['opponent_id'] as String,
      opponentName: opponent['name'] as String? ?? 'Unknown',
      opponentImage: opponent['profile_image'] as String?,
      requesterScore: json['requester_score'] as int,
      opponentScore: json['opponent_score'] as int,
      status: matchRequestStatusFromString(json['status'] as String),
      note: json['note'] as String?,
      matchId: json['match_id'] as String?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      respondedAt: json['responded_at'] == null
          ? null
          : DateTime.parse(json['responded_at'] as String),
    );
  }
}
