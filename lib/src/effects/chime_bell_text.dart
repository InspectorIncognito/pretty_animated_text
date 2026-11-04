import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';

/// A widget that animates text with a chime bell effect
class ChimeBellText extends StatelessWidget {
  /// The text to animate
  final String text;

  /// The style to apply to the text
  final TextStyle? style;

  /// The text alignment
  final TextAlign textAlign;

  /// The animation configuration
  final AnimationConfig config;

  /// On controller created
  final void Function(AnimatedTextController)? onControllerCreated;

  const ChimeBellText({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
    required this.config,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTextBase(
      text: text,
      style: style,
      textAlign: textAlign,
      config: config,
      onControllerCreated: onControllerCreated,
      // Each segment listens to its own animation, so only moving
      // glyphs rebuild.
      rebuildOnTick: false,
      builder: (context, animations, segments) {
        List<Widget> children = List.generate(segments.length, (index) {
          final rotateAnimation = Tween<double>(begin: 180, end: 0).animate(
            animations[index].drive(CurveTween(curve: config.curve)),
          );

          return AnimatedBuilder(
            animation: rotateAnimation,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.015) // Adds perspective effect
                  ..rotateX(rotateAnimation.value *
                      pi /
                      360), // 3D rotation around X axis
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: animations[index].value.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: ParagraphText(
              segments[index],
              style: style,
            ),
          );
        });

        if (config.type == AnimationType.letter) {
          // Wrap each 'word' in a wrap, this prevents the word from being split
          // in between lines
          List<Widget> wrappedList = [];
          List<Widget> currentList = [];
          for (var (index, value) in children.indexed) {
            if (segments[index] == ' ') {
              wrappedList.add(Wrap(
                children: currentList..add(value),
              ));
              currentList = [];
            } else {
              currentList.add(value);
            }
          }
          if (currentList.isNotEmpty) {
            wrappedList.add(Wrap(children: currentList));
          }
          children = wrappedList;
        }

        return Wrap(
          alignment: textAlign == TextAlign.center
              ? WrapAlignment.center
              : textAlign == TextAlign.end
                  ? WrapAlignment.end
                  : WrapAlignment.start,
          children: children,
        );
      },
    );
  }
}
