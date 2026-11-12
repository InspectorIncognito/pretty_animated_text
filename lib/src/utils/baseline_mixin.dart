import 'dart:math';

import 'package:flutter/material.dart';

mixin BaselineMixin {
  double getLargestBaseline(
    List<TextStyle?> styles, {
    TextBaseline baselineType = TextBaseline.alphabetic,
    TextScaler textScaler = TextScaler.noScaling,
  }) {
    if (styles.isEmpty) return 0.0;

    return styles.nonNulls.fold<double>(0.0, (maxBaseline, style) {
      final textPainter = TextPainter(
        text: TextSpan(
            text: ' ',
            style:
                style), // A single space or character triggers font metric calculation
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
      )..layout();

      final baseline =
          textPainter.computeDistanceToActualBaseline(baselineType);
      textPainter.dispose();

      return max(maxBaseline, baseline);
    });
  }
}
