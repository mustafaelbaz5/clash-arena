import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/networking/network_info.dart';
import '../../../../core/service/shared_prefs.dart';
import '../../../../core/utils/app_constants.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/repo/groups_repo.dart';
import '../model/group_model.dart';
import '../remote/groups_remote_ds.dart';

class GroupsRepoImpl implements GroupsRepo {
  final GroupsRemoteDs remoteDs;
  final NetworkInfo networkInfo;

  GroupsRepoImpl({required this.remoteDs, required this.networkInfo});

  @override
  Future<List<GroupEntity>> getMyGroups() async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      return await remoteDs.fetchMyGroups();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<GroupEntity> createGroup({
    required final String name,
    final String? description,
    final bool isPublic = false,
    final int maxMembers = 20,
  }) async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      final draft = GroupModel(
        id: '',
        name: name,
        isPublic: isPublic,
        maxMembers: maxMembers,
        createdAt: DateTime.now(),
        description: description,
      );
      final group = await remoteDs.createGroup(draft);
      await setActiveGroupId(group.id);
      return group;
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<GroupEntity> joinGroupByInviteCode(final String inviteCode) async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      final group = await remoteDs.joinGroupByInviteCode(inviteCode);
      await setActiveGroupId(group.id);
      return group;
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<String?> getActiveGroupId() async {
    final id = await SharedPref.getString(AppConstants.activeGroupIdKey);
    return id.isEmpty ? null : id;
  }

  @override
  Future<void> setActiveGroupId(final String groupId) {
    return SharedPref.setData(AppConstants.activeGroupIdKey, groupId);
  }
}
