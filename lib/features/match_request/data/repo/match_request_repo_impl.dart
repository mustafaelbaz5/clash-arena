import 'package:clash_arena/core/errors/error_handler.dart';
import 'package:clash_arena/core/errors/exceptions.dart';

import '../../../../core/networking/network_info.dart';
import '../../domain/entities/match_request_entity.dart';
import '../../domain/repo/match_request_repo.dart';
import '../remote/match_request_remote_ds.dart';

class MatchRequestRepoImpl implements MatchRequestRepo {
  final MatchRequestRemoteDs remoteDs;
  final NetworkInfo networkInfo;

  MatchRequestRepoImpl({required this.remoteDs, required this.networkInfo});

  @override
  Future<List<MatchRequestEntity>> getPendingForMe(
    final String groupId,
  ) async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      return await remoteDs.fetchPendingForMe(groupId);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<List<MatchRequestEntity>> getSentByMe(final String groupId) async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      return await remoteDs.fetchSentByMe(groupId);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getGroupMembers(
    final String groupId,
  ) async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      return await remoteDs.fetchGroupMembers(groupId);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<void> createRequest({
    required final String groupId,
    required final String opponentId,
    required final int requesterScore,
    required final int opponentScore,
    final String? note,
  }) async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      await remoteDs.createRequest(
        groupId: groupId,
        opponentId: opponentId,
        requesterScore: requesterScore,
        opponentScore: opponentScore,
        note: note,
      );
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<String> approve(final String requestId) async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      return await remoteDs.approve(requestId);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<void> reject(final String requestId) async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      await remoteDs.reject(requestId);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
