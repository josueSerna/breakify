import 'package:flutter/widgets.dart';

/// Internal helper that intersperses [SizedBox] gaps between widgets.
///
/// Not part of the public API.
List<Widget> flexifyGapChildren(
  List<Widget> children,
  double gap,
  Axis direction,
) {
  if (children.isEmpty) return const [];

  return [
    for (var i = 0; i < children.length; i++) ...[
      if (i > 0)
        direction == Axis.horizontal
            ? SizedBox(width: gap)
            : SizedBox(height: gap),
      children[i],
    ],
  ];
}
