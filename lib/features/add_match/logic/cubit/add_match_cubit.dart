import 'package:bloc/bloc.dart';
import 'package:im_legends/core/errors/failure.dart';
import 'package:meta/meta.dart';

import '../../../../core/models/match_model.dart';
import '../../data/repo/add_match_repo.dart';

part 'add_match_state.dart';

class AddMatchCubit extends Cubit<AddMatchState> {
  final AddMatchRepo addMatchRepo;

  AddMatchCubit({required this.addMatchRepo}) : super(const AddMatchInitial());

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
      await addMatchRepo.insertMatch(match);
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
      final players = await addMatchRepo.getAllUsers();
      emit(state.copyWith(players: players));
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(AddMatchFailure(error: failure));
    }
  }
}
