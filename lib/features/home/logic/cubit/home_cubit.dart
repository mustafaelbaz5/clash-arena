import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clash_arena/core/errors/failure.dart';
import 'package:meta/meta.dart';

import '../../../../core/events/app_event.dart';
import '../../../../core/events/event_bus.dart';
import '../../../../core/models/players_states_model.dart';
import '../../../groups/domain/use_cases/get_active_group_id_use_case.dart';
import '../../data/repo/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo repo;
  final GetActiveGroupIdUseCase getActiveGroupId;
  final EventBus eventBus;
  final List<StreamSubscription<AppEvent>> _subs = [];

  HomeCubit({
    required this.repo,
    required this.getActiveGroupId,
    required this.eventBus,
  }) : super(HomeInitial()) {
    _subs.add(eventBus.on<ActiveGroupChanged>().listen((final _) => loadLeaderboard()));
    _subs.add(eventBus.on<MatchApproved>().listen((final _) => loadLeaderboard()));
  }

  Future<void> loadLeaderboard() async {
    emit(HomeLoading());
    try {
      final groupId = await getActiveGroupId();
      final leaderboard = await repo.calculateLeaderboard(groupId);
      emit(HomeSuccess(leaderboard));
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(HomeFailure(error: failure));
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
