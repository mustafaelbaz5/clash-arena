import '../../../../core/models/players_states_model.dart';

abstract class HomeRepo {
  /// Empty when [groupId] is null (user has no active group).
  Future<List<PlayerStatsModel>> calculateLeaderboard(final String? groupId);
}
