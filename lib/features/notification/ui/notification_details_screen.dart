import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/models/players_states_model.dart';
import '../../../core/utils/extensions/context_ext.dart';
import '../../../core/utils/extensions/datetime_ext.dart';
import '../../../core/router/routes.dart';
import '../../auth/logic/cubit/auth_cubit.dart';
import '../../home/data/repo/home_repo.dart';
import '../domain/entities/app_notification_entity.dart';

class NotificationDetailsScreen extends StatefulWidget {
  const NotificationDetailsScreen({super.key, required this.notification});

  final AppNotificationEntity notification;

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState
    extends State<NotificationDetailsScreen> {
  late final Future<List<PlayerStatsModel>> _leaderboardFuture;

  @override
  void initState() {
    super.initState();
    final groupId = widget.notification.groupId;
    _leaderboardFuture = groupId == null
        ? Future.value(const <PlayerStatsModel>[])
        : getIt<HomeRepo>().calculateLeaderboard(groupId);
  }

  @override
  Widget build(final BuildContext context) {
    final notification = widget.notification;
    final data = notification.data;
    final winnerName = data['winner_name'] as String?;
    final loserName = data['loser_name'] as String?;
    final winnerScore = data['winner_score'];
    final loserScore = data['loser_score'];
    final groupName = data['group_name'] as String?;
    final note = data['note'] as String?;
    final hasMatchDetails = winnerName != null && loserName != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Notification')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4),
            Text(
              notification.createdAt.formattedDateTime,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(notification.message),
            if (hasMatchDetails) ...[
              const SizedBox(height: 24),
              _SectionCard(
                title: 'Match result',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailRow('Winner', '$winnerName ($winnerScore)'),
                    _DetailRow('Loser', '$loserName ($loserScore)'),
                    if (groupName != null) _DetailRow('Group', groupName),
                    if (note != null && note.isNotEmpty)
                      _DetailRow('Note', note),
                  ],
                ),
              ),
            ],
            if (groupName != null) ...[
              const SizedBox(height: 16),
              _SectionCard(
                title: 'Your standing in $groupName',
                child: FutureBuilder<List<PlayerStatsModel>>(
                  future: _leaderboardFuture,
                  builder: (final context, final snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final leaderboard = snapshot.data ?? const [];
                    final myId = context.read<AuthCubit>().state
                        is AuthAuthenticated
                        ? (context.read<AuthCubit>().state as AuthAuthenticated)
                              .user
                              ?.id
                        : null;
                    PlayerStatsModel? myStats;
                    for (final p in leaderboard) {
                      if (p.playerId == myId) {
                        myStats = p;
                        break;
                      }
                    }

                    if (myStats == null) {
                      return const Text(
                        'You are no longer a member of this group.',
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _DetailRow('Current rank', '#${myStats.rank}'),
                        _DetailRow('Points', '${myStats.points}'),
                        _DetailRow(
                          'Record',
                          '${myStats.wins}W - ${myStats.losses}L',
                        ),
                        _DetailRow(
                          'Goals',
                          '${myStats.goalsScored} scored / ${myStats.goalsReceived} conceded',
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
            if (notification.matchRequestId != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(Routes.matchRequestScreen),
                  child: const Text('View Match Requests'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return Card(
      elevation: 0,
      color: context.customColors.divider.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: context.customColors.textSecondary)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
