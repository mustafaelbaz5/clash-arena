import 'package:clash_arena/core/errors/error_handler.dart';

import '../../../../core/models/match_model.dart';
import '../../../../core/networking/supabase_service.dart';

class AddMatchRemoteDs {
  final SupabaseService supabaseService;

  AddMatchRemoteDs({required this.supabaseService});

  /// Members of [groupId] only — you can only log a match against someone
  /// in your active group.
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

  Future<bool> insertMatch(final MatchModel match, final String groupId) async {
    try {
      final json = match.toJson()..['group_id'] = groupId;
      await supabaseService.execute(
        supabaseService.client.from('matches').insert(json).select(),
      );
      return true;
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }
}
