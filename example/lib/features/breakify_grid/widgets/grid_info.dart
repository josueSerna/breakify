import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';

class GridInfo extends StatelessWidget {
  final BreakifyBreakpoint breakpoint;
  final double width;
  final int columns;
  final double spacing;
  final double? aspectRatio;

  const GridInfo({
    super.key,
    required this.breakpoint,
    required this.width,
    required this.columns,
    required this.spacing,
    this.aspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _InfoItem(label: 'Breakpoint', value: breakpoint.name.toUpperCase()),
        _InfoItem(label: 'Width', value: '${width.toStringAsFixed(0)} px'),
        _InfoItem(label: 'Columns', value: columns.toString()),
        _InfoItem(label: 'Spacing', value: '${spacing.toStringAsFixed(1)} px'),
        if (aspectRatio != null)
          _InfoItem(
            label: 'Aspect ratio',
            value: aspectRatio!.toStringAsFixed(2),
          ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: '),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
