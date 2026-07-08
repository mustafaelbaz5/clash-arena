part of 'groups_cubit.dart';

@immutable
sealed class GroupsState {}

final class GroupsInitial extends GroupsState {}

final class GroupsLoading extends GroupsState {}

final class GroupsLoaded extends GroupsState {
  final List<GroupEntity> groups;
  final String? activeGroupId;

  GroupsLoaded({required this.groups, required this.activeGroupId});

  GroupEntity? get activeGroup {
    for (final group in groups) {
      if (group.id == activeGroupId) return group;
    }
    return null;
  }

  GroupsLoaded copyWith({
    final List<GroupEntity>? groups,
    final String? activeGroupId,
  }) {
    return GroupsLoaded(
      groups: groups ?? this.groups,
      activeGroupId: activeGroupId ?? this.activeGroupId,
    );
  }
}

final class GroupsFailure extends GroupsState {
  final Failure error;

  GroupsFailure({required this.error});
}
