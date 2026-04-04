import 'package:flutter/material.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../themes/app_texts_style.dart';
import '../utils/spacing.dart';

class CustomIconBottom extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? label;
  final String? tooltip;
  final Color? iconColor;
  final Color? backgroundColor;
  final TextStyle? labelStyle;

  const CustomIconBottom({
    super.key,
    required this.icon,
    required this.onPressed,
    this.label,
    this.tooltip,
    this.iconColor,
    this.backgroundColor,
    this.labelStyle,
  });

  bool get _hasLabel => label != null;

  @override
  Widget build(final BuildContext context) {
    final borderRadius = BorderRadius.circular(rr(12));

    final Widget button = Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: borderRadius,
      elevation: 0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: label == null ? rw(10) : rw(12),
            vertical: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: rf(20),
                color: iconColor ?? context.customColors.textSecondary,
              ),
              if (_hasLabel) ...[
                horizontalSpacing(6),
                Text(label!, style: labelStyle ?? AppTextStyles.font16Bold),
              ],
            ],
          ),
        ),
      ),
    );

    if (tooltip == null) return button;

    return Tooltip(message: tooltip!, child: button);
  }
}
