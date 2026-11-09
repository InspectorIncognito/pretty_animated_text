import 'package:flutter/material.dart';
import '../core/constants.dart';

enum DsButtonVariant { primary, accent, secondary, filled, ghost, danger }

enum DsButtonSize { sm, md, lg }

/// Flat design-system button with hover / pressed / focus states.
class DsButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final DsButtonVariant variant;
  final DsButtonSize size;
  final bool expand;

  const DsButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = DsButtonVariant.primary,
    this.size = DsButtonSize.md,
    this.expand = false,
  });

  @override
  State<DsButton> createState() => _DsButtonState();
}

class _DsButtonState extends State<DsButton> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  bool get _disabled => widget.onPressed == null;

  ({double fontSize, double radius, EdgeInsets padding, double iconSize})
      get _metrics {
    switch (widget.size) {
      case DsButtonSize.sm:
        return (
          fontSize: 12,
          radius: r6,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          iconSize: 14
        );
      case DsButtonSize.md:
        return (
          fontSize: 14,
          radius: r8,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          iconSize: 16
        );
      case DsButtonSize.lg:
        return (
          fontSize: 15,
          radius: r10,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          iconSize: 18
        );
    }
  }

  ({Color bg, Color border, Color fg}) get _colors {
    if (_disabled) {
      return (bg: dsFill, border: dsFill, fg: dsDisabled);
    }
    final h = _hovered;
    switch (widget.variant) {
      case DsButtonVariant.primary:
        return (
          bg: h ? dsInkHover : dsInk,
          border: h ? dsInkHover : dsInk,
          fg: dsSurface
        );
      case DsButtonVariant.accent:
        return (
          bg: h ? dsAccentHover : dsAccent,
          border: h ? dsAccentHover : dsAccent,
          fg: dsSurface
        );
      case DsButtonVariant.secondary:
        return (
          bg: h ? dsSubtle : dsSurface,
          border: h ? dsBorderHover : dsBorderStrong,
          fg: dsInk
        );
      case DsButtonVariant.filled:
        return (
          bg: h ? dsFillHover : dsFill,
          border: Colors.transparent,
          fg: dsInk
        );
      case DsButtonVariant.ghost:
        return (
          bg: h ? dsFill : Colors.transparent,
          border: Colors.transparent,
          fg: h ? dsInk : dsText2
        );
      case DsButtonVariant.danger:
        return (
          bg: h ? dsDangerBg : dsSurface,
          border: h ? dsDangerBorderHover : dsDangerBorder,
          fg: dsDanger
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = _metrics;
    final c = _colors;

    Widget content = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: m.iconSize, color: c.fg),
          const SizedBox(width: 7),
        ],
        Text(
          widget.label,
          style: dsText(size: m.fontSize, weight: FontWeight.w500, color: c.fg),
        ),
      ],
    );

    return MouseRegion(
      cursor:
          _disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Focus(
        canRequestFocus: !_disabled,
        onFocusChange: (f) => setState(() => _focused = f),
        child: GestureDetector(
          onTapDown: _disabled ? null : (_) => setState(() => _pressed = true),
          onTapUp: _disabled
              ? null
              : (_) {
                  setState(() => _pressed = false);
                  widget.onPressed!();
                },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(0, _pressed ? 1 : 0, 0),
            padding: m.padding,
            decoration: BoxDecoration(
              color: c.bg,
              border: Border.all(color: c.border),
              borderRadius: BorderRadius.circular(m.radius),
              boxShadow: _focused
                  ? [
                      const BoxShadow(
                          color: dsFocus, blurRadius: 0, spreadRadius: 3)
                    ]
                  : null,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}

enum DsIconVariant { outline, ink, ghost }

/// Square flat icon button (36×36 by default; pass [size]/[radius] for the
/// 30×30 topbar variant).
class DsIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final DsIconVariant variant;
  final double size;
  final double radius;
  final double iconSize;

  const DsIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.variant = DsIconVariant.outline,
    this.size = 36,
    this.radius = r8,
    this.iconSize = 16,
  });

  @override
  State<DsIconButton> createState() => _DsIconButtonState();
}

class _DsIconButtonState extends State<DsIconButton> {
  bool _hovered = false;

  ({Color bg, Color border, Color fg}) get _colors {
    final h = _hovered;
    switch (widget.variant) {
      case DsIconVariant.outline:
        return (
          bg: h ? dsSubtle : dsSurface,
          border: dsBorderStrong,
          fg: h ? dsInk : dsText2
        );
      case DsIconVariant.ink:
        return (
          bg: h ? dsInkHover : dsInk,
          border: h ? dsInkHover : dsInk,
          fg: dsSurface
        );
      case DsIconVariant.ghost:
        return (
          bg: h ? dsFill : Colors.transparent,
          border: Colors.transparent,
          fg: h ? dsInk : dsMuted
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _colors;
    Widget btn = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: widget.size,
          height: widget.size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.bg,
            border: Border.all(color: c.border),
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          child: Icon(widget.icon, size: widget.iconSize, color: c.fg),
        ),
      ),
    );
    if (widget.tooltip != null) {
      btn = Tooltip(message: widget.tooltip!, child: btn);
    }
    return btn;
  }
}
