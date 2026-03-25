import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../../../core/utils/spacing.dart';

class PlayerFieldAvatar extends StatelessWidget {
  final bool isSelected;
  final String? imageUrl;

  const PlayerFieldAvatar({super.key, required this.isSelected, this.imageUrl});

  @override
  Widget build(final BuildContext context) {
    final accentColor = context.customColors.background;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      width: rw(44),
      height: rh(44),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.customColors.surface,
        border: isSelected ? Border.all(color: accentColor, width: 2) : null,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
        gradient: !isSelected || imageUrl == null
            ? LinearGradient(
                colors: [
                  context.customColors.divider,
                  context.customColors.divider.withValues(alpha: 0.5),
                ],
              )
            : null,
      ),
      child: ClipOval(
        child: isSelected && imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, _) => Center(
                  child: SizedBox(
                    width: rw(16),
                    height: rh(16),
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, final __, final ___) =>
                    Icon(Icons.person, color: context.customColors.textPrimary),
              )
            : Icon(
                isSelected ? Icons.person : Icons.person_outline,
                color: context.customColors.textSecondary,
              ),
      ),
    );
  }
}
