import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clash_arena/core/errors/failure.dart';
import 'package:meta/meta.dart';

import '../../../../core/events/app_event.dart';
import '../../../../core/events/event_bus.dart';
import '../../../groups/domain/use_cases/get_active_group_id_use_case.dart';
import '../../domain/entities/match_request_entity.dart';
import '../../domain/use_cases/approve_match_request_use_case.dart';
import '../../domain/use_cases/create_match_request_use_case.dart';
import '../../domain/use_cases/get_opponent_options_use_case.dart';
import '../../domain/use_cases/get_pending_requests_use_case.dart';
import '../../domain/use_cases/get_sent_requests_use_case.dart';
import '../../domain/use_cases/reject_match_request_use_case.dart';

part 'match_request_state.dart';

class MatchRequestCubit extends Cubit<MatchRequestState> {
  final GetActiveGroupIdUseCase getActiveGroupId;
  final GetPendingRequestsUseCase getPendingRequests;
  final GetSentRequestsUseCase getSentRequests;
  final GetOpponentOptionsUseCase getOpponentOptions;
  final CreateMatchRequestUseCase createMatchRequest;
  final ApproveMatchRequestUseCase approveMatchRequest;
  final RejectMatchRequestUseCase rejectMatchRequest;
  final EventBus eventBus;
  late final StreamSubscription<ActiveGroupChanged> _groupSub;

  MatchRequestCubit({
    required this.getActiveGroupId,
    required this.getPendingRequests,
    required this.getSentRequests,
    required this.getOpponentOptions,
    required this.createMatchRequest,
    required this.approveMatchRequest,
    required this.rejectMatchRequest,
    required this.eventBus,
  }) : super(MatchRequestInitial()) {
    _groupSub = eventBus.on<ActiveGroupChanged>().listen(
      (final _) => loadRequests(),
    );
  }

  Future<void> loadRequests() async {
    emit(MatchRequestLoading());
    try {
      final groupId = await getActiveGroupId();
      if (groupId == null) {
        emit(MatchRequestLoaded(pending: const [], sent: const []));
        return;
      }
      final pending = await getPendingRequests(groupId);
      final sent = await getSentRequests(groupId);
      emit(MatchRequestLoaded(pending: pending, sent: sent));
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(MatchRequestActionFailure(error: failure));
    }
  }

  Future<List<Map<String, dynamic>>> loadOpponentOptions() async {
    final groupId = await getActiveGroupId();
    if (groupId == null) return [];
    return getOpponentOptions(groupId);
  }

  Future<bool> create({
    required final String opponentId,
    required final int requesterScore,
    required final int opponentScore,
    final String? note,
  }) async {
    try {
      final groupId = await getActiveGroupId();
      if (groupId == null) {
        emit(
          MatchRequestActionFailure(
            error: const NotFoundFailure(
              message: 'Join or create a group before requesting a match.',
            ),
          ),
        );
        return false;
      }
      await createMatchRequest(
        groupId: groupId,
        opponentId: opponentId,
        requesterScore: requesterScore,
        opponentScore: opponentScore,
        note: note,
      );
      await loadRequests();
      return true;
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(MatchRequestActionFailure(error: failure));
      return false;
    }
  }

  Future<void> approve(final MatchRequestEntity request) async {
    try {
      final matchId = await approveMatchRequest(request.id);
      eventBus.fire(
        MatchApproved(
          matchId: matchId,
          matchRequestId: request.id,
          groupId: request.groupId,
        ),
      );
      await loadRequests();
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(MatchRequestActionFailure(error: failure));
    }
  }

  Future<void> reject(final MatchRequestEntity request) async {
    try {
      await rejectMatchRequest(request.id);
      eventBus.fire(
        MatchRejected(
          matchRequestId: request.id,
          groupId: request.groupId,
          requesterId: request.requesterId,
        ),
      );
      await loadRequests();
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(MatchRequestActionFailure(error: failure));
    }
  }

  @override
  Future<void> close() {
    _groupSub.cancel();
    return super.close();
  }
}
