part of 'match_request_cubit.dart';

@immutable
sealed class MatchRequestState {}

final class MatchRequestInitial extends MatchRequestState {}

final class MatchRequestLoading extends MatchRequestState {}

final class MatchRequestLoaded extends MatchRequestState {
  final List<MatchRequestEntity> pending;
  final List<MatchRequestEntity> sent;

  MatchRequestLoaded({required this.pending, required this.sent});
}

final class MatchRequestActionFailure extends MatchRequestState {
  final Failure error;

  MatchRequestActionFailure({required this.error});
}
