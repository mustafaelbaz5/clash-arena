import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:clash_arena/core/utils/extensions/context_ext.dart';
import 'package:image_picker/image_picker.dart';

import '../../themes/app_texts_style.dart';
import '../spacing.dart';

class ImagePickerHelper {
  static Future<File?> showImageSourceActionSheet(
    final BuildContext context,
  ) async {
    return showModalBottomSheet<File?>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(rr(24))),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: rh(24), horizontal: rw(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.photo_library,
                    color: context.customColors.info,
                  ),
                  title: Text(
                    'image_picker.choose_from_gallery'.tr(),
                    style: AppTextStyles.font16Regular,
                  ),
                  onTap: () async {
                    final result = await _pickImageFromSource(
                      ImageSource.gallery,
                    );
                    if (context.mounted) {
                      Navigator.pop(context, result);
                    }
                  },
                ),
                verticalSpacing(12),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: context.customColors.info,
                  ),
                  title: Text(
                    'image_picker.take_photo'.tr(),
                    style: AppTextStyles.font16Regular,
                  ),
                  onTap: () async {
                    final result = await _pickImageFromSource(
                      ImageSource.camera,
                    );
                    if (context.mounted) {
                      Navigator.pop(context, result);
                    }
                  },
                ),
                verticalSpacing(12),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Handles picking image from camera or gallery
  static Future<File?> _pickImageFromSource(final ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 75);
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
