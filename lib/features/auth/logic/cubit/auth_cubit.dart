import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:im_legends/core/errors/failure.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../core/models/user_data.dart';
import '../../../../core/networking/supabase_service.dart';
import '../../data/repo/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authRepo}) : super(AuthInitial());

  final AuthRepo authRepo;

  Future<void> checkAuthStatus() async {
    final user = getIt<SupabaseService>().currentUser;

    if (user != null) {
      final userData = await _fetchUserData(user.id);
      emit(AuthAuthenticated(userData));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> signUp({
    required final UserData userData,
    required final String password,
    final File? profileImage,
  }) async {
    emit(AuthLoading());
    try {
      final AuthResponse response = await authRepo.signUp(
        userData: userData,
        password: password,
        profileImage: profileImage,
      );

      final UserData? fetchedUser = await _fetchUserData(response.user?.id);
      emit(AuthAuthenticated(fetchedUser ?? userData));
    } catch (error) {
      final failure = error is Failure ? error : const UnknownFailure();
      emit(AuthError(failure));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login({
    required final String email,
    required final String password,
  }) async {
    emit(AuthLoading());
    try {
      final AuthResponse response = await authRepo.login(
        email: email,
        password: password,
      );

      final UserData? userData = await _fetchUserData(response.user?.id);
      emit(AuthAuthenticated(userData));
    } catch (error) {
      final failure = error is Failure ? error : const UnknownFailure();
      emit(AuthError(failure));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await authRepo.logout();
      emit(AuthUnauthenticated());
    } catch (error) {
      final failure = error is Failure ? error : const UnknownFailure();
      emit(AuthError(failure));
    }
  }

  Future<UserData?> _fetchUserData(final String? uid) async {
    if (uid == null) return null;
    try {
      return await authRepo.getUserDataById(uid);
    } catch (_) {
      return null;
    }
  }
}
