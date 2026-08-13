import 'package:example/features/breakify_grid/screen/basic_grid_screen.dart';
import 'package:example/features/breakify_grid/screen/equal_height_grid_screen.dart';
import 'package:example/features/breakify_grid/widgets/grid_example_card.dart';
import 'package:flutter/material.dart';

class BreakifyGridScreen extends StatelessWidget {
  const BreakifyGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BreakifyGrid')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'BreakifyGrid',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          const Text(
            'Explore the different ways BreakifyGrid '
            'can adapt to responsive layouts.',
          ),

          const SizedBox(height: 32),

          GridExampleCard(
            title: 'Basic Grid',
            description: 'Responsive columns, spacing and child aspect ratio.',
            icon: Icons.grid_view,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BasicGridScreen()),
              );
            },
          ),

          GridExampleCard(
            title: 'Equal Height',
            description:
                'Makes all items in the same row have the height '
                'of the tallest item.',
            icon: Icons.height,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EqualHeightGridScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
