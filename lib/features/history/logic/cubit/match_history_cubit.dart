import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../../core/errors/failure.dart';
import 'package:meta/meta.dart';

import '../../../../core/events/app_event.dart';
import '../../../../core/events/event_bus.dart';
import '../../../groups/domain/use_cases/get_active_group_id_use_case.dart';
import '../../data/models/match_history_card_model.dart';
import '../../data/repo/history_repo.dart';

part 'match_history_state.dart';

class MatchHistoryCubit extends Cubit<MatchHistoryState> {
  final HistoryRepo historyRepo;
  final GetActiveGroupIdUseCase getActiveGroupId;
  final EventBus eventBus;
  final List<StreamSubscription<AppEvent>> _subs = [];

  MatchHistoryCubit({
    required this.historyRepo,
    required this.getActiveGroupId,
    required this.eventBus,
  }) : super(MatchHistoryInitial()) {
    _subs.add(
      eventBus.on<ActiveGroupChanged>().listen((final _) => fetchMatches()),
    );
    _subs.add(eventBus.on<MatchApproved>().listen((final _) => fetchMatches()));
  }

  Future<void> fetchMatches() async {
    emit(MatchHistoryLoading());
    try {
      final groupId = await getActiveGroupId();
      final matches = await historyRepo.fetchMatches(groupId);
      emit(MatchHistorySuccess(matches: matches));
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(MatchHistoryFailed(error: failure));
    }
  }

  @override
  Future<void> close() {
    for (final sub in _subs) {
      sub.cancel();
    }
    return super.close();
  }
}
