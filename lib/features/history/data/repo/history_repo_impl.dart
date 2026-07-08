import 'package:clash_arena/core/errors/error_handler.dart';
import 'package:clash_arena/core/errors/exceptions.dart';

import '../../../../core/networking/network_info.dart';
import '../models/match_history_card_model.dart';
import '../remote/history_remote_ds.dart';
import 'history_repo.dart';

class HistoryRepoImpl implements HistoryRepo {
  final HistoryRemoteDs historyRemoteDs;
  final NetworkInfo networkInfo;

  HistoryRepoImpl({required this.historyRemoteDs, required this.networkInfo});

  @override
  Future<List<MatchHistoryCardModel>> fetchMatches(
    final String? groupId,
  ) async {
    try {
      if (groupId == null) return [];
      if (!await networkInfo.isConnected) throw NetworkException();
      return await historyRemoteDs.fetchAllMatches(groupId);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
