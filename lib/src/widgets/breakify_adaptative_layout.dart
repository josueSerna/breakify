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
/// ```dart
/// BreakifyResponsiveLayout(
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

  /// Breakpoint configuration used to resolve responsive values.
  ///
  /// If null, the configuration provided by the nearest
  /// [BreakifyScope] is used.
  final BreakifyBreakpoints? breakpoints;

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
    this.breakpoints,
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

        if (isHorizontal) {
          final wrappedChildren = children.map((child) {
            return distributeEvenly
                ? Expanded(child: child)
                : Flexible(child: child);
          }).toList();

          // Si usamos stretch y hay altura infinita, envolvemos en IntrinsicHeight
          Widget row = Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children:
                breakifyGapChildren(wrappedChildren, gap, Axis.horizontal),
          );

          if (crossAxisAlignment == CrossAxisAlignment.stretch &&
              constraints.maxHeight == double.infinity) {
            row = IntrinsicHeight(child: row);
          }

          return row;
        } else {
          return Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: breakifyGapChildren(children, gap, Axis.vertical),
          );
        }
      },
    );
  }
}
