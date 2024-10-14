import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SmoothPageIndicatorWidget extends StatelessWidget {
  final PageController pageController;
  final int totalCounts;
  final IndicatorEffect smoothPageEffect;
  const SmoothPageIndicatorWidget({
    super.key,
    required this.pageController,
    required this.totalCounts,
    required this.smoothPageEffect,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: pageController,
      count: totalCounts,
      effect: smoothPageEffect,
    );
  }
}
