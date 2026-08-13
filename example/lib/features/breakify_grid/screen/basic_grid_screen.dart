import 'package:breakify/breakify.dart';
import 'package:example/features/breakify_grid/widgets/grid_card.dart';
import 'package:example/features/breakify_grid/widgets/grid_info.dart';
import 'package:flutter/material.dart';

class BasicGridScreen extends StatelessWidget {
  const BasicGridScreen({super.key});

  static const columns = BreakifyValue<int>(sm: 1, md: 2, lg: 3, xl: 4, xxl: 5);

  static const spacing = BreakifyFluidValue(sm: 8, lg: 24);

  static const aspectRatio = BreakifyValue<double>(sm: 1.0, md: 1.2, lg: 1.4);

  @override
  Widget build(BuildContext context) {
    final resolvedColumns = context.resolve(columns);
    final resolvedSpacing = context.resolve(spacing);
    final resolvedAspectRatio = context.resolve(aspectRatio);

    return Scaffold(
      appBar: AppBar(title: const Text('Basic Grid')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Responsive Grid',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'A grid that automatically adapts its columns, '
              'spacing and aspect ratio to the available width.',
            ),

            const SizedBox(height: 24),

            GridInfo(
              breakpoint: context.breakpoint,
              width: context.breakifyWidth,
              columns: resolvedColumns,
              spacing: resolvedSpacing,
              aspectRatio: resolvedAspectRatio,
            ),

            const SizedBox(height: 24),

            BreakifyGrid(
              columns: columns,
              spacing: spacing,
              childAspectRatio: aspectRatio,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                12,
                (index) => GridCard(index: index + 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
