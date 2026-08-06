import 'package:breakify/src/breakpoints/breakify_breakpoints.dart';
import 'package:breakify/src/builders/breakify_builder.dart';
import 'package:breakify/src/scope/breakify_scope.dart';
import 'package:breakify/src/values/breakify_resolvable.dart';
import 'package:breakify/src/values/breakify_value.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A responsive grid that automatically adapts its layout
/// to the available screen width.
///
/// The number of columns, spacing and child aspect ratio can all
/// be resolved responsively using [BreakifyResolvable] values,
/// allowing the grid to scale naturally across different screen sizes.
///
/// Requires a [BreakifyScope] ancestor unless a custom
/// [breakpoints] configuration is provided.
///
/// ## Example
///
/// ```dart
/// BreakifyGrid(
///   columns: const BreakifyValue(
///     sm: 1,
///     md: 2,
///     lg: 4,
///   ),
///   spacing: const BreakifyFluidValue(
///     sm: 8,
///     lg: 20,
///   ),
///   children: [
///     ...
///   ],
/// )
/// ```
class BreakifyGrid extends StatelessWidget {
  /// Number of columns displayed at each breakpoint.
  ///
  /// Supports responsive values.
  final BreakifyResolvable<int> columns;

  /// Applies the same spacing to both rows and columns.
  ///
  /// Ignored when [crossAxisSpacing] or [mainAxisSpacing]
  /// are provided.
  /// Supports responsive values.
  final BreakifyResolvable<double>? spacing;

  /// Horizontal spacing between grid items.
  ///
  /// Overrides [spacing] when provided.
  /// Supports responsive values.
  final BreakifyResolvable<double>? crossAxisSpacing;

  /// Vertical spacing between grid items.
  ///
  /// Overrides [spacing] when provided.
  /// Supports responsive values.
  final BreakifyResolvable<double>? mainAxisSpacing;

  /// Aspect ratio of each grid item.
  ///
  /// A value of `1.0` creates square items.
  ///
  /// Supports responsive values.
  final BreakifyResolvable<double> childAspectRatio;

  /// The widgets displayed in the grid.
  final List<Widget> children;

  /// Breakpoint configuration used to resolve responsive values.
  ///
  /// If null, the configuration provided by the nearest
  /// [BreakifyScope] is used.
  final BreakifyBreakpoints? breakpoints;

  /// Empty space surrounding the grid.
  final EdgeInsetsGeometry? padding;

  /// Determines how the grid responds to scrolling.
  final ScrollPhysics? physics;

  /// Whether the grid should size itself to its contents.
  final bool shrinkWrap;

  /// The axis along which the grid scrolls.
  final Axis scrollDirection;

  /// Controls the scroll position of the grid.
  final ScrollController? controller;

  /// The cache area used to preload items
  /// before they become visible.
  final ScrollCacheExtent? scrollCacheExtent;

  /// Whether the scroll direction is reversed.
  final bool reverse;

  /// Whether this grid uses the nearest
  /// [PrimaryScrollController].
  final bool? primary;

  /// Creates a responsive grid.
  const BreakifyGrid({
    super.key,
    required this.columns,
    required this.children,
    this.spacing,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.childAspectRatio = const BreakifyValue(sm: 1.0),
    this.breakpoints,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.scrollCacheExtent,
    this.reverse = false,
    this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBreakpoints = breakpoints ?? context.breakifyBreakpoints;

    return BreakifyBuilder(
      breakpoints: effectiveBreakpoints,
      builder: (context, breakpoint, constraints) {
        final width = constraints.maxWidth;

        final crossAxisCount =
            columns.resolve(breakpoint, width, effectiveBreakpoints);

        final spacingValue =
            spacing?.resolve(breakpoint, width, effectiveBreakpoints);

        final crossSpacing = crossAxisSpacing?.resolve(
              breakpoint,
              width,
              effectiveBreakpoints,
            ) ??
            spacingValue ??
            0;

        final mainSpacing = mainAxisSpacing?.resolve(
              breakpoint,
              width,
              effectiveBreakpoints,
            ) ??
            spacingValue ??
            0;

        final aspectRatio = childAspectRatio.resolve(
          breakpoint,
          width,
          effectiveBreakpoints,
        );

        final isUnboundedHeight = constraints.maxHeight.isInfinite;

        return GridView.builder(
          scrollDirection: scrollDirection,
          controller: controller,
          scrollCacheExtent: scrollCacheExtent,
          reverse: reverse,
          primary: primary,
          padding: padding,
          physics: physics ??
              (isUnboundedHeight ? const NeverScrollableScrollPhysics() : null),
          shrinkWrap: shrinkWrap || isUnboundedHeight,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: crossSpacing,
            mainAxisSpacing: mainSpacing,
            childAspectRatio: aspectRatio,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}
