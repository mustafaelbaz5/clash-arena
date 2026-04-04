import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/spacing.dart';

class HomeHeaderContainer extends StatefulWidget {
  const HomeHeaderContainer({super.key});

  @override
  State<HomeHeaderContainer> createState() => _HomeHeaderContainerState();
}

class _HomeHeaderContainerState extends State<HomeHeaderContainer> {
  int activeIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final List<String> images = [
    AppAssets.banner_1png,
    AppAssets.banner_2png,
    AppAssets.banner_3png,
    AppAssets.banner_4png,
    AppAssets.banner_5png,
  ];

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: images.length,
          options: CarouselOptions(
            height: rh(180),
            viewportFraction: 0.9,
            enlargeCenterPage: true,
            enlargeFactor: 0.25,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: (final index, final reason) {
              setState(() {
                activeIndex = index;
              });
            },
          ),
          itemBuilder: (final context, final index, final realIndex) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: rw(8)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(rr(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(rr(20)),
                child: Image.asset(images[index], fit: BoxFit.cover),
              ),
            );
          },
        ),
        verticalSpacing(12),
      ],
    );
  }
}
