import 'package:bloc/bloc.dart';
import 'package:im_legends/core/errors/failure.dart';
import 'package:meta/meta.dart';

import '../../data/models/match_history_card_model.dart';
import '../../data/repo/history_repo.dart';

part 'match_history_state.dart';

class MatchHistoryCubit extends Cubit<MatchHistoryState> {
  final HistoryRepo historyRepo;

  MatchHistoryCubit({required this.historyRepo}) : super(MatchHistoryInitial());

  Future<void> fetchMatches() async {
    emit(MatchHistoryLoading());
    try {
      final matches = await historyRepo.fetchMatches();
      emit(MatchHistorySuccess(matches: matches));
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(MatchHistoryFailed(error: failure));
    }
  }
}
