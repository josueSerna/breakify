import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';

class OrderAdaptativeScreen extends StatelessWidget {
  const OrderAdaptativeScreen({super.key});

  static const spacing = BreakifyFluidValue(sm: 12, lg: 24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layout Order')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Predefined templates',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Current breakpoint: ${context.breakpoint.name.toUpperCase()}. '
              'Below LG: twoRows. From LG: twoColumns.',
            ),
            const SizedBox(height: 16),
            BreakifyAdaptativeLayout(
              breakpoint: BreakifyBreakpoint.lg,
              spacing: spacing,
              distributeEvenly: true,
              order: const BreakifyLayoutOrder(
                layoutBelow: BreakifyLayoutTemplate.twoRows,
                layoutAbove: BreakifyLayoutTemplate.twoColumns,
              ),
              children: const [
                _Block('Title', Colors.indigo, 60),
                _Block('Description', Colors.teal, 100),
                _Block('Image', Colors.orange, 160),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Custom distribution',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Below LG: inColumn. From LG: left [0, 1], right [2].',
            ),
            const SizedBox(height: 16),
            BreakifyAdaptativeLayout(
              breakpoint: BreakifyBreakpoint.lg,
              spacing: spacing,
              distributeEvenly: true,
              order: const BreakifyLayoutOrder(
                layoutBelow: BreakifyLayoutTemplate.inColumn,
                layoutAbove: BreakifyLayoutTemplate.custom(
                  left: [2, 1],
                  right: [0, 3],
                ),
              ),
              children: const [
                _Block('Title', Colors.indigo, 60),
                _Block('Description', Colors.teal, 100),
                _Block('Image', Colors.orange, 160),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  final String label;
  final Color color;
  final double height;

  const _Block(this.label, this.color, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
