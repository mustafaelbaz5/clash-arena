import 'package:clash_arena/core/errors/error_handler.dart';
import 'package:clash_arena/core/errors/exceptions.dart';

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

  Future<void> createRequest({
    required final String groupId,
    required final String opponentId,
    required final int requesterScore,
    required final int opponentScore,
    final String? note,
  }) async {
    final userId = _currentUserId;
    if (userId == null) {
      throw StateError('Cannot create a match request without an authenticated user.');
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

  Future<void> approve(final String requestId) async {
    try {
      final response = await supabaseService.execute(
        supabaseService.client.functions.invoke(
          'approve_match',
          body: {'request_id': requestId},
        ),
      );
      if (response.status != 200) {
        final message = response.data is Map
            ? (response.data['error'] as String? ?? 'Failed to approve match')
            : 'Failed to approve match';
        throw ServerException(message: message, statusCode: response.status);
      }
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
      for (final u in userRows as List) u['id'] as String: u as Map<String, dynamic>,
    };
    return rows
        .map(
          (final row) =>
              MatchRequestModel.fromJson(row as Map<String, dynamic>, users),
        )
        .toList();
  }
}
