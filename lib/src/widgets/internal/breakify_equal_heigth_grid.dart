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
      required this.children});

  @override
  Widget build(BuildContext context) {
    final safeColumns = columns < 1 ? 1 : columns;

    final rowCount = (children.length / safeColumns).ceil();

    final sliver = SliverList.builder(
        itemCount: rowCount,
        itemBuilder: (context, rowIndex) {
          final start = rowIndex * safeColumns;
          final end = (start + safeColumns).clamp(0, children.length);

          final rowChildren = children.sublist(start, end);

          final isLastRow = rowIndex == rowCount - 1;

          return Padding(
            padding: EdgeInsets.only(bottom: isLastRow ? 0 : mainSpacing),
            child: _BreakifyEqualHeightRow(
                columns: safeColumns,
                spacing: crossSpacing,
                children: rowChildren),
          );
        });
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

/// Lays out up to [columns] children side by side, giving every child the
/// same width and the same (tight) height.
///
/// The row height is the largest max-intrinsic height among its children,
/// measured at the final column width. The children are then laid out once
/// with tight constraints, so `Expanded` and `Spacer` inside a `Column` always
/// receive a bounded height, which unbounded measurement could not provide.
///
/// Children that cannot compute intrinsic dimensions (for example
/// `LayoutBuilder`) are not supported.
class _BreakifyEqualHeightRow extends MultiChildRenderObjectWidget {
  final int columns;
  final double spacing;

  const _BreakifyEqualHeightRow({
    required this.columns,
    required this.spacing,
    required super.children,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderEqualHeightRow(columns: columns, spacing: spacing);

  @override
  void updateRenderObject(
      BuildContext context, _RenderEqualHeightRow renderObject) {
    renderObject
      ..columns = columns
      ..spacing = spacing;
  }
}

class _EqualHeightRowParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderEqualHeightRow extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _EqualHeightRowParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _EqualHeightRowParentData> {
  _RenderEqualHeightRow({required int columns, required double spacing})
      : _columns = columns,
        _spacing = spacing;

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

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _EqualHeightRowParentData) {
      child.parentData = _EqualHeightRowParentData();
    }
  }

  double _columnWidth(double width) {
    final available = width - spacing * (columns - 1);
    return available <= 0 ? 0 : available / columns;
  }

  double _rowHeight(double width) {
    final columnWidth = _columnWidth(width);
    var height = 0.0;
    var child = firstChild;
    while (child != null) {
      final h = child.getMaxIntrinsicHeight(columnWidth);
      if (h > height) height = h;
      child = childAfter(child);
    }
    return height;
  }

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
  double computeMinIntrinsicHeight(double width) => _rowHeight(width);

  @override
  double computeMaxIntrinsicHeight(double width) => _rowHeight(width);

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(constraints.hasBoundedWidth);
    final width = constraints.maxWidth;
    return constraints.constrain(Size(width, _rowHeight(width)));
  }

  @override
  void performLayout() {
    assert(
      constraints.hasBoundedWidth,
      'BreakifyGrid.equalHeight requires a bounded cross-axis extent.',
    );
    final width = constraints.maxWidth;
    final columnWidth = _columnWidth(width);
    final height = constraints.constrainHeight(_rowHeight(width));
    final childConstraints = BoxConstraints.tightFor(
      width: columnWidth,
      height: height,
    );

    var index = 0;
    var child = firstChild;
    while (child != null) {
      child.layout(childConstraints, parentUsesSize: false);
      (child.parentData! as _EqualHeightRowParentData).offset =
          Offset(index * (columnWidth + spacing), 0);
      index++;
      child = childAfter(child);
    }
    size = Size(width, height);
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
