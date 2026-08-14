import 'package:breakify/breakify.dart';
import 'package:example/features/breakify_grid/widgets/grid_card.dart';
import 'package:flutter/material.dart';

class HorizontalGridScreen extends StatefulWidget {
  const HorizontalGridScreen({super.key});

  @override
  State<HorizontalGridScreen> createState() => _HorizontalGridScreenState();
}

class _HorizontalGridScreenState extends State<HorizontalGridScreen> {
  static const columns = BreakifyValue<int>(sm: 1, md: 2, lg: 3);

  static const spacing = BreakifyFluidValue(sm: 8, lg: 20);

  static const childAspectRatio = BreakifyValue<double>(
    sm: 1.2,
    md: 1.4,
    lg: 1.6,
  );

  static const gridHeight = BreakifyValue<double>(sm: 280, md: 360, lg: 460);

  final _gridController = ScrollController();

  @override
  void dispose() {
    _gridController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resolvedColumns = context.resolve(columns);
    final resolvedSpacing = context.resolve(spacing);
    final resolvedHeight = context.resolve(gridHeight);

    return Scaffold(
      appBar: AppBar(title: const Text('Horizontal Grid')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Horizontal Grid',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'BreakifyGrid can scroll horizontally while '
              'keeping its layout responsive.',
            ),

            const SizedBox(height: 24),

            Text(
              'Current breakpoint: '
              '${context.breakpoint.name.toUpperCase()}',
            ),

            const SizedBox(height: 8),

            Text(
              'Rows: $resolvedColumns  •  '
              'Spacing: ${resolvedSpacing.toStringAsFixed(0)} px',
            ),

            const SizedBox(height: 32),

            SizedBox(
              height: resolvedHeight,
              child: Scrollbar(
                controller: _gridController,
                thumbVisibility: true,
                child: BreakifyGrid(
                  controller: _gridController,
                  columns: columns,
                  spacing: spacing,
                  childAspectRatio: childAspectRatio,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    20,
                    (index) => GridCard(index: index + 1),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'The grid scrolls horizontally while the number '
              'of rows adapts to the current breakpoint.',
            ),
          ],
        ),
      ),
    );
  }
}
