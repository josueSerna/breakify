import 'package:breakify/breakify.dart';
import 'package:example/features/breakify_visibility/widgets/visibility_message.dart';
import 'package:flutter/material.dart';

class BreakifyVisibilityScreen extends StatelessWidget {
  const BreakifyVisibilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final breakpoint = context.breakpoint;

    return Scaffold(
      appBar: AppBar(title: const Text('BreakifyVisibility')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'BreakifyVisibility',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Shows or hides widgets based on the current '
              'responsive breakpoint.',
            ),

            const SizedBox(height: 24),

            Text(
              'Current breakpoint: '
              '${breakpoint.name.toUpperCase()}',
            ),

            Text(
              'Available width: '
              '${context.breakifyWidth.toStringAsFixed(0)} px',
            ),

            const SizedBox(height: 32),

            const Text(
              'Minimum breakpoint',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'The widget becomes visible from the specified '
              'breakpoint and remains visible above it.',
            ),

            const SizedBox(height: 16),

            BreakifyVisibility(
              minBreakpoint: BreakifyBreakpoint.lg,
              replacement: const VisibilityMessage(text: 'Hidden below LG'),
              child: const VisibilityMessage(text: 'Visible from LG upward'),
            ),

            const SizedBox(height: 32),

            const Text(
              'Maximum breakpoint',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'The widget remains visible up to the specified '
              'breakpoint and is hidden above it.',
            ),

            const SizedBox(height: 16),

            BreakifyVisibility(
              maxBreakpoint: BreakifyBreakpoint.md,
              replacement: const VisibilityMessage(text: 'Hidden above MD'),
              child: const VisibilityMessage(text: 'Visible up to MD'),
            ),

            const SizedBox(height: 32),

            const Text(
              'Specific breakpoints',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'Use BreakifyVisibility.only when the widget '
              'should only appear at specific breakpoints.',
            ),

            const SizedBox(height: 16),

            BreakifyVisibility.only(
              visibleIn: {BreakifyBreakpoint.sm, BreakifyBreakpoint.xl},
              replacement: const VisibilityMessage(
                text: 'Hidden on this breakpoint',
              ),
              child: const VisibilityMessage(text: 'Visible only on SM and XL'),
            ),

            const SizedBox(height: 32),

            const Text(
              'Replacement',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'A replacement widget can be displayed when '
              'the original child is hidden.',
            ),

            const SizedBox(height: 16),

            BreakifyVisibility(
              minBreakpoint: BreakifyBreakpoint.lg,
              replacement: const VisibilityMessage(
                text: 'Mobile / tablet content',
              ),
              child: const VisibilityMessage(text: 'Desktop content'),
            ),
          ],
        ),
      ),
    );
  }
}
