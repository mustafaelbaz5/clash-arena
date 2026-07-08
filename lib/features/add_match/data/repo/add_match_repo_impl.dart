import 'package:clash_arena/core/errors/error_handler.dart';
import 'package:clash_arena/core/errors/exceptions.dart';

import '../../../../core/models/match_model.dart';
import '../../../../core/networking/network_info.dart';
import '../remote/add_match_remote_ds.dart';
import 'add_match_repo.dart';

class AddMatchRepoImpl implements AddMatchRepo {
  final AddMatchRemoteDs addMatchService;
  final NetworkInfo networkInfo;

  AddMatchRepoImpl({required this.addMatchService, required this.networkInfo});

  @override
  Future<List<Map<String, dynamic>>> getGroupMembers(
    final String groupId,
  ) async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      return await addMatchService.fetchGroupMembers(groupId);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<bool> insertMatch(final MatchModel match, final String groupId) async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      return await addMatchService.insertMatch(match, groupId);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
