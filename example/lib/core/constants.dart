import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Flatline UI — a flat, light, near-monochrome design system.
// Figtree (UI) + JetBrains Mono (code/ids), hairline borders, one indigo accent.
// ═══════════════════════════════════════════════════════════════════════════

// ── Demo content ───────────────────────────────────────────────────────────
const demoText = 'Bring motion to your text. Keep your UI elegant!';

/// The large animated showcase text keeps Comic Neue (it is the content being
/// animated, not UI chrome).
final demoTextStyle = GoogleFonts.comicNeue(
  fontSize: 52,
  fontWeight: FontWeight.w900,
  color: dsInk,
  height: 1.2,
  letterSpacing: -0.5,
);

/// Kept for call-site compatibility; the animated text color is theme-invariant
/// now (light only).
TextStyle demoTextStyleOf(BuildContext context) => demoTextStyle;

// Letter animation durations (slow / medium / fast)
const letterDurationSlow = Duration(milliseconds: 600);
const letterDurationMedium = Duration(milliseconds: 300);
const letterDurationFast = Duration(milliseconds: 150);

// Word animation durations (slow / medium / fast)
const wordDurationSlow = Duration(milliseconds: 1200);
const wordDurationMedium = Duration(milliseconds: 600);
const wordDurationFast = Duration(milliseconds: 300);

const letterDurations = [
  letterDurationSlow,
  letterDurationMedium,
  letterDurationFast
];
const wordDurations = [wordDurationSlow, wordDurationMedium, wordDurationFast];

const letterAnimationDuration = letterDurationMedium;
const wordAnimationDuration = wordDurationMedium;

// ── Color tokens ───────────────────────────────────────────────────────────
// Surfaces
const dsSurface = Color(0xFFFFFFFF);
const dsSubtle = Color(0xFFF7F8F8);
const dsFill = Color(0xFFF1F2F3);
const dsFillHover = Color(0xFFE6E7E9);
const dsHover = Color(0xFFEDEEEF);

// Borders
const dsBorder = Color(0xFFE6E7E9);
const dsBorderStrong = Color(0xFFD6D8DB);
const dsBorderHover = Color(0xFFC2C5CA);
const dsBorderFaint = Color(0xFFF1F2F3);

// Ink / text
const dsInk = Color(0xFF08090A);
const dsInkHover = Color(0xFF26282B);
const dsText2 = Color(0xFF6C6F75);
const dsMuted = Color(0xFF8A8F98);
const dsDisabled = Color(0xFFA9ADB4);
const dsPlaceholder = Color(0xFFC2C5CA);

// Accent (single indigo)
const dsAccent = Color(0xFF5E5CE6);
const dsAccentHover = Color(0xFF4F4DDB);
const dsAccentText = Color(0xFF4F4DDB);
const dsAccentBg = Color(0xFFF3F3FE);
const dsAccentBorder = Color(0xFFDEDEFB);

// Danger
const dsDanger = Color(0xFFC1352C);
const dsDangerBg = Color(0xFFFDF4F3);
const dsDangerBorder = Color(0xFFF0D4D1);
const dsDangerBorderHover = Color(0xFFE4B8B3);

// Focus ring — rgba(94,92,230,.28)
const dsFocus = Color(0x475E5CE6);

/// The only shadow in the system — reserved for floating overlays.
const dsOverlayShadow = [
  BoxShadow(color: Color(0x14080909), blurRadius: 28, offset: Offset(0, 8)),
];

// ── Radius & spacing scale ─────────────────────────────────────────────────
const double r5 = 5;
const double r6 = 6;
const double r7 = 7;
const double r8 = 8;
const double r10 = 10;
const double r12 = 12;
const double rPill = 999;

const double s4 = 4;
const double s8 = 8;
const double s12 = 12;
const double s16 = 16;
const double s20 = 20;
const double s24 = 24;
const double s40 = 40;

// ── Typography (Figtree UI · JetBrains Mono code) ──────────────────────────
TextStyle dsText({
  required double size,
  FontWeight weight = FontWeight.w400,
  Color color = dsInk,
  double? letterSpacing,
  double? height,
}) =>
    GoogleFonts.figtree(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );

// Named styles (letterSpacing converted from em → logical px at each size).
TextStyle dsH1({Color color = dsInk}) => dsText(
    size: 44,
    weight: FontWeight.w600,
    color: color,
    letterSpacing: -1.4,
    height: 1.08);
TextStyle dsDisplay({Color color = dsInk}) => dsText(
    size: 32, weight: FontWeight.w600, color: color, letterSpacing: -0.9);
TextStyle dsH2({Color color = dsInk}) => dsText(
    size: 24, weight: FontWeight.w600, color: color, letterSpacing: -0.48);
TextStyle dsHeading({Color color = dsInk}) => dsText(
    size: 20, weight: FontWeight.w600, color: color, letterSpacing: -0.36);
TextStyle dsBody({Color color = dsInk}) =>
    dsText(size: 15, color: color, height: 1.5);
TextStyle dsCaption({Color color = dsText2}) => dsText(size: 13, color: color);
TextStyle dsLabel({Color color = dsInk}) =>
    dsText(size: 13, weight: FontWeight.w500, color: color);
TextStyle dsSmall(
        {Color color = dsText2, FontWeight weight = FontWeight.w500}) =>
    dsText(size: 12, weight: weight, color: color);
TextStyle dsEyebrow({Color color = dsMuted}) => dsText(
    size: 11, weight: FontWeight.w600, color: color, letterSpacing: 0.88);

TextStyle dsMono(
        {double size = 11,
        Color color = dsText2,
        FontWeight weight = FontWeight.w400}) =>
    GoogleFonts.jetBrainsMono(fontSize: size, color: color, fontWeight: weight);

// ── Semantic status (for the status pill) ──────────────────────────────────
enum DsStatusKind { stopped, playing, completed, paused }

typedef DsStatusStyle = ({Color fg, Color bg, Color border, Color dot});

DsStatusStyle dsStatus(DsStatusKind kind) {
  switch (kind) {
    case DsStatusKind.playing:
      return const (
        fg: Color(0xFF4F4DDB),
        bg: Color(0xFFF3F3FE),
        border: Color(0xFFDEDEFB),
        dot: Color(0xFF5E5CE6)
      );
    case DsStatusKind.completed:
      return const (
        fg: Color(0xFF1F7A4D),
        bg: Color(0xFFF1FAF5),
        border: Color(0xFFCFE9DA),
        dot: Color(0xFF2CA366)
      );
    case DsStatusKind.paused:
      return const (
        fg: Color(0xFF8A5B10),
        bg: Color(0xFFFDF8EF),
        border: Color(0xFFEEDFC2),
        dot: Color(0xFFD69A2B)
      );
    case DsStatusKind.stopped:
      return const (fg: dsText2, bg: dsSubtle, border: dsBorder, dot: dsMuted);
  }
}

// ── Effect metadata ────────────────────────────────────────────────────────
// Navigation icons
const kDemoIcons = <String, IconData>{
  'Scale': Icons.zoom_in_map_rounded,
  'Slide': Icons.swap_horiz_rounded,
  'Rotate': Icons.rotate_right_rounded,
  'Chime Bell': Icons.notifications_rounded,
  'Spring': Icons.directions_run_rounded,
  'Blur': Icons.blur_on_rounded,
  'Scramble': Icons.shuffle_rounded,
  'Glitch': Icons.bolt_rounded,
  'Squash Bounce': Icons.compress_rounded,
  'Reveal': Icons.auto_fix_high_rounded,
  'Gravity': Icons.arrow_downward_rounded,
};

// Per-effect copy: a short description and a square-label tag.
const kEffectMeta = <String, ({String description, String tag})>{
  'Gravity': (
    description: 'Letters fall, collide, and pile up with real 2D physics.',
    tag: 'Physics',
  ),
  'Glitch': (
    description: 'Characters tear into sliced, RGB-split glitches.',
    tag: 'Chromatic',
  ),
  'Squash Bounce': (
    description: 'Glyphs drop, squash, then elastically settle back.',
    tag: 'Elastic',
  ),
  'Scramble': (
    description: 'Random glyphs cycle and resolve into the final text.',
    tag: 'Decode',
  ),
  'Spring': (
    description: 'Letters spring into place with a bouncy overshoot.',
    tag: 'Bouncy',
  ),
  'Reveal': (
    description: 'A cursor sweeps across, revealing each character.',
    tag: 'Cursor',
  ),
  'Scale': (
    description: 'Characters scale up from zero into their place.',
    tag: 'Zoom',
  ),
  'Slide': (
    description: 'Text slides in from your chosen direction.',
    tag: 'Directional',
  ),
  'Rotate': (
    description: 'Glyphs rotate into position, clockwise or not.',
    tag: 'Spin',
  ),
  'Chime Bell': (
    description: 'Letters swing into view like a ringing chime.',
    tag: 'Swing',
  ),
  'Blur': (
    description: 'Text sharpens into focus from a soft blur.',
    tag: 'Focus',
  ),
};
