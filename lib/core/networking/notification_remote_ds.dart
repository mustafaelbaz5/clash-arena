import 'package:clash_arena/core/errors/error_handler.dart';
import 'package:clash_arena/core/networking/supabase_service.dart';

class NotificationRemoteDs {
  final SupabaseService supabaseService;

  NotificationRemoteDs({required this.supabaseService});

Future<void> saveToken({
    required final String userId,
    required final String token,
    required final String deviceType, // rename: 'android' or 'ios'
  }) async {
    try {
      await supabaseService.execute(
        supabaseService.client.from('user_tokens').upsert({
          'user_id': userId,
          'token': token,
          'device_type': deviceType, // matches your column name
          'updated_at': DateTime.now().toIso8601String(),
          'last_active': DateTime.now().toIso8601String(),
        }, onConflict: 'user_id,token'),
      );
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<void> deleteToken({
    required final String userId,
    required final String token,
  }) async {
    try {
      await supabaseService.execute(
        supabaseService.client
            .from('user_tokens')
            .delete()
            .eq('user_id', userId)
            .eq('token', token),
      );
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<void> deleteAllUserTokens({required final String userId}) async {
    try {
      await supabaseService.execute(
        supabaseService.client
            .from('user_tokens')
            .delete()
            .eq('user_id', userId),
      );
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }
}
