import 'package:im_legends/core/errors/error_handler.dart';

import '../../../../core/networking/supabase_service.dart';

class ChampionRemoteDs {
  final SupabaseService subbaseService;

  ChampionRemoteDs({required this.subbaseService});

  Future<List<Map<String, dynamic>>> getMatches() async {
    try {
      final response = await subbaseService.execute(
        subbaseService.client
            .from('matches')
            .select('winner_id, loser_id, winner_score, loser_score'),
      );
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final response = await subbaseService.execute(
        subbaseService.client.from('users').select('id, name, profile_image'),
      );
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }
}
