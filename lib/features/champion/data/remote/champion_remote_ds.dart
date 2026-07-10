import '../../../../core/errors/error_handler.dart';

import '../../../../core/networking/supabase_service.dart';

class ChampionRemoteDs {
  final SupabaseService subbaseService;

  ChampionRemoteDs({required this.subbaseService});

  Future<List<Map<String, dynamic>>> getMatches(final String groupId) async {
    try {
      final response = await subbaseService.execute(
        subbaseService.client
            .from('matches')
            .select('winner_id, loser_id, winner_score, loser_score')
            .eq('group_id', groupId),
      );
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  /// Members of [groupId] only — champions are scoped to the active group.
  Future<List<Map<String, dynamic>>> getUsers(final String groupId) async {
    try {
      final response = await subbaseService.execute(
        subbaseService.client
            .from('group_members')
            .select('users(id, name, profile_image)')
            .eq('group_id', groupId),
      );
      return (response as List)
          .map((final row) => Map<String, dynamic>.from(row['users'] as Map))
          .toList();
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }
}
