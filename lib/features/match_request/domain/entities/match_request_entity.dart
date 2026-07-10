import 'package:equatable/equatable.dart';

enum MatchRequestStatus { pending, accepted, rejected, expired, cancelled }

MatchRequestStatus matchRequestStatusFromString(final String value) {
  return MatchRequestStatus.values.firstWhere(
    (final s) => s.name == value,
    orElse: () => MatchRequestStatus.pending,
  );
}

class MatchRequestEntity extends Equatable {
  final String id;
  final String groupId;
  final String requesterId;
  final String requesterName;
  final String? requesterImage;
  final String opponentId;
  final String opponentName;
  final String? opponentImage;

  /// The stored result — `match_requests` records winner/loser directly
  /// (same shape as `matches`), not per-side scores.
  final String winnerId;
  final String loserId;
  final int winnerScore;
  final int loserScore;

  final MatchRequestStatus status;
  final String? note;
  final String? matchId;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime? respondedAt;
  final String? respondedBy;

  const MatchRequestEntity({
    required this.id,
    required this.groupId,
    required this.requesterId,
    required this.requesterName,
    required this.opponentId,
    required this.opponentName,
    required this.winnerId,
    required this.loserId,
    required this.winnerScore,
    required this.loserScore,
    required this.status,
    required this.createdAt,
    this.requesterImage,
    this.opponentImage,
    this.note,
    this.matchId,
    this.expiresAt,
    this.respondedAt,
    this.respondedBy,
  });

  bool isOpponent(final String userId) => opponentId == userId;

  bool get isPending => status == MatchRequestStatus.pending;

  bool get requesterWon => requesterId == winnerId;

  /// Scores from the requester's perspective — matches what the "New
  /// match request" form collects ("your score" / "opponent score").
  int get requesterScore => requesterWon ? winnerScore : loserScore;
  int get opponentScore => requesterWon ? loserScore : winnerScore;

  @override
  List<Object?> get props => [
    id,
    groupId,
    requesterId,
    requesterName,
    requesterImage,
    opponentId,
    opponentName,
    opponentImage,
    winnerId,
    loserId,
    winnerScore,
    loserScore,
    status,
    note,
    matchId,
    expiresAt,
    createdAt,
    respondedAt,
    respondedBy,
  ];
}
