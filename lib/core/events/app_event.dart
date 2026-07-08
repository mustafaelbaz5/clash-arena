import 'package:meta/meta.dart';

/// Domain events emitted when significant state changes occur.
/// Side effects (notifications, leaderboard refresh, badge checks) subscribe
/// to these instead of being called directly from cubits/repos.
@immutable
sealed class AppEvent {
  const AppEvent();
}

final class MatchRequestCreated extends AppEvent {
  final String matchRequestId;
  final String groupId;
  final String requesterId;
  final String opponentId;

  const MatchRequestCreated({
    required this.matchRequestId,
    required this.groupId,
    required this.requesterId,
    required this.opponentId,
  });
}

final class MatchApproved extends AppEvent {
  final String matchId;
  final String matchRequestId;
  final String groupId;

  const MatchApproved({
    required this.matchId,
    required this.matchRequestId,
    required this.groupId,
  });
}

final class MatchRejected extends AppEvent {
  final String matchRequestId;
  final String groupId;
  final String requesterId;

  const MatchRejected({
    required this.matchRequestId,
    required this.groupId,
    required this.requesterId,
  });
}

final class UserJoinedGroup extends AppEvent {
  final String groupId;
  final String userId;

  const UserJoinedGroup({required this.groupId, required this.userId});
}

final class GroupCreated extends AppEvent {
  final String groupId;
  final String createdBy;

  const GroupCreated({required this.groupId, required this.createdBy});
}

final class LeaderboardUpdated extends AppEvent {
  final String groupId;

  const LeaderboardUpdated({required this.groupId});
}

/// Fired when the user's active group context changes. Group-scoped
/// features (leaderboard, history, champions, profile stats) subscribe
/// to this and refetch rather than being called directly.
final class ActiveGroupChanged extends AppEvent {
  final String groupId;

  const ActiveGroupChanged({required this.groupId});
}
