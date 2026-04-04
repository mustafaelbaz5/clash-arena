import 'package:bloc/bloc.dart';
import 'package:im_legends/core/errors/failure.dart';
import 'package:meta/meta.dart';

import '../../../../core/models/players_states_model.dart';
import '../../data/repo/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo repo;

  HomeCubit({required this.repo}) : super(HomeInitial());

  Future<void> loadLeaderboard() async {
    emit(HomeLoading());
    try {
      final leaderboard = await repo.calculateLeaderboard();
      emit(HomeSuccess(leaderboard));
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(HomeFailure(error: failure));
    }
  }
}
