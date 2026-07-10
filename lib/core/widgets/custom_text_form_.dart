import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../themes/app_texts_style.dart';
import '../utils/extensions/context_ext.dart';

/// AppTextField — reusable outlined text field
/// ─────────────────────────────────────────────
/// Usage:
///   AppTextField(hintText: 'Email')
///   AppTextField(hintText: 'Password', isPassword: true)
///   AppTextField(hintText: 'Notes', maxLines: 4)

class CustomTextForm extends StatefulWidget {
  const CustomTextForm({
    super.key,
    required this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.onTap,
    this.keyboardType,
    this.textInputAction,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.maxLines = 1,
    this.maxLength,
    this.autofocus = false,
    this.enabled = true,
    this.readOnly = false,
    this.inputTextStyle,
    this.hintStyle,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.contentPadding,
    this.isRTL = false,
  });

  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final bool isPassword;
  final int maxLines;
  final int? maxLength;
  final bool autofocus;
  final bool enabled;
  final bool readOnly;
  final bool isRTL;

  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<CustomTextForm> createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleObscure() => setState(() => _obscureText = !_obscureText);

  OutlineInputBorder _border(final Color color, {final double width = 1.0}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final colors = context.customColors;

    final textDirection = widget.isRTL ? TextDirection.rtl : TextDirection.ltr;

    final TextStyle effectiveInputStyle =
        widget.inputTextStyle ??
        AppTextStyles.font16Regular.copyWith(
          color: widget.enabled ? colors.textPrimary : colors.textDisabled,
        );

    final TextStyle effectiveHintStyle =
        widget.hintStyle ??
        AppTextStyles.font16Regular.copyWith(color: colors.textHint);

    final Color defaultBorder = widget.borderColor ?? colors.border;
    final Color focusedBorder =
        widget.focusedBorderColor ?? AppColors.primary50;
    final Color fillColor = widget.backgroundColor ?? colors.surface;

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _obscureText,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      maxLength: widget.maxLength,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      textDirection: textDirection,
      textAlign: widget.isRTL ? TextAlign.right : TextAlign.left,
      style: effectiveInputStyle,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: fillColor,
        hintText: widget.hintText,
        hintStyle: effectiveHintStyle,
        hintTextDirection: textDirection,
        counterText: '',
        contentPadding:
            widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 14, vertical: 18),

        // ─── Prefix / Suffix ───────────────────────────────────────
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: colors.iconSecondary,
                  size: 20,
                ),
                onPressed: _toggleObscure,
              )
            : widget.suffixIcon,

        // ─── Borders ───────────────────────────────────────────────
        border: _border(defaultBorder),
        enabledBorder: _border(defaultBorder),
        focusedBorder: _border(focusedBorder, width: 1.0),
        disabledBorder: _border(colors.border.withValues(alpha: 0.4)),
        errorBorder: _border(AppColors.red200),
        focusedErrorBorder: _border(AppColors.red300, width: 1.5),
      ),
    );
  }
}
