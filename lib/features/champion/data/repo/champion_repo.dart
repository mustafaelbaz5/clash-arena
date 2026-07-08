import '../model/champion_player_model.dart';

abstract class ChampionRepo {
  /// Empty when [groupId] is null (user has no active group).
  Future<List<ChampionPlayerModel>> getLeaderboard(final String? groupId);
}
