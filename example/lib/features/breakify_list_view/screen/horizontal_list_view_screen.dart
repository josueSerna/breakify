import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';

class HorizontalListViewScreen extends StatefulWidget {
  const HorizontalListViewScreen({super.key});

  @override
  State<HorizontalListViewScreen> createState() =>
      _HorizontalListViewScreenState();
}

class _HorizontalListViewScreenState extends State<HorizontalListViewScreen> {
  static const spacing = BreakifyFluidValue(sm: 8, lg: 24);

  final _listController = ScrollController();

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resolvedSpacing = context.resolve(spacing);

    return Scaffold(
      appBar: AppBar(title: const Text('Horizontal ListView')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Horizontal Scroll',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'BreakifyListView can scroll horizontally while '
              'maintaining responsive spacing between items.',
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
              height: 160,
              child: Scrollbar(
                controller: _listController,
                thumbVisibility: true,
                child: BreakifyListView(
                  controller: _listController,
                  itemCount: 10,
                  spacing: spacing,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 140,
                      child: Card(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(child: Text('${index + 1}')),
                              const SizedBox(height: 8),
                              Text('Item ${index + 1}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'The list changes its spacing responsively while '
              'scrolling horizontally through its items.',
            ),
          ],
        ),
      ),
    );
  }
}
