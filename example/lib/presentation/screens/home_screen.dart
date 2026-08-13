import 'package:breakify/breakify.dart';
import 'package:example/features/breakify_container/screen/breakify_container_screen.dart';
import 'package:example/features/breakify_grid/screen/breakify_grid_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/example_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BreakifyDebugBanner(
      child: Scaffold(
        appBar: AppBar(title: const Text('Breakify Examples')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: const [
            Text(
              'Breakify',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            Text(
              'Explore the responsive widgets and utilities '
              'provided by Breakify.',
            ),

            SizedBox(height: 32),

            ExampleCard(
              title: 'BreakifyContainer',
              description:
                  'Constrains the maximum width of your content '
                  'and keeps it centered.',
              icon: Icons.crop_square,
              page: BreakifyContainerScreen(),
            ),

            ExampleCard(
              title: 'BreakifyGrid',
              description:
                  'Creates responsive grids that adapt to '
                  'the available space.',
              icon: Icons.grid_view,
              page: BreakifyGridScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
