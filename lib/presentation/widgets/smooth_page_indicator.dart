import 'package:flutter/material.dart';
import 'package:paganini/utils/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SmoothPageIndicatorWidget extends StatelessWidget {
  final PageController pageController;
  final int totalCounts;
  const SmoothPageIndicatorWidget({
    super.key,
    required this.pageController,
    required this.totalCounts,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: pageController,
      count: totalCounts,
      effect: const JumpingDotEffect(
        activeDotColor: AppColors.primaryColor,
        dotColor: AppColors.secondaryColor,
        dotHeight: 10,
        dotWidth: 10,
      ),
    );
  }
}
