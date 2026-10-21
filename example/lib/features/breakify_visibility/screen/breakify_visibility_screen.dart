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
            const SizedBox(height: 32),
            const Text(
              'Global and local mode',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Global mode uses the screen width. Local mode uses '
              'the width available to the widget.',
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'A 360 px local area',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    BreakifyVisibility(
                      minBreakpoint: BreakifyBreakpoint.lg,
                      mode: BreakifyVisibilityMode.global,
                      replacement: const VisibilityMessage(
                        text: 'Global: hidden below LG',
                      ),
                      child: const VisibilityMessage(
                        text: 'Global: visible from LG',
                      ),
                    ),
                    const SizedBox(height: 12),
                    BreakifyVisibility(
                      minBreakpoint: BreakifyBreakpoint.lg,
                      mode: BreakifyVisibilityMode.local,
                      replacement: const VisibilityMessage(
                        text: 'Local: hidden below LG',
                      ),
                      child: const VisibilityMessage(
                        text: 'Local: visible from LG',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
