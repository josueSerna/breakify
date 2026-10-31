import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';

class PanelLayoutOptionsScreen extends StatelessWidget {
  const PanelLayoutOptionsScreen({super.key});

  static const spacing = BreakifyFluidValue(sm: 12, lg: 24);

  @override
  Widget build(BuildContext context) {
    final isHorizontal =
        context.breakpoint.index >= BreakifyBreakpoint.lg.index;

    return Scaffold(
      appBar: AppBar(title: const Text('reverse & secondaryDirection')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'reverse & secondaryDirection',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Both properties only affect the horizontal layout, which is '
              'used from the LG breakpoint onward. Below LG every variant '
              'looks the same: the main panel followed by the secondary '
              'panels, stacked vertically.',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                Text(
                  'Breakpoint: ${context.breakpoint.name.toUpperCase()}',
                ),
                Text(
                  'Width: ${context.breakifyWidth.toStringAsFixed(0)} px',
                ),
                Text('Mode: ${isHorizontal ? 'horizontal' : 'vertical'}'),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Legend: blue = main panel, green = secondary panels '
              '(numbered to show that their order is never reversed).',
            ),
            const SizedBox(height: 32),
            const _Variant(
              title: '1. Default',
              description: 'reverse: false, secondaryDirection: '
                  'Axis.vertical. Main panel on the left, secondary panels '
                  'stacked on the right.',
              code: 'BreakifyPanelLayout(\n'
                  '  breakpoint: BreakifyBreakpoint.lg,\n'
                  '  ...\n'
                  ')',
            ),
            const _Variant(
              title: '2. reverse: true',
              description: 'The secondary panels move to the left and the '
                  'main panel to the right. The order of the secondary '
                  'panels (1, 2, 3) is kept.',
              code: 'BreakifyPanelLayout(\n'
                  '  reverse: true,\n'
                  '  ...\n'
                  ')',
              reverse: true,
            ),
            const _Variant(
              title: '3. secondaryDirection: Axis.horizontal',
              description: 'The secondary panels are placed side by side in '
                  'a Row, each taking an equal share of the secondary area.',
              code: 'BreakifyPanelLayout(\n'
                  '  secondaryDirection: Axis.horizontal,\n'
                  '  ...\n'
                  ')',
              secondaryDirection: Axis.horizontal,
            ),
            const _Variant(
              title: '4. reverse + secondaryDirection',
              description: 'Secondary panels side by side on the left and '
                  'the main panel on the right.',
              code: 'BreakifyPanelLayout(\n'
                  '  reverse: true,\n'
                  '  secondaryDirection: Axis.horizontal,\n'
                  '  ...\n'
                  ')',
              reverse: true,
              secondaryDirection: Axis.horizontal,
            ),
          ],
        ),
      ),
    );
  }
}

class _Variant extends StatelessWidget {
  final String title;
  final String description;
  final String code;
  final bool reverse;
  final Axis secondaryDirection;

  const _Variant({
    required this.title,
    required this.description,
    required this.code,
    this.reverse = false,
    this.secondaryDirection = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(description),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              code,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
          BreakifyPanelLayout(
            breakpoint: BreakifyBreakpoint.lg,
            spacing: PanelLayoutOptionsScreen.spacing,
            mainFlex: 2,
            secondaryFlex: 1,
            reverse: reverse,
            secondaryDirection: secondaryDirection,
            mainPanel: const _Panel(
              title: 'Main panel',
              color: Colors.blue,
              height: 240,
            ),
            secondaryPanels: const [
              _Panel(title: 'Secondary 1', color: Colors.green, height: 110),
              _Panel(title: 'Secondary 2', color: Colors.teal, height: 110),
              _Panel(
                  title: 'Secondary 3', color: Colors.lightGreen, height: 110),
            ],
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final String title;
  final Color color;
  final double height;

  const _Panel({
    required this.title,
    required this.color,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
