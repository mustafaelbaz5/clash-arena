import 'package:bloc/bloc.dart';
import 'package:im_legends/core/errors/failure.dart';

import '../../data/model/champion_player_model.dart';
import '../../data/repo/champion_repo.dart';

part 'champion_state.dart';

class ChampionCubit extends Cubit<ChampionState> {
  final ChampionRepo championRepo;

  ChampionCubit({required this.championRepo}) : super(const ChampionInitial());

  Future<void> fetchLeaderboard() async {
    emit(const ChampionLoading());
    try {
      final players = await championRepo.getLeaderboard();
      if (players.isEmpty) {
        emit(const ChampionEmpty());
      } else {
        emit(ChampionSuccess(players));
      }
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(ChampionFailure(error: failure));
    }
  }
}
