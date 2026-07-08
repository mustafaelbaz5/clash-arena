import 'dart:io';

import '../../../../core/models/user_data.dart';
import '../model/profile_model.dart';

abstract class ProfileRepo {
  /// Fetch current user data
  Future<UserData?> getCurrentUserData();

  /// Fetch user profile with calculated stats, scoped to [groupId].
  /// Stats are empty when [groupId] is null (no active group).
  Future<UserProfileModel?> getProfileWithStats(final String? groupId);

  /// Uploads a profile image and updates the user's record in one step
  Future<String?> uploadAndSetProfileImage(final File imageFile);

  /// Logout user
  Future<void> logout();
}
