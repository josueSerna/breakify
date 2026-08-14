import 'package:breakify/breakify.dart';
import 'package:example/features/breakify_grid/widgets/demo_card.dart';
import 'package:example/features/breakify_grid/widgets/grid_info.dart';
import 'package:flutter/material.dart';

class EqualHeightGridScreen extends StatelessWidget {
  const EqualHeightGridScreen({super.key});

  static const columns = BreakifyValue<int>(sm: 1, md: 3, lg: 4);

  static const spacing = BreakifyFluidValue(sm: 8, lg: 20);

  @override
  Widget build(BuildContext context) {
    final resolvedColumns = context.resolve(columns);
    final resolvedSpacing = context.resolve(spacing);
    return Scaffold(
      appBar: AppBar(title: const Text('Equal Height')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Equal Height',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Items in the same row automatically share '
              'the height of the tallest item.',
            ),

            const SizedBox(height: 24),

            GridInfo(
              breakpoint: context.breakpoint,
              width: context.breakifyWidth,
              columns: resolvedColumns,
              spacing: resolvedSpacing,
            ),

            const SizedBox(height: 24),

            BreakifyGrid(
              columns: columns,
              spacing: spacing,
              equalHeight: true,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                DemoCard(title: 'Short content', description: 'A short card.'),
                DemoCard(
                  title: 'Medium content',
                  description:
                      'This card contains a little more content '
                      'to demonstrate the equal height behavior.',
                ),
                DemoCard(
                  title: 'Tall content',
                  description:
                      'This is the tallest card in the row. '
                      'Its height determines the height of '
                      'the other cards in the same row.',
                ),
                DemoCard(
                  title: 'Another card',
                  description: 'This card is shorter.',
                ),
                DemoCard(
                  title: 'More content',
                  description:
                      'This card contains enough text to make '
                      'its intrinsic height different.',
                ),
                DemoCard(
                  title: 'Last card',
                  description: 'Another short card.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
