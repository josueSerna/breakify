import 'package:breakify/breakify.dart';
import 'package:breakify/src/widgets/internal/breakify_gap_children.dart';
import 'package:flutter/widgets.dart';

import '../values/breakify_resolvable.dart';

/// A responsive layout that automatically switches between
/// a vertical and horizontal arrangement.
///
/// Below the specified [breakpoint], children are displayed in
/// a [Column]. From that breakpoint onward, they are displayed
/// in a [Row].
///
/// Spacing between children is resolved responsively using a
/// [BreakifyResolvable].
///
/// When [distributeEvenly] is enabled, each child expands to
/// occupy the available horizontal space.
///
/// Requires a [BreakifyScope] ancestor unless a custom
/// [breakpoints] configuration is provided.
///
/// ## Example
///
/// Traditional usage, without `order`:
///
/// ```dart
/// BreakifyAdaptativeLayout(
///   breakpoint: BreakifyBreakpoint.lg,
///   spacing: const BreakifyFluidValue(
///     sm: 12,
///     lg: 24,
///   ),
///   children: [
///     Sidebar(),
///     Content(),
///   ],
/// )
/// ```
///
/// ## Custom distributions with [order]
///
/// Predefined templates:
///
/// ```dart
/// BreakifyAdaptativeLayout(
///   breakpoint: BreakifyBreakpoint.lg,
///   spacing: const BreakifyFluidValue(sm: 12, lg: 24),
///   children: [Title(), Description(), Image()],
///   order: BreakifyLayoutOrder(
///     layoutBelow: BreakifyLayoutTemplate.twoRows,
///     layoutAbove: BreakifyLayoutTemplate.twoColumns,
///   ),
/// )
/// ```
///
/// Custom distribution. The indices refer to positions in the original
/// [children] list (`0` is `Title()`, `1` is `Description()` and `2` is
/// `Image()`); each child must be used exactly once:
///
/// ```dart
/// order: BreakifyLayoutOrder(
///   layoutBelow: BreakifyLayoutTemplate.inColumn,
///   layoutAbove: BreakifyLayoutTemplate.custom(
///     left: [0, 1],
///     right: [2],
///   ),
/// )
/// ```
///
/// ## Sizing limitation
///
/// Groups are not height-equalized: in `twoColumns` or `custom`, a group
/// with a single child (such as an image) keeps that child's own height
/// and is not stretched to match the other group. Give the child its own
/// size (for example `AspectRatio` or a fixed height) or use
/// `crossAxisAlignment: CrossAxisAlignment.stretch` and a child that
/// expands to fill its space.
///
/// [distributeEvenly], [stretchChildren], [mainAxisAlignment] and
/// [crossAxisAlignment] keep applying to the rows and columns produced
/// by a template.
class BreakifyAdaptativeLayout extends StatelessWidget {
  /// Widgets displayed by the layout.
  final List<Widget> children;

  /// Breakpoint at which the layout switches
  /// from a column to a row.
  final BreakifyBreakpoint breakpoint;

  /// Space between consecutive children.
  ///
  /// Supports responsive values.
  final BreakifyResolvable<double> spacing;

  /// How the children are placed along the main axis.
  final MainAxisAlignment mainAxisAlignment;

  /// How the children are aligned along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// Whether each child should share the available
  /// horizontal space equally.
  ///
  /// When `true`, children are wrapped with [Expanded].
  /// Otherwise, they are wrapped with [Flexible].
  final bool distributeEvenly;

  /// Whether children should stretch across the available
  /// horizontal space when the layout is vertical.
  ///
  /// When `true`, the [Column] uses
  /// [CrossAxisAlignment.stretch].
  ///
  /// This option has no effect when the layout is horizontal.
  final bool stretchChildren;

  /// Breakpoint configuration used to resolve responsive values.
  ///
  /// If null, the configuration provided by the nearest
  /// [BreakifyScope] is used.
  final BreakifyBreakpoints? breakpoints;

  /// Optional distributions used instead of the default
  /// column / row switch.
  ///
  /// [BreakifyLayoutOrder.layoutBelow] is used below [breakpoint] and
  /// [BreakifyLayoutOrder.layoutAbove] from [breakpoint] onward.
  /// Indices used by [BreakifyLayoutTemplate.custom] refer to positions
  /// in [children].
  ///
  /// If null, the layout is a [Column] below [breakpoint] and a [Row]
  /// from it onward.
  final BreakifyLayoutOrder? order;

  /// Creates a responsive layout that switches between
  /// a column and a row.
  const BreakifyAdaptativeLayout({
    super.key,
    required this.children,
    required this.breakpoint,
    required this.spacing,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.distributeEvenly = false,
    this.stretchChildren = false,
    this.breakpoints,
    this.order,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBreakpoints = breakpoints ?? context.breakifyBreakpoints;

    return BreakifyBuilder(
      breakpoints: effectiveBreakpoints,
      builder: (context, currentBreakpoint, constraints) {
        final width = constraints.maxWidth;
        final isHorizontal = currentBreakpoint.index >= breakpoint.index;
        final gap =
            spacing.resolve(currentBreakpoint, width, effectiveBreakpoints);

        final template = order == null
            ? null
            : (isHorizontal ? order!.layoutAbove : order!.layoutBelow);

        if (template != null) {
          return _buildTemplate(template, gap, constraints);
        }

        return isHorizontal
            ? _buildRow(children, gap, constraints)
            : _buildColumn(children, gap);
      },
    );
  }

  Widget _buildRow(
    List<Widget> items,
    double gap,
    BoxConstraints constraints,
  ) {
    final wrappedChildren = items.map(_wrapFlexible).toList();

    Widget row = Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: breakifyGapChildren(wrappedChildren, gap, Axis.horizontal),
    );

    if (crossAxisAlignment == CrossAxisAlignment.stretch &&
        constraints.maxHeight == double.infinity) {
      row = IntrinsicHeight(child: row);
    }

    return row;
  }

  Widget _buildColumn(List<Widget> items, double gap) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment:
          stretchChildren ? CrossAxisAlignment.stretch : crossAxisAlignment,
      children: breakifyGapChildren(items, gap, Axis.vertical),
    );
  }

  Widget _wrapFlexible(Widget child) {
    return distributeEvenly ? Expanded(child: child) : Flexible(child: child);
  }

  Widget _buildTemplate(
    BreakifyLayoutTemplate template,
    double gap,
    BoxConstraints constraints,
  ) {
    final groups = template.resolveGroups(children.length);
    final groupsAxis = template.groupsAxis;

    Widget buildGroup(List<int> indices) {
      final items = [for (final i in indices) children[i]];
      return groupsAxis == Axis.horizontal
          ? _buildColumn(items, gap)
          : _buildRow(items, gap, constraints);
    }

    if (groups.length == 1) return buildGroup(groups.first);

    final groupWidgets = groups.map(buildGroup).toList();

    if (groupsAxis == Axis.horizontal) {
      Widget row = Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: breakifyGapChildren(
          groupWidgets.map(_wrapFlexible).toList(),
          gap,
          Axis.horizontal,
        ),
      );

      if (crossAxisAlignment == CrossAxisAlignment.stretch &&
          constraints.maxHeight == double.infinity) {
        row = IntrinsicHeight(child: row);
      }

      return row;
    }

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment:
          stretchChildren ? CrossAxisAlignment.stretch : crossAxisAlignment,
      children: breakifyGapChildren(groupWidgets, gap, Axis.vertical),
    );
  }
}
