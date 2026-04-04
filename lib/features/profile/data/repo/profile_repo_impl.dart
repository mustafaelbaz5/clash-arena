import 'dart:io';

import "../../../../core/errors/error_handler.dart";
import '../../../../core/errors/exceptions.dart';

import '../../../../core/models/players_states_model.dart';
import '../../../../core/models/user_data.dart';
import '../../../../core/networking/network_info.dart';
import '../model/profile_model.dart';
import '../remote/profile_remote_ds.dart';
import 'profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDs profileRemoteDs;
  final NetworkInfo networkInfo;

  ProfileRepoImpl({required this.profileRemoteDs, required this.networkInfo});

  @override
  Future<UserData?> getCurrentUserData() async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      return await profileRemoteDs.getCurrentUserData();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<UserProfileModel?> getProfileWithStats() async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();

      final userData = await profileRemoteDs.getCurrentUserData();
      if (userData == null) return null;

      final matches = await profileRemoteDs.getAllUserMatches();

      final stats = calculateStats(
        userId: profileRemoteDs.currentUserId!,
        userName: userData.name,
        profileImage: userData.profileImageUrl,
        matches: matches,
      );

      return UserProfileModel(user: userData, stats: stats);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await profileRemoteDs.logout();
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }

  @override
  Future<String?> uploadAndSetProfileImage(final File imageFile) async {
    try {
      if (!await networkInfo.isConnected) throw NetworkException();
      return await profileRemoteDs.uploadAndSetProfileImage(imageFile);
    } catch (e) {
      throw ErrorHandler.handleFailure(e);
    }
  }
}
