import 'package:breakify/src/breakpoints/breakify_breakpoints.dart';
import 'package:breakify/src/builders/breakify_builder.dart';
import 'package:breakify/src/scope/breakify_scope.dart';
import 'package:breakify/src/values/breakify_resolvable.dart';
import 'package:breakify/src/values/breakify_value.dart';
import 'package:breakify/src/widgets/internal/breakify_equal_heigth_grid.dart';
import 'package:breakify/src/widgets/internal/breakify_height_mode.dart';
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

  /// How item heights are resolved.
  ///
  /// When null (the default), items are sized from [childAspectRatio]. When
  /// set, heights come from the content and [childAspectRatio] is ignored:
  /// see [BreakifyHeightMode] for the available modes.
  ///
  /// The height is measured with the children's max intrinsic height at the
  /// final column width, and children are laid out with that tight height, so
  /// `Spacer` and `Expanded` inside a `Column` work (except in
  /// [BreakifyHeightMode.natural]). Children must support intrinsic
  /// measurement; widgets that do not, such as `LayoutBuilder`, are not
  /// supported. Intrinsic measurement adds layout cost, so avoid it for very
  /// large grids.
  ///
  /// Currently only supported with [Axis.vertical].
  final BreakifyHeightMode? heightMode;

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
    this.heightMode,
  }) : assert(
          heightMode == null || scrollDirection == Axis.vertical,
          'BreakifyGrid.heightMode currently only supports '
          'Axis.vertical.',
        );

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
        final isUnboundedMainAxis = scrollDirection == Axis.vertical
            ? constraints.maxHeight.isInfinite
            : constraints.maxWidth.isInfinite;

        if (heightMode == null) {
          final resolvedAspectRatio = childAspectRatio.resolve(
            breakpoint,
            width,
            effectiveBreakpoints,
          );

          final effectiveAspectRatio = scrollDirection == Axis.horizontal
              ? 1 / resolvedAspectRatio
              : resolvedAspectRatio;

          return GridView.builder(
            scrollDirection: scrollDirection,
            controller: controller,
            scrollCacheExtent: scrollCacheExtent,
            reverse: reverse,
            primary: primary,
            padding: padding,
            physics: physics ??
                (isUnboundedMainAxis
                    ? const NeverScrollableScrollPhysics()
                    : null),
            shrinkWrap: shrinkWrap || isUnboundedMainAxis,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: crossSpacing,
              mainAxisSpacing: mainSpacing,
              childAspectRatio: effectiveAspectRatio,
            ),
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],
          );
        }

        return BreakifyEqualHeightGridLayout(
            columns: crossAxisCount,
            crossSpacing: crossSpacing,
            mainSpacing: mainSpacing,
            padding: padding,
            physics: physics ??
                (isUnboundedMainAxis
                    ? const NeverScrollableScrollPhysics()
                    : null),
            shrinkWrap: shrinkWrap || isUnboundedMainAxis,
            controller: controller,
            scrollCacheExtent: scrollCacheExtent,
            reverse: reverse,
            primary: primary,
            heightMode: heightMode!,
            children: children);
      },
    );
  }
}
