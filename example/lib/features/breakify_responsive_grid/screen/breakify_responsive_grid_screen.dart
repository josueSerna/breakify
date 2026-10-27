import 'package:breakify/breakify.dart';
import 'package:example/features/breakify_grid/widgets/demo_card.dart';
import 'package:example/features/breakify_grid/widgets/grid_card.dart';
import 'package:flutter/material.dart';

class BreakifyResponsiveGridScreen extends StatelessWidget {
  const BreakifyResponsiveGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BreakifyResponsiveGrid')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'BreakifyResponsiveGrid',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Automatically calculates how many columns fit '
            'based on the available width.',
          ),
          const SizedBox(height: 32),
          const Text(
            'Adaptive columns',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Resize the window to see the grid add or remove columns '
            'while keeping the minimum item width.',
          ),
          const SizedBox(height: 16),
          BreakifyResponsiveGrid(
            minItemWidth: 180,
            spacing: 16,
            padding: const EdgeInsets.all(4),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              8,
              (index) => GridCard(index: index),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Equal-height rows',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enable equalHeight to match cards within each row to the '
            'tallest card while preserving automatic columns.',
          ),
          const SizedBox(height: 16),
          BreakifyResponsiveGrid(
            minItemWidth: 180,
            maxColumns: 3,
            spacing: 16,
            equalHeight: true,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              DemoCard(
                title: 'Short card',
                description: 'A short description.',
              ),
              DemoCard(
                title: 'Long card',
                description: 'This card contains more content and determines '
                    'the height of its row.',
              ),
              DemoCard(
                title: 'Another card',
                description: 'Cards reflow as the local width changes.',
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Maximum columns',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Use maxColumns when the grid should stop growing '
            'after a specific number of columns.',
          ),
          const SizedBox(height: 16),
          BreakifyResponsiveGrid(
            minItemWidth: 160,
            maxColumns: 3,
            spacing: 16,
            childAspectRatio: 1.4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              6,
              (index) => GridCard(index: index),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Unbounded width',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'When the parent does not provide a finite width, '
            'the grid falls back to its minimum item width.',
          ),
          const SizedBox(height: 16),
          UnconstrainedBox(
            alignment: Alignment.topLeft,
            child: BreakifyResponsiveGrid(
              minItemWidth: 180,
              spacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                GridCard(index: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
