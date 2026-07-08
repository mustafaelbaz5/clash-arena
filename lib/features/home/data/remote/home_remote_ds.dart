import 'package:clash_arena/core/errors/error_handler.dart';
import '../../../../core/networking/supabase_service.dart';

class HomeRemoteDs {
  final SupabaseService supabaseService;

  HomeRemoteDs({required this.supabaseService});

  Future<List<Map<String, dynamic>>> fetchMatches(final String groupId) async {
    try {
      final response = await supabaseService.execute(
        supabaseService.client
            .from('matches')
            .select('*')
            .eq('group_id', groupId),
      );
      return response;
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  /// Members of [groupId] only — the leaderboard must not show players
  /// outside the active group.
  Future<List<Map<String, dynamic>>> fetchGroupMembers(
    final String groupId,
  ) async {
    try {
      final response = await supabaseService.execute(
        supabaseService.client
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
