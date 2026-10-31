import 'package:breakify/src/widgets/internal/breakify_height_mode.dart';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class BreakifyEqualHeightGridLayout extends StatelessWidget {
  final int columns;
  final double crossSpacing;
  final double mainSpacing;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final ScrollController? controller;
  final ScrollCacheExtent? scrollCacheExtent;
  final bool reverse;
  final bool? primary;
  final BreakifyHeightMode heightMode;
  final List<Widget> children;

  const BreakifyEqualHeightGridLayout(
      {super.key,
      required this.columns,
      required this.crossSpacing,
      required this.mainSpacing,
      this.padding,
      this.physics,
      required this.shrinkWrap,
      this.controller,
      this.scrollCacheExtent,
      required this.reverse,
      this.primary,
      required this.heightMode,
      required this.children});

  @override
  Widget build(BuildContext context) {
    final safeColumns = columns < 1 ? 1 : columns;

    final rowCount = (children.length / safeColumns).ceil();

    final Widget sliver;
    if (heightMode == BreakifyHeightMode.equal) {
      sliver = _EqualRowsSliver(
        columns: safeColumns,
        crossSpacing: crossSpacing,
        mainSpacing: mainSpacing,
        delegate: SliverChildBuilderDelegate(
          (context, rowIndex) {
            final start = rowIndex * safeColumns;
            final end = (start + safeColumns).clamp(0, children.length);
            return Padding(
              padding: EdgeInsets.only(bottom: mainSpacing),
              child: _BreakifyHeightGrid(
                  columns: safeColumns,
                  spacing: crossSpacing,
                  mainSpacing: 0,
                  mode: BreakifyHeightMode.equalInRow,
                  children: children.sublist(start, end)),
            );
          },
          childCount: rowCount,
        ),
        children: children,
      );
    } else {
      sliver = SliverList.builder(
          itemCount: rowCount,
          itemBuilder: (context, rowIndex) {
            final start = rowIndex * safeColumns;
            final end = (start + safeColumns).clamp(0, children.length);
            final isLastRow = rowIndex == rowCount - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLastRow ? 0 : mainSpacing),
              child: _BreakifyHeightGrid(
                  columns: safeColumns,
                  spacing: crossSpacing,
                  mainSpacing: 0,
                  mode: heightMode,
                  children: children.sublist(start, end)),
            );
          });
    }
    final effectiveSliver = padding == null
        ? sliver
        : SliverPadding(
            padding: padding!,
            sliver: sliver,
          );

    return CustomScrollView(
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      primary: primary,
      scrollCacheExtent: scrollCacheExtent,
      slivers: [effectiveSliver],
    );
  }
}

/// Fixed-extent sliver for [BreakifyHeightMode.equal].
///
/// The shared row extent is measured by building each row one at a time and
/// discarding it, so only visible rows stay alive. The result is cached until
/// the width, columns, spacing or children change.
class _EqualRowsSliver extends SliverMultiBoxAdaptorWidget {
  final List<Widget> children;
  final int columns;
  final double crossSpacing;
  final double mainSpacing;

  const _EqualRowsSliver({
    required super.delegate,
    required this.children,
    required this.columns,
    required this.crossSpacing,
    required this.mainSpacing,
  });

  @override
  RenderSliverMultiBoxAdaptor createRenderObject(BuildContext context) {
    final element = context as SliverMultiBoxAdaptorElement;
    return _RenderEqualRowsSliver(childManager: element)
      ..update(children, columns, crossSpacing, mainSpacing);
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderEqualRowsSliver renderObject) {
    renderObject.update(children, columns, crossSpacing, mainSpacing);
  }
}

class _RenderEqualRowsSliver extends RenderSliverFixedExtentBoxAdaptor {
  _RenderEqualRowsSliver({required super.childManager});

  List<Widget> _children = const [];
  int _columns = 1;
  double _crossSpacing = 0;
  double _mainSpacing = 0;
  double? _measuredWidth;
  double _extent = 0;

  void update(
      List<Widget> children, int columns, double crossSpacing, double main) {
    var same = columns == _columns &&
        crossSpacing == _crossSpacing &&
        main == _mainSpacing &&
        children.length == _children.length;
    for (var i = 0; same && i < children.length; i++) {
      same = identical(children[i], _children[i]);
    }
    _children = children;
    if (!same) {
      _columns = columns;
      _crossSpacing = crossSpacing;
      _mainSpacing = main;
      _measuredWidth = null;
    }
  }

  @override
  double get itemExtent => _extent;

  void _measure(double width) {
    childManager.didStartLayout();
    collectGarbage(childCount, 0);
    var tallest = 0.0;
    var index = 0;
    while (addInitialChild(index: index, layoutOffset: 0)) {
      tallest = math.max(tallest, firstChild!.getMaxIntrinsicHeight(width));
      collectGarbage(1, 0);
      index++;
    }
    childManager.didFinishLayout();
    _extent = tallest;
    _measuredWidth = width;
  }

  @override
  void performLayout() {
    if (_measuredWidth != constraints.crossAxisExtent) {
      _measure(constraints.crossAxisExtent);
    }
    super.performLayout();
  }
}

/// Lays out [children] in rows of [columns] items with equal widths.
///
/// Heights depend on [mode]:
/// * [BreakifyHeightMode.equalInRow]: each row uses its tallest child's
///   max-intrinsic height at the final column width, and its children are
///   laid out tight to it, so `Expanded` and `Spacer` in a `Column` receive a
///   bounded height.
/// * [BreakifyHeightMode.equal]: like the above, but every row uses the
///   tallest height across all rows.
/// * [BreakifyHeightMode.natural]: children keep their own height.
///
/// Children that cannot compute intrinsic dimensions (for example
/// `LayoutBuilder`) are not supported.
class _BreakifyHeightGrid extends MultiChildRenderObjectWidget {
  final int columns;
  final double spacing;
  final double mainSpacing;
  final BreakifyHeightMode mode;

  const _BreakifyHeightGrid({
    required this.columns,
    required this.spacing,
    required this.mainSpacing,
    required this.mode,
    required super.children,
  });

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderHeightGrid(
        columns: columns,
        spacing: spacing,
        mainSpacing: mainSpacing,
        mode: mode,
      );

  @override
  void updateRenderObject(
      BuildContext context, _RenderHeightGrid renderObject) {
    renderObject
      ..columns = columns
      ..spacing = spacing
      ..mainSpacing = mainSpacing
      ..mode = mode;
  }
}

class _HeightGridParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderHeightGrid extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _HeightGridParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _HeightGridParentData> {
  _RenderHeightGrid({
    required int columns,
    required double spacing,
    required double mainSpacing,
    required BreakifyHeightMode mode,
  })  : _columns = columns,
        _spacing = spacing,
        _mainSpacing = mainSpacing,
        _mode = mode;

  int _columns;
  int get columns => _columns;
  set columns(int value) {
    if (_columns == value) return;
    _columns = value;
    markNeedsLayout();
  }

  double _spacing;
  double get spacing => _spacing;
  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  double _mainSpacing;
  double get mainSpacing => _mainSpacing;
  set mainSpacing(double value) {
    if (_mainSpacing == value) return;
    _mainSpacing = value;
    markNeedsLayout();
  }

  BreakifyHeightMode _mode;
  BreakifyHeightMode get mode => _mode;
  set mode(BreakifyHeightMode value) {
    if (_mode == value) return;
    _mode = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _HeightGridParentData) {
      child.parentData = _HeightGridParentData();
    }
  }

  double _columnWidth(double width) {
    final available = width - spacing * (columns - 1);
    return available <= 0 ? 0 : available / columns;
  }

  List<double> _intrinsicRowHeights(double width) {
    final columnWidth = _columnWidth(width);
    final heights = <double>[];
    var index = 0;
    var child = firstChild;
    while (child != null) {
      final h = child.getMaxIntrinsicHeight(columnWidth);
      if (index % columns == 0) {
        heights.add(h);
      } else if (h > heights.last) {
        heights.last = h;
      }
      index++;
      child = childAfter(child);
    }
    if (mode == BreakifyHeightMode.equal && heights.isNotEmpty) {
      final tallest = heights.reduce((a, b) => a > b ? a : b);
      return List.filled(heights.length, tallest);
    }
    return heights;
  }

  double _totalHeight(List<double> rows) {
    if (rows.isEmpty) return 0;
    return rows.fold(0.0, (sum, h) => sum + h) +
        mainSpacing * (rows.length - 1);
  }

  double _intrinsicHeight(double width) =>
      _totalHeight(_intrinsicRowHeights(width));

  @override
  double computeMinIntrinsicWidth(double height) => 0;

  @override
  double computeMaxIntrinsicWidth(double height) {
    var width = 0.0;
    var child = firstChild;
    while (child != null) {
      final w = child.getMaxIntrinsicWidth(height);
      if (w > width) width = w;
      child = childAfter(child);
    }
    return width * columns + spacing * (columns - 1);
  }

  @override
  double computeMinIntrinsicHeight(double width) => _intrinsicHeight(width);

  @override
  double computeMaxIntrinsicHeight(double width) => _intrinsicHeight(width);

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(constraints.hasBoundedWidth);
    final width = constraints.maxWidth;
    return constraints.constrain(Size(width, _intrinsicHeight(width)));
  }

  @override
  void performLayout() {
    assert(
      constraints.hasBoundedWidth,
      'BreakifyGrid.heightMode requires a bounded cross-axis extent.',
    );
    final width = constraints.maxWidth;
    final columnWidth = _columnWidth(width);
    final natural = mode == BreakifyHeightMode.natural;
    final tightHeights = natural ? null : _intrinsicRowHeights(width);
    if (tightHeights != null &&
        tightHeights.length == 1 &&
        constraints.hasTightHeight) {
      tightHeights[0] = constraints.maxHeight;
    }

    var y = 0.0;
    var row = 0;
    var child = firstChild;
    while (child != null) {
      final rowChildren = <RenderBox>[];
      while (child != null && rowChildren.length < columns) {
        rowChildren.add(child);
        child = childAfter(child);
      }

      final childConstraints = natural
          ? BoxConstraints(minWidth: columnWidth, maxWidth: columnWidth)
          : BoxConstraints.tightFor(
              width: columnWidth, height: tightHeights![row]);

      var rowHeight = 0.0;
      for (var i = 0; i < rowChildren.length; i++) {
        final item = rowChildren[i];
        item.layout(childConstraints, parentUsesSize: natural);
        (item.parentData! as _HeightGridParentData).offset =
            Offset(i * (columnWidth + spacing), y);
        if (natural && item.size.height > rowHeight) {
          rowHeight = item.size.height;
        }
      }
      if (!natural) rowHeight = tightHeights![row];

      y += rowHeight + mainSpacing;
      row++;
    }
    final total = row == 0 ? 0.0 : y - mainSpacing;
    size = constraints.constrain(Size(width, total));
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) =>
      defaultComputeDistanceToHighestActualBaseline(baseline);

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
