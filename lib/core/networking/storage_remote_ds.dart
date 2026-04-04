import 'dart:io';

import 'package:im_legends/core/errors/error_handler.dart';

import 'supabase_service.dart';

class StorageRemoteDs {
  final SupabaseService supabaseService;

  StorageRemoteDs({required this.supabaseService});

  Future<String?> uploadProfileImage(
    final File imageFile,
    final String userId,
  ) async {
    final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '$userId/$fileName';

    try {
      await supabaseService.client.storage
          .from('profile_images')
          .upload(filePath, imageFile);

      return supabaseService.client.storage
          .from('profile_images')
          .getPublicUrl(filePath);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<void> updateUserProfileImage(
    final String userId,
    final String imageUrl,
  ) async {
    try {
      await supabaseService.client
          .from('users')
          .update({'profile_image': imageUrl})
          .eq('id', userId);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<void> deleteProfileImage(final String filePath) async {
    try {
      await supabaseService.client.storage.from('profile_images').remove([
        filePath,
      ]);
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }

  Future<String?> uploadAndSetProfileImage(
    final String userId,
    final File imageFile,
  ) async {
    try {
      final imageUrl = await uploadProfileImage(imageFile, userId);
      if (imageUrl == null) return null;

      await updateUserProfileImage(userId, imageUrl);
      return imageUrl;
    } catch (e) {
      ErrorHandler.handleException(e);
    }
  }
}
