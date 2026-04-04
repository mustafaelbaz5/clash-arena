import 'package:flutter/material.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/spacing.dart';

class OnBoardingHeroImage extends StatelessWidget {
  const OnBoardingHeroImage({super.key});

  @override
  Widget build(final BuildContext context) {
    // Give a fixed height based on screen
    final double imageHeight = rh(500);

    return Stack(
      children: [
        // SVG with fixed height
        SizedBox(
          width: double.infinity,
          height: imageHeight,
          child: Image.asset(AppAssets.onBoardingHeroPnd, fit: BoxFit.cover),
        ),
      ],
    );
  }
}
