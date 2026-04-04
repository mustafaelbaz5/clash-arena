import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:im_legends/core/utils/extensions/context_ext.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_texts_style.dart';
import '../../../../../core/utils/spacing.dart';

class PlayerTile extends StatelessWidget {
  final String playerName;
  final String playerImage;
  final String playerId;
  final bool isSelected;
  final int index;

  final void Function(String id, String name, String imageUrl) onSelect;

  const PlayerTile({
    super.key,
    required this.playerName,
    required this.isSelected,
    required this.index,
    required this.onSelect,
    required this.playerImage,
    required this.playerId,
  });

  @override
  Widget build(final BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(vertical: rh(4)),
      padding: EdgeInsets.symmetric(horizontal: rw(12), vertical: rh(10)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(rr(16)),
        color: isSelected
            ? context.customColors.background
            : context.customColors.background.withValues(alpha: 0.5),
        border: isSelected
            ? Border.all(color: AppColors.primary300, width: 1.5)
            : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(rr(16)),
        onTap: () => onSelect(playerId, playerName, playerImage),
        child: Row(
          children: [
            _buildAvatar(),
            horizontalSpacing(16),
            Expanded(
              child: Text(
                playerName,
                style: isSelected
                    ? AppTextStyles.font14Bold
                    : AppTextStyles.font14Regular,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary300,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final hasImage = playerImage.isNotEmpty;

    return Container(
      width: rw(40),
      height: rh(40),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.primaries[index % Colors.primaries.length].withAlpha(
              (0.9 * 255).toInt(),
            ),
            Colors.primaries[(index + 1) % Colors.primaries.length].withAlpha(
              (0.7 * 255).toInt(),
            ),
          ],
        ),
      ),
      child: Center(
        child: hasImage
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: playerImage,
                  fit: BoxFit.cover,
                  width: rw(40),
                  height: rh(40),
                  placeholder: (final context, final url) => SizedBox(
                    width: rw(20),
                    height: rh(20),
                    child: Icon(
                      Icons.person,
                      color: context.customColors.textPrimary,
                    ),
                  ),
                  errorWidget: (final context, final url, final error) => Icon(
                    Icons.person,
                    color: context.customColors.textPrimary,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
