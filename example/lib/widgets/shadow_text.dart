import 'package:flutter/material.dart';

class ShadowText extends StatelessWidget {
  const ShadowText({
    super.key,
    required this.text,
    required this.outlineColor,
    required this.outlineWidth,
    this.solidShadowColor,
    this.solidShadowOffset,
  });

  final Text text;
  final Color outlineColor;
  final double outlineWidth;
  final Color? solidShadowColor;
  final Offset? solidShadowOffset;

  @override
  Widget build(BuildContext context) {
    final textStyle = text.style!.copyWith(
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = outlineWidth * 2
        ..color = outlineColor,
    );
    final hasShadow = solidShadowColor != null && solidShadowOffset != null;
    final shadowStrokeTextStyle = !hasShadow
        ? null
        : text.style!.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = outlineWidth * 2
              ..color = solidShadowColor!,
          );
    final shadowFillTextStyle = !hasShadow
        ? null
        : text.style!.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.fill
              ..strokeWidth = outlineWidth * 2
              ..color = solidShadowColor!,
          );
    return Stack(
      fit: StackFit.passthrough,
      clipBehavior: Clip.none,
      children: [
        if (solidShadowColor != null && solidShadowOffset != null) ...[
          Positioned(
            left: solidShadowOffset?.dx,
            top: solidShadowOffset?.dy,
            child: Text(
              text.data!,
              style: shadowStrokeTextStyle,
              maxLines: text.maxLines,
              overflow: text.overflow,
              semanticsLabel: text.semanticsLabel,
              softWrap: text.softWrap,
              strutStyle: text.strutStyle,
              textAlign: text.textAlign,
              textDirection: text.textDirection,
            ),
          ),
          Positioned(
            left: solidShadowOffset?.dx,
            top: solidShadowOffset?.dy,
            child: Text(
              text.data!,
              style: shadowFillTextStyle,
              maxLines: text.maxLines,
              overflow: text.overflow,
              semanticsLabel: text.semanticsLabel,
              softWrap: text.softWrap,
              strutStyle: text.strutStyle,
              textAlign: text.textAlign,
              textDirection: text.textDirection,
            ),
          ),
        ],
        Text(
          text.data!,
          style: textStyle,
          maxLines: text.maxLines,
          overflow: text.overflow,
          semanticsLabel: text.semanticsLabel,
          softWrap: text.softWrap,
          strutStyle: text.strutStyle,
          textAlign: text.textAlign,
          textDirection: text.textDirection,
        ),
        text,
      ],
    );
  }
}
