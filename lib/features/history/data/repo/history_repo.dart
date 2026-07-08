import '../models/match_history_card_model.dart';

abstract class HistoryRepo {
  /// Empty when [groupId] is null (user has no active group).
  Future<List<MatchHistoryCardModel>> fetchMatches(final String? groupId);
}
