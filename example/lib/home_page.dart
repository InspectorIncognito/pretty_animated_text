import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_animated_text/pretty_animated_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/constants.dart';
import 'demos/demo_wrappers.dart';
import 'models/animation_demo_item.dart';
import 'widgets/ds_button.dart';
import 'widgets/ds_nav_item.dart';
import 'widgets/ds_segmented.dart';
import 'widgets/ds_status_pill.dart';
import 'widgets/ds_tabs.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  AnimatedTextController? _currentController;
  final ValueNotifier<AnimatedTextController?> _controllerNotifier =
      ValueNotifier(null);

  bool _isWordMode = false;
  int _currentPage = 0;
  int _tab = 0; // 0 = Preview, 1 = Code
  TextAlign _textAlign = TextAlign.start;
  int _speedIndex = 1; // 0=slow, 1=medium, 2=fast
  bool _interactionEnabled = true; // Gravity demo: tap/drag interaction

  Duration get _letterDuration => letterDurations[_speedIndex];
  Duration get _wordDuration => wordDurations[_speedIndex];

  late final List<int> _variationIndices;
  late final List<AnimationDemoItem> _demos;

  static const _slideVariations = [
    VariationOption<SlideAnimationType>(
        icon: Icons.arrow_forward, value: SlideAnimationType.leftRight),
    VariationOption<SlideAnimationType>(
        icon: Icons.arrow_back, value: SlideAnimationType.rightLeft),
    VariationOption<SlideAnimationType>(
        icon: Icons.arrow_downward, value: SlideAnimationType.topBottom),
    VariationOption<SlideAnimationType>(
        icon: Icons.arrow_upward, value: SlideAnimationType.bottomTop),
    VariationOption<SlideAnimationType>(
        icon: Icons.swap_vert, value: SlideAnimationType.alternateTB),
    VariationOption<SlideAnimationType>(
        icon: Icons.swap_horiz, value: SlideAnimationType.alternateLR),
  ];

  static const _rotateVariations = [
    VariationOption<RotateAnimationType>(
        label: 'Clockwise',
        icon: Icons.rotate_right,
        value: RotateAnimationType.clockwise),
    VariationOption<RotateAnimationType>(
        label: 'Anti-clockwise',
        icon: Icons.rotate_left,
        value: RotateAnimationType.anticlockwise),
  ];

  // Sidebar presentation order (independent of the _demos index used for the
  // content). A version chip + dashed divider is inserted above the title that
  // starts each version group.
  static const _orderedTitles = <String>[
    'Glitch',
    'Squash Bounce',
    'Gravity',
    'Scramble',
    'Spring',
    'Reveal',
    'Scale',
    'Slide',
    'Rotate',
    'Chime Bell',
    'Blur',
  ];
  static const _versionHeaders = <String, String>{
    'Glitch': 'v3.2.0',
    'Gravity': 'v3.1.0',
  };

  int _indexOf(String title) => _demos.indexWhere((d) => d.title == title);

  @override
  void initState() {
    super.initState();
    _demos = [
      AnimationDemoItem(
        title: 'Gravity',
        buildLetter: (onCreated, _, ta, dur) => GravityTextDemo(
            duration: dur,
            textAlign: ta,
            onControllerCreated: onCreated,
            enableInteraction: _interactionEnabled),
        buildWord: (onCreated, _, ta, dur) => GravityTextDemo(
            type: AnimationType.word,
            duration: dur,
            textAlign: ta,
            onControllerCreated: onCreated,
            enableInteraction: _interactionEnabled),
      ),
      AnimationDemoItem(
        title: 'Glitch',
        buildLetter: (onCreated, _, ta, dur) => GlitchTextDemo(
            duration: dur, textAlign: ta, onControllerCreated: onCreated),
        buildWord: (onCreated, _, ta, dur) => GlitchTextDemo(
            type: AnimationType.word,
            duration: dur,
            textAlign: ta,
            onControllerCreated: onCreated),
      ),
      AnimationDemoItem(
        title: 'Squash Bounce',
        buildLetter: (onCreated, _, ta, dur) => SquashBounceDemo(
            duration: dur, textAlign: ta, onControllerCreated: onCreated),
        buildWord: (onCreated, _, ta, dur) => SquashBounceDemo(
            type: AnimationType.word,
            duration: dur,
            textAlign: ta,
            onControllerCreated: onCreated),
      ),
      AnimationDemoItem(
        title: 'Scramble',
        buildLetter: (onCreated, _, ta, dur) => ScrambleTextDemo(
            duration: dur, textAlign: ta, onControllerCreated: onCreated),
        buildWord: (onCreated, _, ta, dur) => ScrambleTextDemo(
            type: AnimationType.word,
            duration: dur,
            textAlign: ta,
            onControllerCreated: onCreated),
      ),
      AnimationDemoItem(
        title: 'Spring',
        buildLetter: (onCreated, _, ta, dur) => SpringDemo(
            duration: dur, textAlign: ta, onControllerCreated: onCreated),
        buildWord: (onCreated, _, ta, dur) => SpringDemo(
            type: AnimationType.word,
            duration: dur,
            textAlign: ta,
            onControllerCreated: onCreated),
      ),
      AnimationDemoItem(
        title: 'Reveal',
        buildLetter: (onCreated, _, ta, dur) => RevealTextDemo(
            duration: dur, textAlign: ta, onControllerCreated: onCreated),
        buildWord: (onCreated, _, ta, dur) => RevealTextDemo(
            type: AnimationType.word,
            duration: dur,
            textAlign: ta,
            onControllerCreated: onCreated),
      ),
      AnimationDemoItem(
        title: 'Scale',
        buildLetter: (onCreated, _, ta, dur) => ScaleTextDemo(
            duration: dur, textAlign: ta, onControllerCreated: onCreated),
        buildWord: (onCreated, _, ta, dur) => ScaleTextDemo(
            type: AnimationType.word,
            duration: dur,
            textAlign: ta,
            onControllerCreated: onCreated),
      ),
      AnimationDemoItem(
        title: 'Slide',
        variations: _slideVariations,
        buildLetter: (onCreated, vi, ta, dur) => SlideTextDemo(
            duration: dur,
            slideType: _slideVariations[vi].value,
            textAlign: ta,
            onControllerCreated: onCreated),
        buildWord: (onCreated, vi, ta, dur) => SlideTextDemo(
            type: AnimationType.word,
            duration: dur,
            slideType: _slideVariations[vi].value,
            textAlign: ta,
            onControllerCreated: onCreated),
      ),
      AnimationDemoItem(
        title: 'Rotate',
        variations: _rotateVariations,
        buildLetter: (onCreated, vi, ta, dur) => RotateTextDemo(
            duration: dur,
            direction: _rotateVariations[vi].value,
            textAlign: ta,
            onControllerCreated: onCreated),
        buildWord: (onCreated, vi, ta, dur) => RotateTextDemo(
            type: AnimationType.word,
            duration: dur,
            direction: _rotateVariations[vi].value,
            textAlign: ta,
            onControllerCreated: onCreated),
      ),
      AnimationDemoItem(
        title: 'Chime Bell',
        buildLetter: (onCreated, _, ta, dur) => ChimeBellDemo(
            duration: dur, textAlign: ta, onControllerCreated: onCreated),
        buildWord: (onCreated, _, ta, dur) => ChimeBellDemo(
            type: AnimationType.word,
            duration: dur,
            textAlign: ta,
            onControllerCreated: onCreated),
      ),
      AnimationDemoItem(
        title: 'Blur',
        buildLetter: (onCreated, _, ta, dur) => BlurTextDemo(
            duration: dur, textAlign: ta, onControllerCreated: onCreated),
        buildWord: (onCreated, _, ta, dur) => BlurTextDemo(
            type: AnimationType.word,
            duration: dur,
            textAlign: ta,
            onControllerCreated: onCreated),
      ),
    ];
    _variationIndices = List.filled(_demos.length, 0);
  }

  @override
  void dispose() {
    _controllerNotifier.dispose();
    super.dispose();
  }

  AnimationDemoItem get _currentDemo => _demos[_currentPage];

  // ── Controls ───────────────────────────────────────────────────────────
  void _handlePlay() {
    final c = _currentController;
    if (c == null || c.isAnimating) return;
    if (c.isPaused || c.isRepeating) {
      c.resume();
    } else {
      c.play();
    }
  }

  void _handlePlayPause() {
    final c = _currentController;
    if (c == null) return;
    c.isAnimating ? c.pause() : _handlePlay();
  }

  void _handleRepeat() => _currentController?.repeat();

  void _selectEffect(int index) {
    if (_currentPage == index) return;
    setState(() => _currentPage = index);
  }

  // ── Usage snippet + copy ───────────────────────────────────────────────
  Future<void> _copyUsage() async {
    await Clipboard.setData(ClipboardData(text: _usageSnippet(_currentDemo)));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          duration: const Duration(seconds: 2),
          content: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: dsSurface,
                borderRadius: BorderRadius.circular(r10),
                border: Border.all(color: dsBorder),
                boxShadow: dsOverlayShadow,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: dsAccent, size: 16),
                  const SizedBox(width: 8),
                  Text('${_currentDemo.title} usage copied', style: dsLabel()),
                ],
              ),
            ),
          ),
        ),
      );
  }

  String _usageSnippet(AnimationDemoItem demo) {
    final type = _isWordMode ? 'AnimationType.word' : 'AnimationType.letter';
    final ms = (_isWordMode ? _wordDuration : _letterDuration).inMilliseconds;
    final align = 'TextAlign.${_textAlign.name}';
    final vi = _variationIndices[_currentPage];

    String widgetName;
    final ctorArgs = <String>[];
    switch (demo.title) {
      case 'Squash Bounce':
        widgetName = 'SquashBounceText';
        break;
      case 'Chime Bell':
        widgetName = 'ChimeBellText';
        break;
      case 'Slide':
        widgetName = 'SlideText';
        ctorArgs.add('slideType: ${_slideVariations[vi].value}');
        break;
      case 'Rotate':
        widgetName = 'RotateText';
        ctorArgs.add('direction: ${_rotateVariations[vi].value}');
        break;
      default:
        widgetName = '${demo.title}Text';
    }

    final b = StringBuffer()
      ..writeln('$widgetName(')
      ..writeln("  text: '$demoText',")
      ..writeln(
          '  style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w900),')
      ..writeln('  textAlign: $align,');
    for (final arg in ctorArgs) {
      b.writeln('  $arg,');
    }
    b
      ..writeln('  config: AnimationConfig(')
      ..writeln('    duration: const Duration(milliseconds: $ms),')
      ..writeln('    type: $type,');
    if (demo.title != 'Gravity') {
      b.writeln('    repeat: true,');
    }
    b
      ..writeln('  ),')
      ..write(')');
    return b.toString();
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;

    return Scaffold(
      backgroundColor: dsSurface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Padding(
              padding: EdgeInsets.all(isWide ? 40 : 16),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: dsSurface,
                  border: Border.all(color: dsBorder),
                  borderRadius: BorderRadius.circular(r12),
                ),
                child: isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(width: 232, child: _sidebar()),
                          Expanded(child: _contentColumn(isWide)),
                        ],
                      )
                    : Column(
                        children: [
                          _mobileNav(),
                          Expanded(child: _contentColumn(isWide)),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Sidebar (wide) ─────────────────────────────────────────────────────
  Widget _sidebar() {
    return Container(
      decoration: const BoxDecoration(
        color: dsSubtle,
        border: Border(right: BorderSide(color: dsBorder)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Image.asset('assets/logo.png', width: 48, height: 48),
                const SizedBox(width: 9),
                Expanded(
                  child: Text('Pretty Animated Text',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: dsText(size: 13, weight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('EFFECTS', style: dsEyebrow()),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 4),
              children: [
                for (final title in _orderedTitles) ...[
                  if (_versionHeaders[title] != null)
                    _versionHeader(_versionHeaders[title]!),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: DsNavItem(
                      label: title,
                      icon: kDemoIcons[title],
                      isActive: _currentPage == _indexOf(title),
                      onTap: () => _selectEffect(_indexOf(title)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          _linksCard(),
        ],
      ),
    );
  }

  Widget _linksCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      decoration: BoxDecoration(
        color: dsSurface,
        border: Border.all(color: dsBorder),
        borderRadius: BorderRadius.circular(r8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text('pretty_animated_text',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: dsText(size: 12, weight: FontWeight.w500)),
          ),
          _imageLink(
              asset: 'assets/pub.png',
              url: 'https://pub.dev/packages/pretty_animated_text',
              tooltip: 'pub.dev'),
          _imageLink(
              asset: 'assets/github.png',
              url: 'https://github.com/YeLwinOo-Steve/pretty_animated_text',
              tooltip: 'GitHub',
              tint: true),
        ],
      ),
    );
  }

  Widget _imageLink({
    required String asset,
    required String url,
    required String tooltip,
    bool tint = false,
  }) {
    Widget img = Image.asset(asset, width: 18, height: 18);
    if (tint) {
      img = ColorFiltered(
        colorFilter: const ColorFilter.mode(dsText2, BlendMode.srcIn),
        child: img,
      );
    }
    return Tooltip(
      message: tooltip,
      child: _HoverBox(
        builder: (hovered) => GestureDetector(
          onTap: () => _launch(url),
          child: Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: hovered ? dsFill : Colors.transparent,
              borderRadius: BorderRadius.circular(r6),
            ),
            child: img,
          ),
        ),
      ),
    );
  }

  Widget _versionHeader(String version) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 10, 2, 8),
      child: Row(
        children: [
          _versionChip(version),
          const SizedBox(width: 8),
          const Expanded(child: _DashedLine()),
        ],
      ),
    );
  }

  Widget _versionChip(String version) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: dsBorder),
        borderRadius: BorderRadius.circular(rPill),
      ),
      child: Text(version,
          style: dsText(size: 12, weight: FontWeight.w500, color: dsMuted)),
    );
  }

  // ── Mobile top nav (narrow) ────────────────────────────────────────────
  Widget _mobileNav() {
    // Same order + version markers as the sidebar, flattened for a horizontal
    // rail (version chips render inline before each group).
    final entries = <({String? version, String? title})>[
      for (final title in _orderedTitles) ...[
        if (_versionHeaders[title] != null)
          (version: _versionHeaders[title], title: null),
        (version: null, title: title),
      ],
    ];

    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: dsSubtle,
        border: Border(bottom: BorderSide(color: dsBorder)),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final entry = entries[i];
          if (entry.version != null) {
            return Center(child: _versionChip(entry.version!));
          }
          final title = entry.title!;
          final index = _indexOf(title);
          final active = _currentPage == index;
          return _HoverBox(
            builder: (hovered) => GestureDetector(
              onTap: () => _selectEffect(index),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: active ? dsInk : (hovered ? dsHover : dsSurface),
                  border: Border.all(color: active ? dsInk : dsBorder),
                  borderRadius: BorderRadius.circular(rPill),
                ),
                child: Row(
                  children: [
                    Icon(kDemoIcons[title],
                        size: 14, color: active ? dsSurface : dsText2),
                    const SizedBox(width: 7),
                    Text(title,
                        style: dsText(
                            size: 13,
                            weight: FontWeight.w500,
                            color: active ? dsSurface : dsText2)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Content column ─────────────────────────────────────────────────────
  Widget _contentColumn(bool isWide) {
    return Column(
      children: [
        _topbar(isWide),
        DsTabs(
          tabs: const ['Preview', 'Code'],
          selectedIndex: _tab,
          onChanged: (i) => setState(() => _tab = i),
        ),
        Expanded(
          child: _tab == 0 ? _previewTab() : _codeTab(),
        ),
      ],
    );
  }

  Widget _topbar(bool isWide) {
    final sep = dsText(size: 13, color: dsPlaceholder);
    final crumb = dsText(size: 13, color: dsMuted);

    // Single ellipsizing rich text — leading crumbs collapse gracefully as the
    // topbar narrows instead of overflowing the row.
    final breadcrumb = Text.rich(
      TextSpan(
        children: [
          if (isWide) ...[
            TextSpan(text: 'pretty_animated_text', style: crumb),
            TextSpan(text: '   /   ', style: sep),
            TextSpan(text: 'Effects', style: crumb),
            TextSpan(text: '   /   ', style: sep),
          ],
          TextSpan(text: _currentDemo.title, style: dsLabel()),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: dsBorder)),
      ),
      child: Row(
        children: [
          Expanded(child: breadcrumb),
          const SizedBox(width: 12),
          _controllerActions(isWide),
        ],
      ),
    );
  }

  Widget _controllerActions(bool isWide) {
    return ValueListenableBuilder<AnimatedTextController?>(
      valueListenable: _controllerNotifier,
      builder: (context, controller, _) {
        return ListenableBuilder(
          listenable: controller ?? ChangeNotifier(),
          builder: (context, _) {
            final playing = controller?.isAnimating ?? false;
            final (kind, label) = _statusOf(controller);
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isWide) ...[
                  DsStatusPill(kind: kind, label: label),
                  const SizedBox(width: 8),
                ],
                DsIconButton(
                  icon: Icons.refresh_rounded,
                  variant: DsIconVariant.ghost,
                  size: 30,
                  radius: r7,
                  iconSize: 15,
                  tooltip: 'Repeat',
                  onPressed: _handleRepeat,
                ),
                const SizedBox(width: 8),
                if (isWide)
                  DsButton(
                    label: 'Copy',
                    icon: Icons.copy_rounded,
                    variant: DsButtonVariant.secondary,
                    size: DsButtonSize.sm,
                    onPressed: _copyUsage,
                  )
                else
                  DsIconButton(
                    icon: Icons.copy_rounded,
                    variant: DsIconVariant.outline,
                    size: 30,
                    radius: r7,
                    iconSize: 15,
                    tooltip: 'Copy usage',
                    onPressed: _copyUsage,
                  ),
                const SizedBox(width: 8),
                DsButton(
                  label: playing ? 'Pause' : 'Play',
                  icon:
                      playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  variant: DsButtonVariant.primary,
                  size: DsButtonSize.sm,
                  onPressed: _handlePlayPause,
                ),
              ],
            );
          },
        );
      },
    );
  }

  (DsStatusKind, String) _statusOf(AnimatedTextController? c) {
    if (c == null) return (DsStatusKind.stopped, 'Stopped');
    if (c.isAnimating) {
      return (
        DsStatusKind.playing,
        c.repeatCount > 0 ? 'Repeat ${c.repeatCount}' : 'Playing'
      );
    }
    if (c.isPaused) return (DsStatusKind.paused, 'Paused');
    if (c.isCompleted) return (DsStatusKind.completed, 'Completed');
    return (DsStatusKind.stopped, 'Stopped');
  }

  // ── Preview tab ────────────────────────────────────────────────────────
  Widget _previewTab() {
    final meta = kEffectMeta[_currentDemo.title];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _controlsRow(),
          const SizedBox(height: 16),
          if (meta != null) ...[
            Row(
              children: [
                _squareLabel(meta.tag),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(meta.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: dsCaption()),
                ),
              ],
            ),
            const SizedBox(height: 14),
          ],
          Expanded(child: _canvas()),
        ],
      ),
    );
  }

  Widget _controlsRow() {
    final demo = _currentDemo;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        DsSegmented(
          items: const [
            DsSegmentItem(label: 'Letters', tooltip: 'Animate letters'),
            DsSegmentItem(label: 'Words', tooltip: 'Animate words'),
          ],
          selectedIndex: _isWordMode ? 1 : 0,
          onChanged: (i) => setState(() => _isWordMode = i == 1),
        ),
        DsSegmented(
          items: const [
            DsSegmentItem(label: 'Slow', tooltip: 'Slow'),
            DsSegmentItem(label: 'Medium', tooltip: 'Medium'),
            DsSegmentItem(label: 'Fast', tooltip: 'Fast'),
          ],
          selectedIndex: _speedIndex,
          onChanged: (i) => setState(() => _speedIndex = i),
        ),
        DsSegmented(
          items: const [
            DsSegmentItem(icon: Icons.format_align_left, tooltip: 'Start'),
            DsSegmentItem(icon: Icons.format_align_center, tooltip: 'Center'),
            DsSegmentItem(icon: Icons.format_align_right, tooltip: 'End'),
          ],
          selectedIndex: _alignIndex,
          onChanged: (i) => setState(() => _textAlign = _alignFromIndex(i)),
        ),
        if (demo.hasVariations)
          DsSegmented(
            items: [
              for (final v in demo.variations)
                DsSegmentItem(icon: v.icon, label: v.label, tooltip: v.label),
            ],
            selectedIndex: _variationIndices[_currentPage],
            onChanged: (i) =>
                setState(() => _variationIndices[_currentPage] = i),
          ),
        if (demo.title == 'Gravity')
          DsSegmented(
            items: const [
              DsSegmentItem(label: 'Interact', tooltip: 'Tap / drag letters'),
              DsSegmentItem(label: 'Static', tooltip: 'Disable interaction'),
            ],
            selectedIndex: _interactionEnabled ? 0 : 1,
            onChanged: (i) => setState(() => _interactionEnabled = i == 0),
          ),
      ],
    );
  }

  int get _alignIndex => switch (_textAlign) {
        TextAlign.center => 1,
        TextAlign.end => 2,
        _ => 0,
      };

  TextAlign _alignFromIndex(int i) => switch (i) {
        1 => TextAlign.center,
        2 => TextAlign.end,
        _ => TextAlign.start,
      };

  Widget _squareLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: dsFill,
        borderRadius: BorderRadius.circular(r6),
      ),
      child: Text(text, style: dsSmall(color: dsInk)),
    );
  }

  Widget _canvas() {
    final demo = _currentDemo;
    final vi = _variationIndices[_currentPage];

    void onControllerCreated(AnimatedTextController c) {
      if (_currentController != c) {
        _currentController = c;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _controllerNotifier.value = c;
        });
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: dsSurface,
        border: Border.all(color: dsBorder),
        borderRadius: BorderRadius.circular(r10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: KeyedSubtree(
            key: ValueKey(
                '${demo.title}_${_isWordMode}_${vi}_$_textAlign _$_speedIndex'),
            child: _isWordMode
                ? demo.buildWord(
                    onControllerCreated, vi, _textAlign, _wordDuration)
                : demo.buildLetter(
                    onControllerCreated, vi, _textAlign, _letterDuration),
          ),
        ),
      ),
    );
  }

  // ── Code tab ───────────────────────────────────────────────────────────
  Widget _codeTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Usage', style: dsHeading()),
              const Spacer(),
              DsButton(
                label: 'Copy',
                icon: Icons.copy_rounded,
                variant: DsButtonVariant.secondary,
                size: DsButtonSize.sm,
                onPressed: _copyUsage,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: dsSubtle,
                border: Border.all(color: dsBorder),
                borderRadius: BorderRadius.circular(r10),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  _usageSnippet(_currentDemo),
                  style: dsMono(size: 12.5, color: dsText2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A 1px horizontal dashed line in the border color.
class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: CustomPaint(painter: _DashedLinePainter()),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dash = 4.0, gap = 3.0;
    final paint = Paint()
      ..color = dsBorderHover
      ..strokeWidth = 1.4;
    final y = size.height / 2;
    for (double x = 0; x < size.width; x += dash + gap) {
      canvas.drawLine(Offset(x, y), Offset(x + dash, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Tiny helper to track hover state for a builder without a bespoke widget.
class _HoverBox extends StatefulWidget {
  final Widget Function(bool hovered) builder;
  const _HoverBox({required this.builder});

  @override
  State<_HoverBox> createState() => _HoverBoxState();
}

class _HoverBoxState extends State<_HoverBox> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: widget.builder(_hovered),
    );
  }
}
