import 'package:flutter/material.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';
import 'package:pretty_animated_text_example/widgets/shadow_text.dart';
import '../core/constants.dart';

AnimationConfig _buildConfig(
  Type runtimeType,
  AnimationType type,
  Duration duration,
  void Function(AnimatedTextController)? onCreated,
) {
  return AnimationConfig(
    type: type,
    duration: duration,
    repeat: true,
    onPlay: (c) => debugPrint('$runtimeType animation played!'),
    onPause: (c) => debugPrint('$runtimeType animation paused!'),
    onComplete: (c) => debugPrint('$runtimeType animation completed!'),
    repeatCount: 3,
    reverse: true,
    onRepeat: (c, r) => debugPrint('$runtimeType animation repeated! $r times'),
    onDismissed: (c) => debugPrint('$runtimeType animation dismissed!'),
  );
}

class ChimeBellDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final TextAlign textAlign;
  final void Function(AnimatedTextController)? onControllerCreated;

  const ChimeBellDemo({
    super.key,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.textAlign = TextAlign.start,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text.rich(
      const TextSpan(
        text: "Estos son los servicios que más esperaste en el año con la",
        children: [
          TextSpan(
            text: " funcionalidad esperar bus",
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
      style: demoTextStyleOf(context).copyWith(color: Colors.black),
    );

    return ChimeBellText(
      text: text,
      textAlign: textAlign,
      config: _buildConfig(runtimeType, type, duration, onControllerCreated),
      onControllerCreated: onControllerCreated,
      textBuilder: (text, style) {
        return ShadowText(
          text: Text(text, style: style?.copyWith(fontSize: 48)),
          outlineColor: Colors.white,
          outlineWidth: 2,
          solidShadowColor: Colors.red,
          solidShadowOffset: const Offset(2, 2),
        );
      },
    );
  }
}

class SpringDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final TextAlign textAlign;
  final void Function(AnimatedTextController)? onControllerCreated;

  const SpringDemo({
    super.key,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.textAlign = TextAlign.start,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text.rich(
      const TextSpan(
        text: "243",
        children: [
          TextSpan(
            text: " KG de CO2",
            style: TextStyle(color: Colors.red, fontSize: 24),
          ),
        ],
      ),
      style:
          demoTextStyleOf(context).copyWith(color: Colors.black, fontSize: 64),
    );

    return SpringText(
      text: text,
      textAlign: textAlign,
      config: _buildConfig(runtimeType, type, duration, onControllerCreated),
      onControllerCreated: onControllerCreated,
    );
  }
}

class ScaleTextDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final TextAlign textAlign;
  final void Function(AnimatedTextController)? onControllerCreated;

  const ScaleTextDemo({
    super.key,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.textAlign = TextAlign.start,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) => ScaleText(
        text: Text(demoText, style: demoTextStyleOf(context)),
        textAlign: textAlign,
        config: _buildConfig(runtimeType, type, duration, onControllerCreated),
        onControllerCreated: onControllerCreated,
      );
}

class RotateTextDemo extends StatelessWidget {
  final AnimationType type;
  final RotateAnimationType direction;
  final Duration duration;
  final TextAlign textAlign;
  final void Function(AnimatedTextController)? onControllerCreated;

  const RotateTextDemo({
    super.key,
    this.direction = RotateAnimationType.clockwise,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.textAlign = TextAlign.start,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) => RotateText(
        text: Text(demoText, style: demoTextStyleOf(context)),
        textAlign: textAlign,
        direction: direction,
        config: _buildConfig(runtimeType, type, duration, onControllerCreated),
        onControllerCreated: onControllerCreated,
      );
}

class BlurTextDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final TextAlign textAlign;
  final void Function(AnimatedTextController)? onControllerCreated;

  const BlurTextDemo({
    super.key,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.textAlign = TextAlign.start,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) => BlurText(
        text: Text(demoText, style: demoTextStyleOf(context)),
        textAlign: textAlign,
        config: _buildConfig(runtimeType, type, duration, onControllerCreated),
        onControllerCreated: onControllerCreated,
      );
}

class RevealTextDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final TextAlign textAlign;
  final void Function(AnimatedTextController)? onControllerCreated;

  const RevealTextDemo({
    super.key,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.textAlign = TextAlign.start,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) => RevealText(
        text: Text(demoText, style: demoTextStyleOf(context)),
        textAlign: textAlign,
        config: _buildConfig(runtimeType, type, duration, onControllerCreated),
        onControllerCreated: onControllerCreated,
      );
}

class ScrambleTextDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final TextAlign textAlign;
  final void Function(AnimatedTextController)? onControllerCreated;

  const ScrambleTextDemo({
    super.key,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.textAlign = TextAlign.start,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) => ScrambleText(
        text: Text(demoText, style: demoTextStyleOf(context)),
        textAlign: textAlign,
        config: _buildConfig(runtimeType, type, duration, onControllerCreated),
        onControllerCreated: onControllerCreated,
      );
}

class SquashBounceDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final TextAlign textAlign;
  final void Function(AnimatedTextController)? onControllerCreated;

  const SquashBounceDemo({
    super.key,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.textAlign = TextAlign.start,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) {
    // Squash bounce reads better fast: shift each speed one notch quicker
    // (slow→old medium, medium→old fast, fast→a new faster) by halving.
    final fasterDuration = Duration(microseconds: duration.inMicroseconds ~/ 2);
    return SquashBounceText(
      text: Text(demoText, style: demoTextStyleOf(context)),
      textAlign: textAlign,
      config:
          _buildConfig(runtimeType, type, fasterDuration, onControllerCreated),
      onControllerCreated: onControllerCreated,
    );
  }
}

class GlitchTextDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final TextAlign textAlign;
  final void Function(AnimatedTextController)? onControllerCreated;

  const GlitchTextDemo({
    super.key,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.textAlign = TextAlign.start,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) => GlitchText(
        text: Text(demoText, style: demoTextStyleOf(context)),
        textAlign: textAlign,
        config: _buildConfig(runtimeType, type, duration, onControllerCreated),
        onControllerCreated: onControllerCreated,
      );
}

class GravityTextDemo extends StatelessWidget {
  final AnimationType type;
  final Duration duration;
  final TextAlign textAlign;
  final void Function(AnimatedTextController)? onControllerCreated;
  final bool enableInteraction;

  const GravityTextDemo({
    super.key,
    this.type = AnimationType.letter,
    this.duration = letterAnimationDuration,
    this.textAlign = TextAlign.start,
    this.onControllerCreated,
    this.enableInteraction = true,
  });

  @override
  Widget build(BuildContext context) => GravityText(
        text: demoText,
        style: demoTextStyleOf(context),
        textAlign: textAlign,
        // GravityText is a physics sim — it ignores repeat / reverse, so build a
        // config without them (see the asserts in GravityText).
        config: AnimationConfig(
          type: type,
          duration: duration,
          onPlay: (c) => debugPrint('$runtimeType animation played!'),
          onPause: (c) => debugPrint('$runtimeType animation paused!'),
          onComplete: (c) => debugPrint('$runtimeType animation completed!'),
          onDismissed: (c) => debugPrint('$runtimeType animation dismissed!'),
        ),
        onControllerCreated: onControllerCreated,
        enableInteraction: enableInteraction,
      );
}

class SlideTextDemo extends StatelessWidget {
  final AnimationType type;
  final SlideAnimationType slideType;
  final Duration duration;
  final TextAlign textAlign;
  final void Function(AnimatedTextController)? onControllerCreated;

  const SlideTextDemo({
    super.key,
    this.type = AnimationType.letter,
    this.slideType = SlideAnimationType.topBottom,
    this.duration = letterAnimationDuration,
    this.textAlign = TextAlign.start,
    this.onControllerCreated,
  });

  @override
  Widget build(BuildContext context) => SlideText(
        text: Text(demoText, style: demoTextStyleOf(context)),
        textAlign: textAlign,
        slideType: slideType,
        config: _buildConfig(runtimeType, type, duration, onControllerCreated),
        onControllerCreated: onControllerCreated,
      );
}
