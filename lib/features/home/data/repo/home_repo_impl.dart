import 'package:im_legends/core/errors/error_handler.dart';
import 'package:im_legends/core/errors/exceptions.dart';

import '../../../../core/models/players_states_model.dart';
import '../../../../core/networking/network_info.dart';
import '../remote/home_remote_ds.dart';
import 'home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDs remoteDs;
  final NetworkInfo networkInfo;

  HomeRepoImpl({required this.remoteDs, required this.networkInfo});

  @override
  Future<List<PlayerStatsModel>> calculateLeaderboard() async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();

      final matches = await remoteDs.fetchMatches();
      final users = await remoteDs.fetchUsers();

      final Map<String, PlayerStatsModel> stats = {
        for (var u in users)
          u['id']: PlayerStatsModel(
            playerId: u['id'],
            playerName: u['name'],
            profileImage: u['profile_image'],
          ),
      };

      for (var match in matches) {
        final winnerId = match['winner_id'] as String;
        final loserId = match['loser_id'] as String;
        final winnerScore = match['winner_score'] as int;
        final loserScore = match['loser_score'] as int;

        final winner = stats[winnerId]!;
        final loser = stats[loserId]!;

        stats[winnerId] = winner.copyWith(
          matchesPlayed: winner.matchesPlayed + 1,
          wins: winner.wins + 1,
          goalsScored: winner.goalsScored + winnerScore,
          goalsReceived: winner.goalsReceived + loserScore,
          points: winner.points + 3,
        );

        stats[loserId] = loser.copyWith(
          matchesPlayed: loser.matchesPlayed + 1,
          losses: loser.losses + 1,
          goalsScored: loser.goalsScored + loserScore,
          goalsReceived: loser.goalsReceived + winnerScore,
        );
      }

      final leaderboard = stats.values.toList()
        ..sort((final a, final b) {
          if (b.points != a.points) return b.points.compareTo(a.points);
          if (b.goalsScored - b.goalsReceived !=
              a.goalsScored - a.goalsReceived) {
            return (b.goalsScored - b.goalsReceived).compareTo(
              a.goalsScored - a.goalsReceived,
            );
          }
          return b.goalsScored.compareTo(a.goalsScored);
        });

      for (int i = 0; i < leaderboard.length; i++) {
        leaderboard[i] = leaderboard[i].copyWith(rank: i + 1);
      }

      return leaderboard;
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
