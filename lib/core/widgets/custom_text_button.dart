import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../utils/spacing.dart';

/// AppButton — reusable button widget
/// ─────────────────────────────────────
/// Usage:
///   AppButton(text: 'Submit', onPressed: () {})
///   AppButton.outlined(text: 'Cancel', onPressed: () {})
///   AppButton.text(text: 'Skip', onPressed: () {})
///
/// Customize:
///   AppButton(
///     text: 'Login',
///     onPressed: () {},
///     size: AppButtonSize.large,
///     isFullWidth: false,
///     prefixIcon: Icon(Icons.login),
///     isLoading: _loading,
///   )

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style = CustomButtonStyle.filled,
    this.size = CustomButtonSize.medium,
    this.isFullWidth = true,
    this.isLoading = false,
    this.isDisabled = false,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
  });

  /// Outlined style constructor
  const CustomTextButton.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = CustomButtonSize.medium,
    this.isFullWidth = true,
    this.isLoading = false,
    this.isDisabled = false,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
  }) : style = CustomButtonStyle.outlined;

  /// Text only style constructor
  const CustomTextButton.text({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = CustomButtonSize.medium,
    this.isFullWidth = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderRadius,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
  }) : style = CustomButtonStyle.textOnly;

  final String text;
  final VoidCallback? onPressed;
  final CustomButtonStyle style;
  final CustomButtonSize size;
  final bool isFullWidth;
  final bool isLoading;
  final bool isDisabled;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;

  bool get _isEnabled => onPressed != null && !isLoading && !isDisabled;

  // ─── Resolved sizes ───────────────────────────────────────────────────
  double get _height => switch (size) {
    CustomButtonSize.small => 40,
    CustomButtonSize.medium => 52,
    CustomButtonSize.large => 56,
  };

  double get _iconSize => size == CustomButtonSize.small ? 18 : 20;

  // TextStyle get _defaultTextStyle => size == CustomButtonSize.small
  //     ? AppTextStyles.font14Bold
  //     : AppTextStyles.font16Bold;

  // ─── Resolved colors by style ─────────────────────────────────────────
  Color _resolveBackground(final BuildContext context) {
    if (!_isEnabled) return AppColors.grey100;
    return switch (style) {
      CustomButtonStyle.filled => backgroundColor ?? AppColors.primary200,
      CustomButtonStyle.outlined => Colors.transparent,
      CustomButtonStyle.textOnly => Colors.transparent,
    };
  }

  Color _resolveForeground(final BuildContext context) {
    if (!_isEnabled) return AppColors.grey400;
    return switch (style) {
      CustomButtonStyle.filled => foregroundColor ?? AppColors.white,
      CustomButtonStyle.outlined => foregroundColor ?? AppColors.primary200,
      CustomButtonStyle.textOnly => foregroundColor ?? AppColors.primary200,
    };
  }

  BorderSide _resolveBorder(final Color foreground) {
    if (style != CustomButtonStyle.outlined) return BorderSide.none;
    return BorderSide(
      color: _isEnabled
          ? (borderColor ?? AppColors.primary200)
          : AppColors.grey200,
      width: 1.5,
    );
  }

  @override
  Widget build(final BuildContext context) {
    final Color bg = _resolveBackground(context);
    final Color fg = _resolveForeground(context);
    final BorderSide border = _resolveBorder(fg);
    final double radius = borderRadius ?? 12;

    // Inside build(), replace effectiveTextStyle with:
    final TextStyle effectiveTextStyle =
        (textStyle ??
                Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: size == CustomButtonSize.small ? 14 : 16,
                ))
            .copyWith(color: fg);

    final Widget child = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null) ...[
                IconTheme(
                  data: IconThemeData(size: _iconSize, color: fg),
                  child: prefixIcon!,
                ),
                horizontalSpacing(8),
              ],
              Flexible(
                child: Text(
                  text,
                  style: effectiveTextStyle,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (suffixIcon != null) ...[
                horizontalSpacing(8),
                IconTheme(
                  data: IconThemeData(size: _iconSize, color: fg),
                  child: suffixIcon!,
                ),
              ],
            ],
          );

    return SizedBox(
      height: _height,
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: _isEnabled ? onPressed : null,
        style:
            ElevatedButton.styleFrom(
              backgroundColor: bg,
              foregroundColor: fg,
              disabledBackgroundColor: AppColors.grey100,
              disabledForegroundColor: AppColors.grey400,
              elevation: 0,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              padding:
                  contentPadding ??
                  EdgeInsets.symmetric(
                    horizontal: size == CustomButtonSize.small ? 16 : 24,
                    vertical: 12,
                  ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
                side: border,
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.all(fg.withValues(alpha: 0.08)),
            ),
        child: child,
      ),
    );
  }
}

// ─── Enums ────────────────────────────────────────────────────────────────────

enum CustomButtonSize { small, medium, large }

enum CustomButtonStyle { filled, outlined, textOnly }
