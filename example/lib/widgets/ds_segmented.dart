import 'package:flutter/material.dart';
import '../core/constants.dart';

class DsSegmentItem {
  final IconData? icon;
  final String? label;
  final String? tooltip;
  const DsSegmentItem({this.icon, this.label, this.tooltip});
}

/// Flat segmented control group: one outer border, dividers between segments,
/// the selected segment filled `dsFill`.
class DsSegmented extends StatelessWidget {
  final List<DsSegmentItem> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const DsSegmented({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Border on the outer container (unclipped) + an inner ClipRRect one pixel
    // smaller, so the segment fills round cleanly *inside* the border instead
    // of the anti-alias clip shaving the border thin at the corners.
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: dsBorderStrong),
        borderRadius: BorderRadius.circular(r8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(r8 - 1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < items.length; i++)
              _Segment(
                item: items[i],
                isSelected: i == selectedIndex,
                isFirst: i == 0,
                onTap: () => onChanged(i),
              ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatefulWidget {
  final DsSegmentItem item;
  final bool isSelected;
  final bool isFirst;
  final VoidCallback onTap;

  const _Segment({
    required this.item,
    required this.isSelected,
    required this.isFirst,
    required this.onTap,
  });

  @override
  State<_Segment> createState() => _SegmentState();
}

class _SegmentState extends State<_Segment> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final active = widget.isSelected;
    final bg = active ? dsFill : (_hovered ? dsSubtle : dsSurface);
    final fg = active || _hovered ? dsInk : dsText2;
    final hasLabel = item.label != null;

    Widget seg = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: EdgeInsets.symmetric(
            horizontal: hasLabel ? 14 : 11,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: bg,
            border: Border(
              left: BorderSide(
                color: widget.isFirst ? Colors.transparent : dsBorder,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) Icon(item.icon, size: 15, color: fg),
              if (item.icon != null && hasLabel) const SizedBox(width: 6),
              if (hasLabel)
                Text(
                  item.label!,
                  style: dsText(
                    size: 13,
                    weight: active ? FontWeight.w600 : FontWeight.w500,
                    color: fg,
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (item.tooltip != null) {
      seg = Tooltip(message: item.tooltip!, child: seg);
    }
    return seg;
  }
}
