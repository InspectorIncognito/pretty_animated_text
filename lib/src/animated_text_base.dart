import 'package:flutter/material.dart';
import 'package:pretty_animated_text/src/animation_config.dart';
import 'package:pretty_animated_text/src/utils/text_transformation.dart';
import 'package:pretty_animated_text/src/enums/animation_type.dart';
import 'package:pretty_animated_text/src/animated_text_controller.dart';
import 'package:pretty_animated_text/src/utils/interval_step_by_overlap_factor.dart';
import 'package:pretty_animated_text/src/utils/custom_curved_animation.dart';
import 'package:pretty_animated_text/src/utils/total_duration.dart';

/// Base widget for text animations that provides efficient animation handling.
///
/// This widget creates a Flutter [AnimationController] and attaches it to the
/// [AnimatedTextController]. The controller is the single source of truth
/// for all animation state and control logic.
class AnimatedTextBase extends StatefulWidget {
  /// The text to animate
  final Text text;

  /// The text alignment
  final TextAlign textAlign;

  /// The animation configuration
  final AnimationConfig config;

  /// The builder function that creates the animated text
  final Widget Function(
      BuildContext context,
      List<Animation<double>> animations,
      List<String> segments,
      List<TextStyle?> styles) builder;

  /// Optional external controller to control the animation.
  /// If not provided, an internal controller is created.
  final AnimatedTextController? controller;

  /// Callback when the controller is created/available.
  /// Fires in initState and whenever the callback reference changes.
  final void Function(AnimatedTextController)? onControllerCreated;

  /// Whether to call [builder] again on every animation tick.
  ///
  /// Defaults to `true`, so a builder that reads `animations[i].value`
  /// directly redraws every frame.
  ///
  /// Set it to `false` when the builder listens to the per-segment
  /// [Animation]s it is given (e.g. through an [AnimatedBuilder] per segment).
  /// The builder then runs once, and each tick only rebuilds the segments whose
  /// progress changed: segments that haven't started or have finished stay
  /// untouched. This is much cheaper for long text.
  final bool rebuildOnTick;

  const AnimatedTextBase({
    super.key,
    required this.text,
    this.textAlign = TextAlign.start,
    required this.config,
    required this.builder,
    this.controller,
    this.onControllerCreated,
    this.rebuildOnTick = true,
  });

  @override
  State<AnimatedTextBase> createState() => _AnimatedTextBaseState();
}

class _AnimatedTextBaseState extends State<AnimatedTextBase>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  List<_SegmentAnimation> _animations = const [];
  List<CurvedAnimation> _segmentCurves = const [];
  late List<String> _segments;
  late AnimatedTextController _textController;
  bool _ownsController = false;
  late List<TextStyle?> _styles;

  List<TextStyle?> _getStylesPerIndex(
      InlineSpan rootSpan, TextStyle? rootStyle) {
    final List<TextStyle?> styles = [];

    // Helper function to recursively traverse spans
    void traverse(InlineSpan span, TextStyle? inheritedStyle) {
      // Merge the parent style with the current span's style
      TextStyle? currentStyle = inheritedStyle;
      if (span is TextSpan) {
        currentStyle = inheritedStyle?.merge(span.style) ?? span.style;
      }

      if (span is TextSpan && span.text != null) {
        // Add the resolved style for every character in this span
        for (int i = 0; i < _splitSegments(span.text!).length; i++) {
          styles.add(currentStyle);
        }
      }

      // Recursively process children
      if (span is TextSpan && span.children != null) {
        for (final child in span.children!) {
          traverse(child, currentStyle);
        }
      }
    }

    // Start traversing from the root
    traverse(rootSpan, rootStyle);
    return styles;
  }

  String _getString() {
    if (widget.text.data != null) return widget.text.data!;
    return widget.text.textSpan!.toPlainText();
  }

  @override
  void initState() {
    super.initState();

    _segments = _splitSegments(_getString());
    if (widget.text.data != null) {
      _styles =
          List.generate(widget.text.data!.length, (index) => widget.text.style);
    } else {
      _styles = _getStylesPerIndex(widget.text.textSpan!, widget.text.style);
    }

    // Create the Flutter AnimationController
    final totalDuration = _totalDuration();
    _controller = AnimationController(
      vsync: this,
      duration: totalDuration,
      reverseDuration: totalDuration,
    )..addListener(_syncSegments);

    // Use external controller or create internal one
    if (widget.controller != null) {
      _textController = widget.controller!;
      _ownsController = false;
    } else {
      _textController = AnimatedTextController();
      _ownsController = true;
    }

    // Attach the Flutter AnimationController to the text controller
    _textController.attach(_controller, widget.config);

    // Notify parent about controller availability
    widget.onControllerCreated?.call(_textController);

    // Create overlapped animations for each segment
    _buildSegmentAnimations();

    // Start the initial animation
    _textController.startInitialAnimation();
  }

  /// Split text into segments based on animation type
  List<String> _splitSegments(String text) =>
      widget.config.type == AnimationType.letter
          ? text.splittedLetters.map((dto) => dto.text).toList()
          : text.splittedWords.map((dto) => dto.text).toList();

  /// Full timeline length: every segment's interval, overlapped.
  Duration _totalDuration() => Duration(
        milliseconds: getTotalDuration(
          wordCount: _segments.length,
          duration: widget.config.duration,
          overlapFactor: widget.config.overlapFactor,
        ),
      );

  void _disposeSegmentCurves() {
    for (final animation in _animations) {
      animation.dispose();
    }
    for (final curve in _segmentCurves) {
      curve.dispose();
    }
    _animations = const [];
    _segmentCurves = const [];
  }

  /// One controller tick: push the new progress to every segment. Only the
  /// segments whose value actually changed notify their listeners.
  void _syncSegments() {
    for (final animation in _animations) {
      animation.sync();
    }
  }

  void _buildSegmentAnimations() {
    // Each CurvedAnimation subscribes to the controller's status, so the
    // previous set must be disposed before it is replaced.
    _disposeSegmentCurves();

    final segmentCount = _segments.length;
    final intervalStep =
        intervalStepByOverlapFactor(segmentCount, widget.config.overlapFactor);

    _segmentCurves = List.generate(
      segmentCount,
      (index) => curvedAnimation(
        _controller,
        index,
        intervalStep,
        widget.config.overlapFactor,
        curve: Curves.easeInOut,
      ),
    );
    _animations = [
      for (final curve in _segmentCurves) _SegmentAnimation(curve),
    ];
  }

  @override
  void didUpdateWidget(AnimatedTextBase oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Re-notify controller when the callback changes (e.g., page becomes current)
    if (oldWidget.onControllerCreated != widget.onControllerCreated) {
      widget.onControllerCreated?.call(_textController);
    }

    // AnimationConfig equality ignores callbacks, so an "equal" config can
    // still carry new onComplete/onRepeat/... closures. Always hand the
    // controller the latest one.
    if (!identical(oldWidget.config, widget.config)) {
      _textController.updateConfig(widget.config);
    }

    if (oldWidget.config != widget.config || oldWidget.text != widget.text) {
      // Re-split: the text or the letter/word type may have changed.
      _segments = _splitSegments(_getString());

      // The controller spans the whole overlapped timeline, not one segment.
      final totalDuration = _totalDuration();
      _controller
        ..duration = totalDuration
        ..reverseDuration = totalDuration;

      // Recreate segment animations with new configuration
      _buildSegmentAnimations();

      // Restart the animation from the beginning; the old progress has no
      // meaning against the new segment intervals.
      _controller.reset();
      _textController.startInitialAnimation();
    }
  }

  @override
  void dispose() {
    // Detach the controller (makes it inert, safe for stale references)
    _textController.detach();

    // Dispose the segment curves, then the Flutter AnimationController
    _disposeSegmentCurves();
    _controller
      ..removeListener(_syncSegments)
      ..dispose();

    // Only dispose the text controller if we own it (created internally)
    if (_ownsController) {
      _textController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.rebuildOnTick) {
      return widget.builder(context, _animations, _segments, _styles);
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return widget.builder(context, _animations, _segments, _styles);
      },
    );
  }
}

/// A segment's progress that notifies listeners only when its value changes.
///
/// A plain [CurvedAnimation] notifies on every controller tick, even while its
/// [Interval] holds it at 0 (not started) or 1 (finished). Caching the value
/// lets those segments sit out the frame entirely.
class _SegmentAnimation extends Animation<double>
    with AnimationLocalListenersMixin, AnimationEagerListenerMixin {
  _SegmentAnimation(this._curve) : _value = _curve.value;

  final CurvedAnimation _curve;
  double _value;

  void sync() {
    final next = _curve.value;
    if (next == _value) return;
    _value = next;
    notifyListeners();
  }

  @override
  double get value => _value;

  @override
  AnimationStatus get status => _curve.status;

  @override
  void addStatusListener(AnimationStatusListener listener) =>
      _curve.addStatusListener(listener);

  @override
  void removeStatusListener(AnimationStatusListener listener) =>
      _curve.removeStatusListener(listener);

  @override
  void dispose() {
    clearListeners();
    super.dispose();
  }
}
