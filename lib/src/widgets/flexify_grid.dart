import 'package:flexify/src/breakpoints/flexify_breakpoints.dart';
import 'package:flexify/src/builders/flexify_builder.dart';
import 'package:flexify/src/scope/flexify_scope.dart';
import 'package:flexify/src/values/flexify_resolvable.dart';
import 'package:flexify/src/values/flexify_value.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A responsive grid that automatically adapts its column count
/// based on the current breakpoint.
///
/// The number of columns is resolved using a [FlexifyValue],
/// allowing layouts to scale across different screen sizes.
class FlexifyGrid extends StatelessWidget {
  /// Number of columns for each breakpoint.
  ///
  /// This is the only required layout property.
  final FlexifyResolvable<int> columns;

  /// Applies the same spacing to both rows and columns.
  ///
  /// Ignored when [crossAxisSpacing] or [mainAxisSpacing]
  /// are provided.
  final FlexifyResolvable<double>? spacing;

  /// Horizontal spacing between grid items.
  final FlexifyResolvable<double>? crossAxisSpacing;

  /// Vertical spacing between grid items.
  final FlexifyResolvable<double>? mainAxisSpacing;

  /// The aspect ratio of each grid item.
  ///
  /// A value of `1.0` creates square items.
  final FlexifyResolvable<double> childAspectRatio;

  /// The widgets displayed in the grid.
  final List<Widget> children;

  /// Breakpoint configuration used to resolve
  /// the current column count.
  final FlexifyBreakpoints? breakpoints;

  /// Empty space surrounding the grid.
  final EdgeInsetsGeometry? padding;

  /// Determines how the grid responds to scrolling.
  final ScrollPhysics? physics;

  /// Whether the grid should size itself to
  /// the total height of its children.
  final bool shrinkWrap;

  /// The axis along which the grid scrolls.
  final Axis scrollDirection;

  /// Controls the scroll position of the grid.
  final ScrollController? controller;

  /// The cache area used to preload items
  /// before they become visible.
  final ScrollCacheExtent? scrollCacheExtent;

  /// Whether the grid scrolls in the reverse direction.
  final bool reverse;

  /// Whether this grid uses the nearest
  /// [PrimaryScrollController].
  final bool? primary;

  /// Creates a responsive grid with a configurable
  /// number of columns for each breakpoint.
  const FlexifyGrid({
    super.key,
    required this.columns,
    required this.children,
    this.spacing,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.childAspectRatio = const FlexifyValue(sm: 1.0),
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
    final effectiveBreakpoints = breakpoints ?? context.flexifyBreakpoints;

    return FlexifyBuilder(
      breakpoints: effectiveBreakpoints,
      builder: (context, breakpoint, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount =
            columns.resolve(breakpoint, width, effectiveBreakpoints);
        final spacingValue =
            spacing?.resolve(breakpoint, width, effectiveBreakpoints);

        final crossSpacing = crossAxisSpacing?.resolve(
                breakpoint, width, effectiveBreakpoints) ??
            spacingValue ??
            0;

        final mainSpacing =
            mainAxisSpacing?.resolve(breakpoint, width, effectiveBreakpoints) ??
                spacingValue ??
                0;

        final aspectRatio =
            childAspectRatio.resolve(breakpoint, width, effectiveBreakpoints);
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
