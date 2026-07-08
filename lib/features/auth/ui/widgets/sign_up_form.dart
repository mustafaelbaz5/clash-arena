import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clash_arena/core/utils/extensions/context_ext.dart';
import 'package:clash_arena/core/widgets/custom_text_form_.dart';

import '../../../../core/models/user_data.dart';
import '../../../../core/themes/app_texts_style.dart';
import '../../../../core/utils/spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_button.dart';
import '../../logic/cubit/auth_cubit.dart';
import 'upload_image_field.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  File? _profileImage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _setProfileImage(final File? image) {
    setState(() => _profileImage = image);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final userData = UserData(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? 0,
      profileImageUrl: null,
    );
    context.hideKeyboard();
    context.read<AuthCubit>().signUp(
      userData: userData,
      password: _passwordController.text.trim(),
      profileImage: _profileImage,
    );
  }

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  @override
  Widget build(final BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Upload Profile Image
          Center(
            child: Column(
              children: [
                UploadImageField(onImageSelected: _setProfileImage),
                if (_profileImage != null)
                  Padding(
                    padding: EdgeInsets.only(top: rh(8)),
                    child: Text(
                      'image_picker.upload_image'.tr(),
                      style: AppTextStyles.font16Regular,
                    ),
                  ),
              ],
            ),
          ),

          verticalSpacing(24),
          Divider(color: context.customColors.divider, thickness: 1),
          verticalSpacing(16),

          // Name Field
          CustomTextForm(
            controller: _nameController,
            hintText: 'auth.name'.tr(),
            validator: (final v) =>
                (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            keyboardType: TextInputType.name,
          ),
          verticalSpacing(16),
          // Age Field
          CustomTextForm(
            controller: _ageController,
            hintText: 'auth.age'.tr(),
            validator: (final v) {
              if (v == null || v.trim().isEmpty) return 'Age is required';
              final age = int.tryParse(v.trim());
              if (age == null || age < 10) return 'Enter a valid age (10+)';
              return null;
            },
            keyboardType: TextInputType.number,
          ),
          verticalSpacing(16),
          // Phone Field
          CustomTextForm(
            controller: _phoneController,
            hintText: 'auth.phone'.tr(),
            validator: (final v) => (v == null || v.trim().isEmpty)
                ? 'Phone number is required'
                : null,
            keyboardType: TextInputType.phone,
          ),

          // Email Field
          verticalSpacing(16),
          CustomTextForm(
            controller: _emailController,
            hintText: 'auth.email'.tr(),
            validator: Validators.email,
            keyboardType: TextInputType.emailAddress,
          ),

          verticalSpacing(16),

          // Password Field
          CustomTextForm(
            controller: _passwordController,
            hintText: 'auth.password'.tr(),
            isPassword: !_isPasswordVisible,
            validator: Validators.password,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: _isPasswordVisible ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          verticalSpacing(16),

          // Confirm Password Field
          CustomTextForm(
            controller: _confirmPasswordController,
            hintText: 'auth.confirm_password'.tr(),
            isPassword: !_isConfirmPasswordVisible,
            validator: (_) {
              final password = _passwordController.text.trim();
              final confirmPassword = _confirmPasswordController.text.trim();
              if (password != confirmPassword) {
                return 'Passwords do not match';
              }
              return null;
            },
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: _isConfirmPasswordVisible ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            keyboardType: TextInputType.visiblePassword,
          ),
          verticalSpacing(32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: CustomTextButton(
              text: 'auth.sign_up'.tr(),
              onPressed: _submit,
            ),
          ),

          verticalSpacing(12),
        ],
      ),
    );
  }
}
