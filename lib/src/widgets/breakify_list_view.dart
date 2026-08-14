import 'package:breakify/src/builders/breakify_builder.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../breakpoints/breakify_breakpoints.dart';
import '../scope/breakify_scope.dart';
import '../values/breakify_resolvable.dart';

/// A responsive list view with configurable spacing and separators.
///
/// `BreakifyListView` automatically resolves responsive values based on
/// the current screen width, making it easy to adjust the spacing
/// between items across different screen sizes.
///
/// By default, spacing is created using a [SizedBox]. If [separator]
/// is provided, it is displayed between items instead.
///
/// Requires a [BreakifyScope] ancestor unless a custom
/// [breakpoints] configuration is provided.
///
/// ## Example
///
/// ```dart
/// BrekifyListView(
///   itemCount: 20,
///   spacing: const BreakifyFluidValue(
///     sm: 8,
///     lg: 20,
///   ),
///   itemBuilder: (context, index) {
///     return ListTile(
///       title: Text('Item $index'),
///     );
///   },
/// )
/// ```
class BreakifyListView extends StatelessWidget {
  /// Total number of items in the list.
  final int itemCount;

  /// Builds the widget for each visible item.
  final IndexedWidgetBuilder itemBuilder;

  /// Space inserted between consecutive items.
  ///
  /// Supports responsive values.
  ///
  /// Ignored when [separator] is provided.
  final BreakifyResolvable<double>? spacing;

  /// Widget displayed between consecutive items.
  ///
  /// When provided, this replaces the default spacing created
  /// from [spacing].
  final Widget? separator;

  /// Breakpoint configuration used to resolve responsive values.
  ///
  /// If null, the configuration provided by the nearest
  /// [BreakifyScope] is used.
  final BreakifyBreakpoints? breakpoints;

  /// Empty space surrounding the list.
  final EdgeInsetsGeometry? padding;

  /// Determines how the list responds to scrolling.
  final ScrollPhysics? physics;

  /// Whether the list should size itself to its contents.
  final bool shrinkWrap;

  /// The axis along which the list scrolls.
  final Axis scrollDirection;

  /// Controls the scroll position of the list.
  final ScrollController? controller;

  /// Whether the scroll direction is reversed.
  final bool reverse;

  /// Whether this list uses the nearest
  /// [PrimaryScrollController].
  final bool? primary;

  /// The cache area used to preload items
  /// before they become visible.
  final ScrollCacheExtent? scrollCacheExtent;

  /// Creates a responsive list view.
  const BreakifyListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.spacing,
    this.separator,
    this.breakpoints,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.reverse = false,
    this.primary,
    this.scrollCacheExtent,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBreakpoints = breakpoints ?? context.breakifyBreakpoints;

    return BreakifyBuilder(
      breakpoints: effectiveBreakpoints,
      builder: (context, breakpoint, constraints) {
        final width = constraints.maxWidth;

        final gap = spacing?.resolve(
              breakpoint,
              width,
              effectiveBreakpoints,
            ) ??
            0;

        final isUnboundedMainAxis = scrollDirection == Axis.vertical
            ? constraints.maxHeight.isInfinite
            : constraints.maxWidth.isInfinite;

        return ListView.separated(
          scrollDirection: scrollDirection,
          controller: controller,
          reverse: reverse,
          primary: primary,
          padding: padding,
          physics: physics ??
              (isUnboundedMainAxis
                  ? const NeverScrollableScrollPhysics()
                  : null),
          shrinkWrap: shrinkWrap || isUnboundedMainAxis,
          scrollCacheExtent: scrollCacheExtent,
          itemCount: itemCount,
          itemBuilder: itemBuilder,
          separatorBuilder: (_, __) {
            if (separator != null) {
              return separator!;
            }

            return scrollDirection == Axis.vertical
                ? SizedBox(height: gap)
                : SizedBox(width: gap);
          },
        );
      },
    );
  }
}
