import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/extensions/context_ext.dart';
import '../domain/entities/group_entity.dart';
import '../logic/cubit/groups_cubit.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        actions: [
          IconButton(
            tooltip: 'Join group',
            icon: const Icon(Icons.group_add_outlined),
            onPressed: () => _showJoinDialog(context),
          ),
          IconButton(
            tooltip: 'Create group',
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<GroupsCubit, GroupsState>(
        listener: (final context, final state) {
          if (state is GroupsFailure) {
            context.showErrorSnackBar(state.error.message);
          }
        },
        builder: (final context, final state) {
          if (state is GroupsLoading || state is GroupsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GroupsFailure) {
            return Center(child: Text(state.error.message));
          }
          final loaded = state as GroupsLoaded;
          if (loaded.groups.isEmpty) {
            return const Center(
              child: Text('No groups yet. Create or join one to get started.'),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<GroupsCubit>().loadGroups(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: loaded.groups.length,
              separatorBuilder: (final _, final _) =>
                  const SizedBox(height: 8),
              itemBuilder: (final context, final index) {
                final group = loaded.groups[index];
                final isActive = group.id == loaded.activeGroupId;
                return _GroupTile(
                  group: group,
                  isActive: isActive,
                  onTap: () =>
                      context.read<GroupsCubit>().switchActiveGroup(group.id),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showCreateDialog(final BuildContext context) {
    final cubit = context.read<GroupsCubit>();
    final nameController = TextEditingController();
    bool isPublic = false;

    showDialog<void>(
      context: context,
      builder: (final dialogContext) => StatefulBuilder(
        builder: (final dialogContext, final setState) => AlertDialog(
          title: const Text('Create group'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Group name'),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: isPublic,
                title: const Text('Public (discoverable)'),
                onChanged: (final value) =>
                    setState(() => isPublic = value ?? false),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) return;
                Navigator.pop(dialogContext);
                cubit.create(name: name, isPublic: isPublic);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinDialog(final BuildContext context) {
    final cubit = context.read<GroupsCubit>();
    final codeController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (final dialogContext) => AlertDialog(
        title: const Text('Join group'),
        content: TextField(
          controller: codeController,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(labelText: 'Invite code'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final code = codeController.text.trim();
              if (code.isEmpty) return;
              Navigator.pop(dialogContext);
              cubit.joinByInviteCode(code);
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  const _GroupTile({
    required this.group,
    required this.isActive,
    required this.onTap,
  });

  final GroupEntity group;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return Card(
      elevation: 0,
      color: isActive
          ? context.colorScheme.primaryContainer
          : context.customColors.divider.withValues(alpha: 0.3),
      child: ListTile(
        title: Text(group.name),
        subtitle: Text(
          '${group.myRole ?? 'member'} · ${group.inviteCode ?? '—'}',
        ),
        trailing: isActive ? const Icon(Icons.check_circle) : null,
        onTap: onTap,
      ),
    );
  }
}
