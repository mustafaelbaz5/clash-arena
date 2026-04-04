import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../../core/models/user_data.dart';
import '../../../../core/utils/spacing.dart';
import '../../../../core/widgets/custom_icon_bottom.dart';
import 'profile_menu_item.dart';
import 'profile_section_body.dart';

class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({super.key, required this.userDataModel});
  final UserData userDataModel;

  @override
  Widget build(final BuildContext context) {
    return ProfileSectionBody(
      title: 'profile.info.title'.tr(),
      items: <Widget>[
        ProfileMenuItem(
          icon: Icons.person_outline,
          title: "profile.info.name".tr(),
          subtitle: userDataModel.name,
          onTap: () {},
          trailing: _copyToClipboard(userDataModel.name),
        ),
        Divider(
          height: 1,
          indent: rw(60),
          endIndent: rw(20),
          color: context.customColors.border,
        ),
        ProfileMenuItem(
          icon: Icons.email_outlined,
          title: "profile.info.email".tr(),
          subtitle: userDataModel.email,
          onTap: () {},
          trailing: _copyToClipboard(userDataModel.email),
        ),
        Divider(
          height: 1,
          indent: rw(60),
          endIndent: rw(20),
          color: context.customColors.border,
        ),
        ProfileMenuItem(
          icon: Icons.phone_outlined,
          title: "profile.info.phone".tr(),
          subtitle: userDataModel.phoneNumber,
          onTap: () {},
          trailing: _copyToClipboard(userDataModel.phoneNumber),
        ),
        Divider(
          height: 1,
          indent: rw(60),
          endIndent: rw(20),
          color: context.customColors.border,
        ),
        ProfileMenuItem(
          icon: Icons.cake_outlined,
          title: "profile.info.age".tr(),
          subtitle: userDataModel.age.toString(),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _copyToClipboard(final String value) {
    return Builder(
      builder: (final context) {
        return CustomIconBottom(
          icon: Icons.copy,
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            // context.showSnackBar(
            //   SnackBar(
            //     content: Text("student_profile.copy_to_clipboard".tr()),
            //     duration: const Duration(seconds: 1),
            //   ),
            // );
          },
        );
      },
    );
  }
}
