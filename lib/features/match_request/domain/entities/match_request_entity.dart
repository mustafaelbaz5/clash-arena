import 'package:equatable/equatable.dart';

enum MatchRequestStatus { pending, approved, rejected, expired, cancelled }

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
  final int requesterScore;
  final int opponentScore;
  final MatchRequestStatus status;
  final String? note;
  final String? matchId;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime? respondedAt;

  const MatchRequestEntity({
    required this.id,
    required this.groupId,
    required this.requesterId,
    required this.requesterName,
    required this.opponentId,
    required this.opponentName,
    required this.requesterScore,
    required this.opponentScore,
    required this.status,
    required this.createdAt,
    this.requesterImage,
    this.opponentImage,
    this.note,
    this.matchId,
    this.expiresAt,
    this.respondedAt,
  });

  bool isOpponent(final String userId) => opponentId == userId;

  bool get isPending => status == MatchRequestStatus.pending;

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
    requesterScore,
    opponentScore,
    status,
    note,
    matchId,
    expiresAt,
    createdAt,
    respondedAt,
  ];
}
