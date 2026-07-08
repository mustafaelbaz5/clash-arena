import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clash_arena/core/utils/extensions/context_ext.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/functions/image_picker.dart';
import '../../../../core/utils/spacing.dart';
import '../../logic/cubit/profile_cubit.dart';

class ProfileImageAvatar extends StatefulWidget {
  const ProfileImageAvatar({
    super.key,
    required this.profileImageUrl,
    required this.onEditTap,
  });

  final String profileImageUrl;
  final VoidCallback onEditTap;

  @override
  State<ProfileImageAvatar> createState() => _ProfileImageAvatarState();
}

class _ProfileImageAvatarState extends State<ProfileImageAvatar> {
  File? _profileImage;
  Future<void> _pickImage() async {
    try {
      final pickedImage = await ImagePickerHelper.showImageSourceActionSheet(
        context,
      );

      if (!mounted || pickedImage == null) return;

      // Optional: show a loading indicator
      setState(() => _profileImage = pickedImage);

      // Upload and update DB
      await context.read<ProfileCubit>().uploadProfileImage(pickedImage);

      if (!mounted) return;

      // Call callback with new image if needed
      widget.onEditTap();

      // Optionally update the UI immediately
      setState(() {
        _profileImage = pickedImage;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick or upload image. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        /// Avatar
        Container(
          padding: EdgeInsets.all(rw(4)),
          width: rw(140),
          height: rw(140),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: context.customColors.background,
              width: 3,
            ),
            color: context.customColors.divider,
          ),
          child: ClipOval(
            child: _profileImage != null
                ? Image.file(_profileImage!, fit: BoxFit.cover)
                : CachedNetworkImage(
                    imageUrl: widget.profileImageUrl,
                    fit: BoxFit.cover,
                    placeholder: (final context, final url) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.customColors.info,
                      ),
                    ),
                    errorWidget: (final context, final url, final error) =>
                        Icon(
                          Icons.person,
                          color: context.customColors.textPrimary,
                          size: rf(60),
                        ),
                  ),
          ),
        ),

        /// Edit Icon
        Positioned(
          bottom: 8,
          right: 8,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              padding: EdgeInsets.all(rw(6)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.customColors.background,
              ),
              child: Icon(
                Icons.edit,
                size: rf(16),
                color: AppColors.primary300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
