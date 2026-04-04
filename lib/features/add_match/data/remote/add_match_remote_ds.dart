import 'package:im_legends/core/errors/error_handler.dart';

import '../../../../core/models/match_model.dart';
import '../../../../core/networking/supabase_service.dart';

class AddMatchRemoteDs {
  final SupabaseService supabaseService;

  AddMatchRemoteDs({required this.supabaseService});

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    try {
      final response = await supabaseService.execute(
        supabaseService.client
            .from('users')
            .select('id, name, profile_image')
            .order('name', ascending: true),
      );

      return response
          .map(
            (final user) => {
              'id': user['id'] as String,
              'name': user['name'] as String,
              'profile_image': user['profile_image'] as String?,
            },
          )
          .toList();
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<bool> insertMatch(final MatchModel match) async {
    try {
      await supabaseService.execute(
        supabaseService.client.from('matches').insert(match.toJson()).select(),
      );
      return true;
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }
}
