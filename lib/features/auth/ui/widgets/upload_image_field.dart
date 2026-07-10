import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/extensions/context_ext.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_texts_style.dart';
import '../../../../core/utils/functions/image_picker.dart';
import '../../../../core/utils/spacing.dart';
import '../../../../core/widgets/custom_icon_bottom.dart';

class UploadImageField extends StatefulWidget {
  final Function(File? image)? onImageSelected;

  const UploadImageField({super.key, this.onImageSelected});

  @override
  State<UploadImageField> createState() => _UploadImageFieldState();
}

class _UploadImageFieldState extends State<UploadImageField> {
  File? _profileImage;

  Future<void> _pickImage() async {
    try {
      final pickedImage = await ImagePickerHelper.showImageSourceActionSheet(
        context,
      );
      if (pickedImage != null) {
        setState(() {
          _profileImage = pickedImage;
        });
        widget.onImageSelected?.call(pickedImage);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick image. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Semantics(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: rr(60),
                  backgroundColor: context.customColors.border.withValues(
                    alpha: 0.3,
                  ),
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : null,
                  child: _profileImage == null
                      ? Icon(
                          Icons.person,
                          size: rr(60),
                          color: context.customColors.info,
                        )
                      : null,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: context.customColors.textPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.customColors.background,
                      width: 2.w,
                    ),
                  ),
                  padding: EdgeInsets.all(rr(6)),
                  child: Icon(
                    Icons.edit,
                    color: context.customColors.background,
                    size: rr(16),
                  ),
                ),
              ],
            ),
          ),
        ),
        verticalSpacing(12),

        // Subtle secondary button
        CustomIconBottom(
          icon: Icons.upload,
          onPressed: _pickImage,
          label: 'image_picker.upload_image'.tr(),
          labelStyle: AppTextStyles.font12Regular.copyWith(
            color: AppColors.primary300,
          ),
          iconColor: AppColors.primary300,
        ),
      ],
    );
  }
}
