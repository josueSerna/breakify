import 'breakify_layout_template.dart';

/// Stores the two distributions used by a `BreakifyAdaptativeLayout`.
///
/// [layoutBelow] is used while the current breakpoint is below the
/// layout's `breakpoint`; [layoutAbove] is used when the current
/// breakpoint is equal to or greater than it.
///
/// ```dart
/// BreakifyLayoutOrder(
///   layoutBelow: BreakifyLayoutTemplate.twoRows,
///   layoutAbove: BreakifyLayoutTemplate.twoColumns,
/// )
/// ```
class BreakifyLayoutOrder {
  /// Distribution used below the layout's breakpoint.
  final BreakifyLayoutTemplate layoutBelow;

  /// Distribution used from the layout's breakpoint onward.
  final BreakifyLayoutTemplate layoutAbove;

  /// Creates an order with a distribution for each side of the breakpoint.
  const BreakifyLayoutOrder({
    required this.layoutBelow,
    required this.layoutAbove,
  });
}
