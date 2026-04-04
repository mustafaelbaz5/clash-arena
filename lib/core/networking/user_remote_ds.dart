import 'package:im_legends/core/errors/error_handler.dart';

import '../models/user_data.dart';
import 'supabase_service.dart';

class UserRemoteDS {
  final SupabaseService supabaseService;

  UserRemoteDS({required this.supabaseService});

  Future<void> insertUserProfile(
    final UserData userData,
    final String uid,
  ) async {
    try {
      await supabaseService.client.from('users').insert(userData.toMap(uid));
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<UserData?> fetchUserDataById(final String uid) async {
    try {
      final response = await supabaseService.client
          .from('users')
          .select()
          .eq('id', uid)
          .single();
      return UserData.fromMap(response);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<Map<String, dynamic>?> fetchCurrentUserData() async {
    final user = supabaseService.currentUser;
    if (user == null) return null;

    try {
      final userProfile = await supabaseService.client
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      final tokens = await supabaseService.client
          .from('user_tokens')
          .select('token')
          .eq('user_id', user.id);

      final notifications = await supabaseService.client
          .from('user_notifications')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      return {
        'user': userProfile,
        'tokens': List<String>.from(
          tokens.map((final row) => row['token'] as String),
        ),
        'notifications': notifications
            .map(
              (final row) => {
                'id': row['notification_id'],
                'title': row['title'],
                'message': row['message'],
                'created_at': row['created_at'],
                'type': row['type'],
                'is_read': row['is_read'],
              },
            )
            .toList(),
      };
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }
}
