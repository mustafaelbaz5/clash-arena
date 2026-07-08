import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:clash_arena/core/errors/failure.dart';
import 'package:meta/meta.dart';

import '../../../../core/events/app_event.dart';
import '../../../../core/events/event_bus.dart';
import '../../../groups/domain/use_cases/get_active_group_id_use_case.dart';
import '../../data/model/profile_model.dart';
import '../../data/repo/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepo;
  final GetActiveGroupIdUseCase getActiveGroupId;
  final EventBus eventBus;
  late final StreamSubscription<ActiveGroupChanged> _groupSub;

  ProfileCubit({
    required this.profileRepo,
    required this.getActiveGroupId,
    required this.eventBus,
  }) : super(ProfileInitial()) {
    _groupSub = eventBus.on<ActiveGroupChanged>().listen(
      (final _) => fetchProfile(),
    );
  }

  Future<void> fetchProfile() async {
    emit(ProfileLoading());
    try {
      final groupId = await getActiveGroupId();
      final profile = await profileRepo.getProfileWithStats(groupId);
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

  @override
  Future<void> close() {
    _groupSub.cancel();
    return super.close();
  }
}
