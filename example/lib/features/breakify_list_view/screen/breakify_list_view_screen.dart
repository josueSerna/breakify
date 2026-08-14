import 'package:breakify/breakify.dart';
import 'package:example/features/breakify_list_view/screen/horizontal_list_view_screen.dart';
import 'package:example/features/breakify_list_view/screen/list_view_spacing_screen.dart';
import 'package:example/features/breakify_list_view/screen/separator_list_view_screen.dart';
import 'package:example/presentation/widgets/example_card.dart';
import 'package:flutter/material.dart';

class BreakifyListViewScreen extends StatelessWidget {
  const BreakifyListViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BreakifyListView')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BreakifyListView',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'A responsive list view with spacing and '
              'custom separator support.',
            ),

            const SizedBox(height: 24),

            Text(
              'Current breakpoint: '
              '${context.breakpoint.name.toUpperCase()}',
            ),

            const SizedBox(height: 32),

            ExampleCard(
              title: 'Spacing ListView',
              description:
                  'Adjusts the spacing between list items responsively '
                  'as the available width changes.',
              icon: Icons.format_list_bulleted,
              page: ListViewSpacingScreen(),
            ),

            ExampleCard(
              title: 'Separator ListView',
              description:
                  'Replaces responsive spacing with a custom separator '
                  'between consecutive list items.',
              icon: Icons.format_list_bulleted,
              page: SeparatorListViewScreen(),
            ),

            ExampleCard(
              title: 'Horizontal ListView',
              description:
                  'Creates a horizontally scrolling list while '
                  'maintaining responsive spacing between items.',
              icon: Icons.view_carousel,
              page: HorizontalListViewScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
