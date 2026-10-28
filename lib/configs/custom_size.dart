import 'package:flutter/material.dart';

/// Screen and sizing helper functions
double screenSize(BuildContext context, double partialSize) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth * partialSize;
}

double screenHeight(BuildContext context, double partialSize) {
  final screenHeight = MediaQuery.of(context).size.height;
  return screenHeight * partialSize;
}

extension ResponsiveExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  bool get isTablet => MediaQuery.of(this).size.shortestSide >= 600;
}
