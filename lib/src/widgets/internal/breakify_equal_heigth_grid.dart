import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class BreakifyEqualHeigthGrid extends StatelessWidget {
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

  const BreakifyEqualHeigthGrid(
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

class _BreakifyEqualHeightRow extends StatelessWidget {
  final List<Widget> children;
  final int columns;
  final double spacing;

  const _BreakifyEqualHeightRow(
      {required this.children, required this.columns, required this.spacing});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < columns; index++) ...[
            if (index > 0) SizedBox(width: spacing),
            Expanded(
                child: index < children.length
                    ? children[index]
                    : SizedBox.shrink())
          ]
        ],
      ),
    );
  }
}
