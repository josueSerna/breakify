import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';

class SeparatorListViewScreen extends StatelessWidget {
  const SeparatorListViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView Separator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Custom Separator',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'BreakifyListView allows you to replace the default '
              'responsive spacing with a custom separator.',
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

            const SizedBox(height: 32),

            SizedBox(
              height: 400,
              child: BreakifyListView(
                itemCount: 10,
                separator: const Divider(),
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text('Item ${index + 1}'),
                    subtitle: const Text('Custom separator'),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'When a separator is provided, the responsive '
              'spacing value is ignored and the separator is '
              'displayed between each item.',
            ),
          ],
        ),
      ),
    );
  }
}
