import '../../../../core/errors/error_handler.dart';
import '../../../../core/networking/supabase_service.dart';
import '../model/group_model.dart';

class GroupsRemoteDs {
  final SupabaseService supabaseService;

  GroupsRemoteDs({required this.supabaseService});

  String? get _currentUserId => supabaseService.client.auth.currentUser?.id;

  Future<List<GroupModel>> fetchMyGroups() async {
    try {
      final userId = _currentUserId;
      if (userId == null) return [];
      final response = await supabaseService.execute(
        supabaseService.client
            .from('group_members')
            .select('role, joined_at, groups(*)')
            .eq('user_id', userId)
            .order('joined_at'),
      );
      return (response as List)
          .map(
            (final row) => GroupModel.fromJson(
              (row as Map<String, dynamic>)['groups'] as Map<String, dynamic>,
              myRole: row['role'] as String?,
            ),
          )
          .toList();
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<GroupModel> createGroup(final GroupModel draft) async {
    try {
      final userId = _currentUserId;
      if (userId == null) {
        throw StateError(
          'Cannot create a group without an authenticated user.',
        );
      }

      final response = await supabaseService.execute(
        supabaseService.client
            .from('groups')
            .insert({...draft.toInsertJson(), 'created_by': userId})
            .select()
            .single(),
      );
      final group = GroupModel.fromJson(response, myRole: 'owner');

      await supabaseService.execute(
        supabaseService.client.from('group_members').insert({
          'group_id': group.id,
          'user_id': userId,
          'role': 'owner',
        }),
      );

      return group;
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  /// Joins a group by invite code via the `join_group_by_invite_code`
  /// Postgres RPC (SECURITY DEFINER), since private groups aren't
  /// SELECT-able by non-members under RLS — the lookup must happen
  /// server-side. See groups_remote_ds.dart doc comment for the SQL.
  Future<GroupModel> joinGroupByInviteCode(final String inviteCode) async {
    try {
      final response = await supabaseService.execute(
        supabaseService.client.rpc(
          'join_group_by_invite_code',
          params: {'p_invite_code': inviteCode},
        ),
      );
      final row = response is List
          ? response.first as Map<String, dynamic>
          : response as Map<String, dynamic>;
      return GroupModel.fromJson(row, myRole: 'member');
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }
}
