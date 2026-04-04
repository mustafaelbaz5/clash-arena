import 'dart:io';

import 'package:im_legends/core/errors/error_handler.dart';
import 'package:im_legends/core/errors/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/models/user_data.dart';
import '../../../../core/networking/network_info.dart';
import '../remote/auth_remote_ds.dart';
import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDS remoteDS;
  final NetworkInfo networkInfo;

  AuthRepoImpl({required this.remoteDS, required this.networkInfo});

  @override
  Future<AuthResponse> signUp({
    required final UserData userData,
    required final String password,
    final File? profileImage,
  }) async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      return await remoteDS.signUp(
        userData: userData,
        password: password,
        profileImage: profileImage,
      );
    } catch (e) {
      throw ErrorHandler.handleFailure(e); // returns Failure
    }
  }

  @override
  Future<AuthResponse> login({
    required final String email,
    required final String password,
  }) async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      return await remoteDS.login(email: email, password: password);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      await remoteDS.logout();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<UserData?> getUserDataById(final String uid) async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      return await remoteDS.fetchUserDataById(uid);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
