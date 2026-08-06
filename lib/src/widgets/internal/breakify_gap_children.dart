import 'package:flutter/widgets.dart';

/// Inserts a fixed gap between each widget in [children].
///
/// A [SizedBox] is used to create the spacing along the given [direction].
///
/// This is an internal helper and is not part of Breakify's public API.
List<Widget> breakifyGapChildren(
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
