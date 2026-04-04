import 'package:im_legends/core/errors/error_handler.dart';
import '../../../../core/networking/supabase_service.dart';

class HomeRemoteDs {
  final SupabaseService supabaseService;

  HomeRemoteDs({required this.supabaseService});

  Future<List<Map<String, dynamic>>> fetchMatches() async {
    try {
      final response = await supabaseService.execute(
        supabaseService.client.from('matches').select('*'),
      );
      return response;
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final response = await supabaseService.execute(
        supabaseService.client.from('users').select('id, name, profile_image'),
      );
      return response;
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }
}
