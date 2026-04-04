import 'package:im_legends/core/errors/error_handler.dart';
import 'package:im_legends/core/errors/exceptions.dart';

import '../../../../core/networking/network_info.dart';
import '../models/match_history_card_model.dart';
import '../remote/history_remote_ds.dart';
import 'history_repo.dart';

class HistoryRepoImpl implements HistoryRepo {
  final HistoryRemoteDs historyRemoteDs;
  final NetworkInfo networkInfo;

  HistoryRepoImpl({required this.historyRemoteDs, required this.networkInfo});

  @override
  Future<List<MatchHistoryCardModel>> fetchMatches() async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      return await historyRemoteDs.fetchAllMatches();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
