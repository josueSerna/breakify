import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';

class BreakifyPanelLayoutScreen extends StatelessWidget {
  const BreakifyPanelLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BreakifyPanelLayout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BreakifyPanelLayout',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Places a main panel beside a vertical stack of secondary '
              'panels from the selected breakpoint onward.',
            ),
            const SizedBox(height: 24),
            Text(
              'Current breakpoint: '
              '${context.breakpoint.name.toUpperCase()}',
            ),
            Text(
              'Available width: '
              '${context.breakifyWidth.toStringAsFixed(0)} px',
            ),
            const SizedBox(height: 24),
            BreakifyPanelLayout(
              breakpoint: BreakifyBreakpoint.lg,
              spacing: const BreakifyFluidValue(sm: 12, lg: 24),
              mainFlex: 2,
              secondaryFlex: 1,
              mainPanel: _DemoPanel(
                title: 'Main panel',
                color: Theme.of(context).colorScheme.primaryContainer,
                height: 260,
              ),
              secondaryPanels: [
                _DemoPanel(
                  title: 'Summary',
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  height: 120,
                ),
                _DemoPanel(
                  title: 'Actions',
                  color: Theme.of(context).colorScheme.tertiaryContainer,
                  height: 120,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoPanel extends StatelessWidget {
  final String title;
  final Color color;
  final double height;

  const _DemoPanel({
    required this.title,
    required this.color,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
