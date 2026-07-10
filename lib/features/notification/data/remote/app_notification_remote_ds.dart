import '../../../../core/errors/error_handler.dart';
import '../../../../core/networking/supabase_service.dart';
import '../model/app_notification_model.dart';

class AppNotificationRemoteDs {
  final SupabaseService supabaseService;

  AppNotificationRemoteDs({required this.supabaseService});

  String? get _currentUserId => supabaseService.client.auth.currentUser?.id;

  Future<List<AppNotificationModel>> fetchMyNotifications() async {
    final userId = _currentUserId;
    if (userId == null) return [];
    try {
      final rows = await supabaseService.execute(
        supabaseService.client
            .from('user_notifications')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false),
      );
      return (rows as List)
          .map(
            (final row) =>
                AppNotificationModel.fromJson(row as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<void> markAsRead(final int notificationId) async {
    try {
      await supabaseService.execute(
        supabaseService.client
            .from('user_notifications')
            .update({'is_read': true})
            .eq('id', notificationId),
      );
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<void> markAllAsRead() async {
    final userId = _currentUserId;
    if (userId == null) return;
    try {
      await supabaseService.execute(
        supabaseService.client
            .from('user_notifications')
            .update({'is_read': true})
            .eq('user_id', userId)
            .eq('is_read', false),
      );
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }
}
