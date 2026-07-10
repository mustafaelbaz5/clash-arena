import '../../../../core/errors/error_handler.dart';

import '../../../../core/networking/supabase_service.dart';
import '../model/match_request_model.dart';

class MatchRequestRemoteDs {
  final SupabaseService supabaseService;

  MatchRequestRemoteDs({required this.supabaseService});

  String? get _currentUserId => supabaseService.client.auth.currentUser?.id;

  Future<List<MatchRequestModel>> fetchPendingForMe(
    final String groupId,
  ) async {
    final userId = _currentUserId;
    if (userId == null) return [];
    try {
      final rows = await supabaseService.execute(
        supabaseService.client
            .from('match_requests')
            .select()
            .eq('group_id', groupId)
            .eq('opponent_id', userId)
            .eq('status', 'pending')
            .order('created_at', ascending: false),
      );
      return _toModels(rows as List);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<List<MatchRequestModel>> fetchSentByMe(final String groupId) async {
    final userId = _currentUserId;
    if (userId == null) return [];
    try {
      final rows = await supabaseService.execute(
        supabaseService.client
            .from('match_requests')
            .select()
            .eq('group_id', groupId)
            .eq('requester_id', userId)
            .order('created_at', ascending: false),
      );
      return _toModels(rows as List);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  /// Members of [groupId] excluding the current user — you can't request a
  /// match against yourself.
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
          .where((final u) => u['id'] != _currentUserId)
          .toList();
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<void> createRequest({
    required final String groupId,
    required final String opponentId,
    required final int requesterScore,
    required final int opponentScore,
    final String? note,
  }) async {
    final userId = _currentUserId;
    if (userId == null) {
      throw StateError(
        'Cannot create a match request without an authenticated user.',
      );
    }
    try {
      await supabaseService.execute(
        supabaseService.client.from('match_requests').insert({
          'group_id': groupId,
          'requester_id': userId,
          'opponent_id': opponentId,
          'requester_score': requesterScore,
          'opponent_score': opponentScore,
          'note': note,
        }),
      );
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  /// Calls the `approve_match_request` SQL function (SECURITY DEFINER) —
  /// the only path allowed to insert into `matches`. Returns the new
  /// match's id.
  Future<String> approve(final String requestId) async {
    try {
      final response = await supabaseService.execute(
        supabaseService.client.rpc(
          'approve_match_request',
          params: {'p_request_id': requestId},
        ),
      );
      final row = response is List
          ? response.first as Map<String, dynamic>
          : response as Map<String, dynamic>;
      return row['match_id'] as String;
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<void> reject(final String requestId) async {
    try {
      await supabaseService.execute(
        supabaseService.client
            .from('match_requests')
            .update({
              'status': 'rejected',
              'responded_at': DateTime.now().toIso8601String(),
            })
            .eq('id', requestId),
      );
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<List<MatchRequestModel>> _toModels(final List rows) async {
    if (rows.isEmpty) return [];
    final userIds = <String>{
      for (final row in rows) row['requester_id'] as String,
      for (final row in rows) row['opponent_id'] as String,
    };
    final userRows = await supabaseService.execute(
      supabaseService.client
          .from('users')
          .select('id, name, profile_image')
          .inFilter('id', userIds.toList()),
    );
    final users = <String, Map<String, dynamic>>{
      for (final u in userRows as List)
        u['id'] as String: u as Map<String, dynamic>,
    };
    return rows
        .map(
          (final row) =>
              MatchRequestModel.fromJson(row as Map<String, dynamic>, users),
        )
        .toList();
  }
}
