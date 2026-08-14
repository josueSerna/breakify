import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';

class ListViewSpacingScreen extends StatelessWidget {
  const ListViewSpacingScreen({super.key});

  static const spacing = BreakifyFluidValue(sm: 8, lg: 24);

  @override
  Widget build(BuildContext context) {
    final resolvedSpacing = context.resolve(spacing);

    return Scaffold(
      appBar: AppBar(title: const Text('ListView Spacing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Responsive Spacing',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'BreakifyListView adjusts the spacing between items '
              'according to the available screen width.',
            ),

            const SizedBox(height: 24),

            Text(
              'Current breakpoint: '
              '${context.breakpoint.name.toUpperCase()}',
            ),

            const SizedBox(height: 8),

            Text(
              'Available width: '
              '${context.breakifyWidth.toStringAsFixed(0)} px',
            ),

            const SizedBox(height: 8),

            Text(
              'Current spacing: '
              '${resolvedSpacing.toStringAsFixed(1)} px',
            ),

            const SizedBox(height: 32),

            SizedBox(
              height: 360,
              child: BreakifyListView(
                itemCount: 10,
                spacing: spacing,
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text('Item ${index + 1}'),
                      subtitle: const Text('Responsive list item'),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'The spacing is resolved using BreakifyFluidValue, '
              'so it transitions smoothly between the defined '
              'breakpoints.',
            ),
          ],
        ),
      ),
    );
  }
}
