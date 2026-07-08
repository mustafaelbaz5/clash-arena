import '../../../../core/models/match_model.dart';

abstract class AddMatchRepo {
  Future<List<Map<String, dynamic>>> getGroupMembers(final String groupId);
  Future<bool> insertMatch(final MatchModel match, final String groupId);
}
