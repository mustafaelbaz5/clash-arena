import 'package:bloc/bloc.dart';
import 'package:clash_arena/core/errors/failure.dart';
import 'package:flutter/material.dart';

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

  GroupsCubit({
    required this.getMyGroups,
    required this.createGroup,
    required this.joinGroup,
    required this.getActiveGroupId,
    required this.setActiveGroup,
  }) : super(GroupsInitial());

  Future<void> loadGroups() async {
    emit(GroupsLoading());
    try {
      final groups = await getMyGroups();
      var activeId = await getActiveGroupId();

      // Fall back to the first available group so callers always have a
      // scoping context once membership exists.
      if ((activeId == null || groups.every((final g) => g.id != activeId)) &&
          groups.isNotEmpty) {
        activeId = groups.first.id;
        await setActiveGroup(activeId);
      }

      emit(GroupsLoaded(groups: groups, activeGroupId: activeId));
    } catch (e) {
      debugPrint('Error loading groups: $e');
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
  }
}
