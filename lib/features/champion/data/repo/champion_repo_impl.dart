import 'package:im_legends/core/errors/error_handler.dart';
import 'package:im_legends/core/errors/exceptions.dart';

import '../../../../core/networking/network_info.dart';
import '../model/champion_player_model.dart';
import '../model/champion_stat_calculator.dart';
import '../remote/champion_remote_ds.dart';
import 'champion_repo.dart';

class ChampionRepoImpl implements ChampionRepo {
  final ChampionRemoteDs championRemoteDs;
  final ChampionStatCalculator calculator;
  final NetworkInfo networkInfo;

  ChampionRepoImpl({
    required this.championRemoteDs,
    required this.calculator,
    required this.networkInfo,
  });

  @override
  Future<List<ChampionPlayerModel>> getLeaderboard() async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      final users = await championRemoteDs.getUsers();
      final matches = await championRemoteDs.getMatches();
      return calculator.compute(users: users, matches: matches);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
