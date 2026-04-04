part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final List<PlayerStatsModel> leaderboard;
  HomeSuccess(this.leaderboard);
}

final class HomeFailure extends HomeState {
  final Failure error;
  HomeFailure({required this.error});
}
