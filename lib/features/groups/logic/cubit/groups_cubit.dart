import 'package:bloc/bloc.dart';
import '../../../../core/errors/failure.dart';
import 'package:meta/meta.dart';

import '../../../../core/events/app_event.dart';
import '../../../../core/events/event_bus.dart';
import '../../domain/entities/group_entity.dart';
import '../../domain/use_cases/create_group_use_case.dart';
import '../../domain/use_cases/get_active_group_id_use_case.dart';
import '../../domain/use_cases/get_my_groups_use_case.dart';
import '../../domain/use_cases/join_group_use_case.dart';
import '../../domain/use_cases/set_active_group_use_case.dart';

part 'groups_state.dart';

class GroupsCubit extends Cubit<GroupsState> {
  final GetMyGroupsUseCase getMyGroups;
  final CreateGroupUseCase createGroup;
  final JoinGroupUseCase joinGroup;
  final GetActiveGroupIdUseCase getActiveGroupId;
  final SetActiveGroupUseCase setActiveGroup;
  final EventBus eventBus;

  GroupsCubit({
    required this.getMyGroups,
    required this.createGroup,
    required this.joinGroup,
    required this.getActiveGroupId,
    required this.setActiveGroup,
    required this.eventBus,
  }) : super(GroupsInitial());

  Future<void> loadGroups() async {
    emit(GroupsLoading());
    try {
      final groups = await getMyGroups();
      // getActiveGroupId() already self-heals to the earliest membership
      // when nothing is stored; re-validate in case the stored group was
      // left/archived since.
      var activeId = await getActiveGroupId();
      if (activeId != null && groups.every((final g) => g.id != activeId)) {
        activeId = groups.isEmpty ? null : groups.first.id;
        if (activeId != null) await setActiveGroup(activeId);
      }

      emit(GroupsLoaded(groups: groups, activeGroupId: activeId));
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(GroupsFailure(error: failure));
    }
  }

  Future<void> create({
    required final String name,
    final String? description,
    final bool isPublic = false,
    final int maxMembers = 20,
  }) async {
    try {
      await createGroup(
        name: name,
        description: description,
        isPublic: isPublic,
        maxMembers: maxMembers,
      );
      await loadGroups();
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(GroupsFailure(error: failure));
    }
  }

  Future<void> joinByInviteCode(final String inviteCode) async {
    try {
      await joinGroup(inviteCode);
      await loadGroups();
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(GroupsFailure(error: failure));
    }
  }

  Future<void> switchActiveGroup(final String groupId) async {
    final current = state;
    if (current is! GroupsLoaded) return;
    await setActiveGroup(groupId);
    emit(current.copyWith(activeGroupId: groupId));
    eventBus.fire(ActiveGroupChanged(groupId: groupId));
  }
}
