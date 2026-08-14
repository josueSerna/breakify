import 'package:breakify/breakify.dart';
import 'package:example/features/breakify_adaptative_layout/widgets/layout_card.dart';
import 'package:flutter/material.dart';

class BasicAdaptativeScreen extends StatelessWidget {
  const BasicAdaptativeScreen({super.key});

  static const spacing = BreakifyFluidValue(sm: 8, lg: 24);

  @override
  Widget build(BuildContext context) {
    final resolvedSpacing = context.resolve(spacing);

    return Scaffold(
      appBar: AppBar(title: const Text('Basic Layout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Column → Row',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'The layout switches from a vertical Column '
              'to a horizontal Row at the md breakpoint.',
            ),

            const SizedBox(height: 24),

            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                Text(
                  'Breakpoint: '
                  '${context.breakpoint.name.toUpperCase()}',
                ),
                Text(
                  'Width: '
                  '${context.breakifyWidth.toStringAsFixed(0)} px',
                ),
                Text(
                  'Spacing: '
                  '${resolvedSpacing.toStringAsFixed(1)} px',
                ),
              ],
            ),

            const SizedBox(height: 32),

            BreakifyContainer(
              child: BreakifyAdaptativeLayout(
                breakpoint: BreakifyBreakpoint.md,
                spacing: spacing,
                children: const [
                  LayoutCard(title: 'Sidebar', icon: Icons.menu),
                  LayoutCard(title: 'Content', icon: Icons.article),
                  LayoutCard(title: 'Actions', icon: Icons.settings),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
