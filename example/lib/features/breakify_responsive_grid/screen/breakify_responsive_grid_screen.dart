import 'package:example/features/breakify_responsive_grid/screen/basic_responsive_grid_screen.dart';
import 'package:example/features/breakify_responsive_grid/screen/equal_height_responsive_grid_screen.dart';
import 'package:example/presentation/widgets/example_card.dart';
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
          ExampleCard(
            title: 'Basic',
            description:
                'Adaptive columns, maximum columns and unbounded width.',
            icon: Icons.grid_view,
            page: BasicResponsiveGridScreen(),
          ),
          ExampleCard(
            title: 'Equal Height',
            description:
                'Cards in the same row share the height of the tallest one, '
                'with Spacer and Expanded.',
            icon: Icons.height,
            page: EqualHeightResponsiveGridScreen(),
          ),
        ],
      ),
    );
  }
}
