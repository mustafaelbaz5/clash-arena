part of 'champion_cubit.dart';

sealed class ChampionState {
  const ChampionState();
}

class ChampionInitial extends ChampionState {
  const ChampionInitial();
}

class ChampionLoading extends ChampionState {
  const ChampionLoading();
}

class ChampionSuccess extends ChampionState {
  final List<ChampionPlayerModel> players;
  const ChampionSuccess(this.players);
}

class ChampionEmpty extends ChampionState {
  const ChampionEmpty();
}

class ChampionFailure extends ChampionState {
  final Failure error;
  const ChampionFailure({required this.error});
}
