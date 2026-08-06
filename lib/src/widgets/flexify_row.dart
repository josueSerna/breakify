import 'package:flutter/widgets.dart';

import '../scope/flexify_scope.dart';
import '../values/flexify_resolvable.dart';
import 'internal/flexify_gap_children.dart';

/// A [Row] with responsive spacing between its children.
///
/// The spacing between children can change based on the current
/// breakpoint by using [FlexifyValue] or [FlexifyFluidValue].
///
/// ```dart
/// FlexifyRow(
///   spacing: const FlexifyValue(sm: 8, lg: 24),
///   children: [
///     Text('One'),
///     Text('Two'),
///     Text('Three'),
///   ],
/// )
/// ```
///
/// Requires a [FlexifyScope] ancestor.
class FlexifyRow extends StatelessWidget {
  /// Responsive spacing applied between each child.
  final FlexifyResolvable<double> spacing;

  /// Widgets laid out horizontally.
  final List<Widget> children;

  /// How the children are placed along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// How the children are placed along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// How much space should be occupied along the main axis.
  final MainAxisSize mainAxisSize;

  const FlexifyRow({
    super.key,
    required this.spacing,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    final gap = context.resolve(spacing);

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: flexifyGapChildren(children, gap, Axis.horizontal),
    );
  }
}
