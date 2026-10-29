import 'dart:math' as math;

import 'package:breakify/src/widgets/internal/breakify_equal_heigth_grid.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A grid that automatically determines how many columns fit
/// within the available width.
///
/// The number of columns is calculated using [minItemWidth]
/// and [spacing]. When the available width is insufficient
/// for multiple items, the grid uses a single column.
///
/// When the parent does not provide a finite width, the grid
/// uses [minItemWidth] as its fallback width.
///
/// The grid must still receive a bounded height unless
/// [shrinkWrap] is enabled.
///
/// Unlike BreakifyGrid, this widget does not require the caller
/// to define a responsive column count for each breakpoint.
class BreakifyResponsiveGrid extends StatelessWidget {
  /// The widgets displayed in the grid.
  final List<Widget> children;

  /// Minimum desired width of each item, in logical pixels.
  ///
  /// When the available width is smaller than this value, a single
  /// column is used and its items may be narrower than this value.
  final double minItemWidth;

  /// Maximum number of columns allowed.
  ///
  /// If null, the number of columns is limited only by the available
  /// width and [minItemWidth].
  final int? maxColumns;

  /// Horizontal and vertical space between grid items.
  final double spacing;

  /// The width-to-height ratio of each grid item.
  ///
  /// A value of `1.0` produces square items.
  final double childAspectRatio;

  /// Whether items in each row should match the height of the tallest item.
  ///
  /// When enabled, [childAspectRatio] is ignored and each row sizes itself
  /// from its content. This option is disabled by default.
  final bool equalHeight;

  /// Empty space surrounding the grid.
  final EdgeInsetsGeometry? padding;

  /// How the grid should respond to user scrolling.
  final ScrollPhysics? physics;

  /// Whether the grid should size itself to its contents.
  final bool shrinkWrap;

  /// Controls the grid's scroll position.
  final ScrollController? controller;

  /// Whether the scroll direction is reversed.
  final bool reverse;

  /// Whether this grid uses the nearest [PrimaryScrollController].
  final bool? primary;

  /// The cache area used to preload items before they become visible.
  final ScrollCacheExtent? scrollCacheExtent;

  /// Creates a grid that calculates its columns from the available width.
  ///
  /// When the parent provides an unbounded width, the grid uses
  /// [minItemWidth] plus its horizontal padding as a finite fallback width.
  const BreakifyResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 240,
    this.maxColumns,
    this.spacing = 16,
    this.childAspectRatio = 1,
    this.equalHeight = false,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
    this.controller,
    this.reverse = false,
    this.primary,
    this.scrollCacheExtent,
  })  : assert(
          minItemWidth > 0,
          'minItemWidth must be greater than zero.',
        ),
        assert(spacing >= 0, 'spacing cannot be negative.'),
        assert(
          childAspectRatio > 0,
          'childAspectRatio must be greater than zero.',
        ),
        assert(
          maxColumns == null || maxColumns > 0,
          'maxColumns must be greater than zero.',
        );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectivePadding = (padding ?? EdgeInsets.zero).resolve(
          Directionality.of(context),
        );

        final hasFiniteWidth = constraints.maxWidth.isFinite;

        final fallbackWidth = math.max(
          constraints.minWidth,
          minItemWidth + effectivePadding.horizontal,
        );

        final effectiveWidth =
            hasFiniteWidth ? constraints.maxWidth : fallbackWidth;

        final availableWidth = math.max(
          0.0,
          effectiveWidth - effectivePadding.horizontal,
        );

        final calculatedColumns =
            ((availableWidth + spacing) / (minItemWidth + spacing))
                .floor()
                .clamp(1, 1 << 30)
                .toInt();

        final columnCount = maxColumns == null
            ? calculatedColumns
            : calculatedColumns.clamp(1, maxColumns!).toInt();

        final isUnboundedHeight = constraints.maxHeight.isInfinite;
        final effectivePhysics = physics ??
            (isUnboundedHeight ? const NeverScrollableScrollPhysics() : null);
        final effectiveShrinkWrap = shrinkWrap || isUnboundedHeight;

        if (equalHeight) {
          final grid = BreakifyEqualHeightGridLayout(
            columns: columnCount,
            crossSpacing: spacing,
            mainSpacing: spacing,
            padding: padding,
            physics: effectivePhysics,
            shrinkWrap: effectiveShrinkWrap,
            controller: controller,
            scrollCacheExtent: scrollCacheExtent,
            reverse: reverse,
            primary: primary,
            children: children,
          );

          if (!hasFiniteWidth) {
            return SizedBox(
              width: effectiveWidth,
              child: grid,
            );
          }

          return grid;
        }

        final grid = GridView.builder(
          controller: controller,
          reverse: reverse,
          primary: primary,
          padding: padding,
          physics: effectivePhysics,
          shrinkWrap: effectiveShrinkWrap,
          scrollCacheExtent: scrollCacheExtent,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columnCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );

        // Give the grid a finite width when its parent
        // does not provide one.
        if (!hasFiniteWidth) {
          return SizedBox(
            width: effectiveWidth,
            child: grid,
          );
        }

        return grid;
      },
    );
  }
}
