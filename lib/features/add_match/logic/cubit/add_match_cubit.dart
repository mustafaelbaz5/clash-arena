import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clash_arena/core/errors/failure.dart';
import 'package:meta/meta.dart';

import '../../../../core/events/app_event.dart';
import '../../../../core/events/event_bus.dart';
import '../../../../core/models/match_model.dart';
import '../../../groups/domain/use_cases/get_active_group_id_use_case.dart';
import '../../data/repo/add_match_repo.dart';

part 'add_match_state.dart';

class AddMatchCubit extends Cubit<AddMatchState> {
  final AddMatchRepo addMatchRepo;
  final GetActiveGroupIdUseCase getActiveGroupId;
  final EventBus eventBus;
  late final StreamSubscription<ActiveGroupChanged> _groupSub;

  AddMatchCubit({
    required this.addMatchRepo,
    required this.getActiveGroupId,
    required this.eventBus,
  }) : super(const AddMatchInitial()) {
    _groupSub = eventBus.on<ActiveGroupChanged>().listen(
      (final _) => getPlayersList(),
    );
  }

  void updateWinnerScore(final int change) {
    final newScore = state.winnerScore + change;
    if (newScore < 0) return;

    int adjustedLoser = state.loserScore;
    if (newScore <= state.loserScore) {
      adjustedLoser = newScore > 0 ? newScore - 1 : 0;
    }

    emit(state.copyWith(winnerScore: newScore, loserScore: adjustedLoser));
  }

  void updateLoserScore(final int change) {
    final newScore = state.loserScore + change;
    if (newScore < 0 || newScore > state.winnerScore) return;
    emit(state.copyWith(loserScore: newScore));
  }

  bool canIncrementLoser() => state.loserScore <= state.winnerScore;

  void updateWinner(
    final String playerId,
    final String name,
    final String imageUrl,
  ) {
    emit(
      state.copyWith(
        winnerId: playerId,
        winnerName: name,
        winnerImage: imageUrl,
      ),
    );
  }

  void updateLoser(
    final String playerId,
    final String name,
    final String imageUrl,
  ) {
    emit(
      state.copyWith(loserId: playerId, loserName: name, loserImage: imageUrl),
    );
  }

  bool canSubmit() {
    return state.winnerId != null &&
        state.loserId != null &&
        state.winnerId != state.loserId &&
        state.winnerScore >= state.loserScore;
  }

  Future<void> addMatch(final MatchModel match) async {
    emit(state.copyWith(isLoading: true, isSuccess: false, error: null));
    try {
      final groupId = await getActiveGroupId();
      if (groupId == null) {
        emit(
          state.copyWith(
            isLoading: false,
            error: const NotFoundFailure(
              message: 'Join or create a group before adding a match.',
            ),
          ),
        );
        return;
      }
      await addMatchRepo.insertMatch(match, groupId);
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(state.copyWith(isLoading: false, error: failure));
    }
  }

  void resetMatchData() {
    emit(
      const AddMatchState(
        winnerScore: 0,
        loserScore: 0,
        winnerId: null,
        winnerName: null,
        winnerImage: null,
        loserId: null,
        loserName: null,
        loserImage: null,
      ),
    );
  }

  Future<void> getPlayersList() async {
    try {
      final groupId = await getActiveGroupId();
      if (groupId == null) {
        emit(state.copyWith(players: const []));
        return;
      }
      final players = await addMatchRepo.getGroupMembers(groupId);
      emit(state.copyWith(players: players));
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(AddMatchFailure(error: failure));
    }
  }

  @override
  Future<void> close() {
    _groupSub.cancel();
    return super.close();
  }
}
