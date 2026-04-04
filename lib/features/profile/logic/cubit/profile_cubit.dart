import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:im_legends/core/errors/failure.dart';
import 'package:meta/meta.dart';

import '../../data/model/profile_model.dart';
import '../../data/repo/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;

  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await profileRepo.getProfileWithStats();
      if (profile != null) {
        emit(ProfileSuccess(profile: profile));
      } else {
        emit(ProfileFailure(error: const NotFoundFailure()));
      }
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(ProfileFailure(error: failure));
    }
  }

  Future<void> uploadProfileImage(final File imageFile) async {
    emit(ProfileLoading());
    try {
      final newImageUrl = await profileRepo.uploadAndSetProfileImage(imageFile);
      if (newImageUrl != null) {
        await fetchProfile();
      } else {
        emit(
          ProfileFailure(
            error: const ServerFailure(
              message: 'Failed to upload profile image.',
            ),
          ),
        );
      }
    } catch (e) {
      final failure = e is Failure ? e : const UnknownFailure();
      emit(ProfileFailure(error: failure));
    }
  }
}
