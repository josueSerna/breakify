import 'package:breakify/breakify.dart';
import 'package:example/features/breakify_grid/widgets/equal_height_card.dart';
import 'package:flutter/material.dart';

class EqualHeightResponsiveGridScreen extends StatelessWidget {
  const EqualHeightResponsiveGridScreen({super.key});

  static const _cards = <EqualHeightCard>[
    EqualHeightCard(
      title: 'Short',
      description: 'A brief description.',
      icon: Icons.bolt,
      color: Colors.indigo,
    ),
    EqualHeightCard(
      title: 'A long title that wraps over several lines of text',
      description:
          'This card has a considerably longer description. It determines '
          'the height of its row, and the remaining cards stretch to match '
          'it without clipping or overflowing any content.',
      icon: Icons.article,
      color: Colors.teal,
    ),
    EqualHeightCard(
      title: 'Spacer',
      description: 'A Spacer pushes the button to the bottom.',
      icon: Icons.vertical_align_bottom,
      color: Colors.orange,
      layout: EqualHeightCardLayout.spacer,
    ),
    EqualHeightCard(
      title: 'Expanded',
      description:
          'The description is wrapped in Expanded, so it takes all the '
          'remaining height once the row height is known.',
      icon: Icons.open_in_full,
      color: Colors.purple,
      layout: EqualHeightCardLayout.expanded,
    ),
    EqualHeightCard(
      title: 'Incomplete row',
      description: 'The last row may not be complete.',
      icon: Icons.grid_view,
      color: Colors.pink,
      layout: EqualHeightCardLayout.spacer,
    ),
  ];

  static final _plainCards = [
    for (final card in _cards)
      EqualHeightCard(
        title: card.title,
        description: card.description,
        icon: card.icon,
        color: card.color,
      ),
  ];

  Widget _grid(BreakifyHeightMode? mode) {
    return BreakifyResponsiveGrid(
      minItemWidth: 260,
      maxColumns: 3,
      spacing: 16,
      heightMode: mode,
      childAspectRatio: 0.4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: mode == BreakifyHeightMode.natural ? _plainCards : _cards,
    );
  }

  @override
  Widget build(BuildContext context) {
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
              'Columns are calculated from the available width, and cards '
              'in the same row share the height of the tallest one.',
            ),
            const SizedBox(height: 24),
            const Text(
              'BreakifyHeightMode.equal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _grid(BreakifyHeightMode.equal),
            const SizedBox(height: 32),
            const Text(
              'BreakifyHeightMode.equalInRow',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _grid(BreakifyHeightMode.equalInRow),
            const SizedBox(height: 32),
            const Text(
              'BreakifyHeightMode.natural (no Spacer/Expanded)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _grid(BreakifyHeightMode.natural),
            const SizedBox(height: 32),
            const Text(
              'heightMode: null (childAspectRatio)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _grid(null),
          ],
        ),
      ),
    );
  }
}
