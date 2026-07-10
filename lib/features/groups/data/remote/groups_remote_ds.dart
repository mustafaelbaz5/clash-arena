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

  /// Creates the group and adds the caller as owner via the `create_group`
  /// SQL function (SECURITY DEFINER). A plain client insert+select doesn't
  /// work here: for a private group, `.select()` requires the new row to
  /// pass the `groups` SELECT policy (is_public OR is_group_member(id)),
  /// but the owner's group_members row doesn't exist until the second
  /// insert — so returning the freshly-inserted row fails RLS even though
  /// the insert itself was otherwise valid.
  Future<GroupModel> createGroup(final GroupModel draft) async {
    try {
      final response = await supabaseService.execute(
        supabaseService.client.rpc(
          'create_group',
          params: {
            'p_name': draft.name,
            'p_description': draft.description,
            'p_is_public': draft.isPublic,
            'p_max_members': draft.maxMembers,
          },
        ),
      );
      final row = response is List
          ? response.first as Map<String, dynamic>
          : response as Map<String, dynamic>;
      return GroupModel.fromJson(row, myRole: 'owner');
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
