import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clash_arena/core/errors/failure.dart';

import '../../../../core/events/app_event.dart';
import '../../../../core/events/event_bus.dart';
import '../../../groups/domain/use_cases/get_active_group_id_use_case.dart';
import '../../data/model/champion_player_model.dart';
import '../../data/repo/champion_repo.dart';

part 'champion_state.dart';

class ChampionCubit extends Cubit<ChampionState> {
  final ChampionRepo championRepo;
  final GetActiveGroupIdUseCase getActiveGroupId;
  final EventBus eventBus;
  late final StreamSubscription<ActiveGroupChanged> _groupSub;

  ChampionCubit({
    required this.championRepo,
    required this.getActiveGroupId,
    required this.eventBus,
  }) : super(const ChampionInitial()) {
    _groupSub = eventBus.on<ActiveGroupChanged>().listen(
      (final _) => fetchLeaderboard(),
    );
  }

  Future<void> fetchLeaderboard() async {
    emit(const ChampionLoading());
    try {
      final groupId = await getActiveGroupId();
      final players = await championRepo.getLeaderboard(groupId);
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

  @override
  Future<void> close() {
    _groupSub.cancel();
    return super.close();
  }
}
