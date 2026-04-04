part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final UserProfileModel profile;

  ProfileSuccess({required this.profile});
}

final class ProfileFailure extends ProfileState {
  final Failure error;

  ProfileFailure({required this.error});
}

final class ProfileLoggedOut extends ProfileState {}
