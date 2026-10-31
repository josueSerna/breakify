import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';

class BreakifySectionScreen extends StatelessWidget {
  const BreakifySectionScreen({super.key});

  static const _padding = BreakifyValue<EdgeInsetsGeometry>(
    sm: EdgeInsets.all(16),
    md: EdgeInsets.symmetric(horizontal: 48, vertical: 32),
    lg: EdgeInsets.symmetric(horizontal: 96, vertical: 48),
  );

  static const _minHeight = BreakifyValue<double>(sm: 160, md: 240, lg: 320);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BreakifySection')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BreakifySection(
              backgroundColor: Colors.indigo.shade50,
              alignment: Alignment.centerLeft,
              padding: const BreakifyValue(sm: EdgeInsets.all(24)),
              child: const _Label(
                title: 'Background and alignment',
                body: 'Experimental. The background spans the full width and '
                    'the content is aligned to the left.',
              ),
            ),
            BreakifySection(
              backgroundColor: Colors.teal.shade50,
              padding: _padding,
              child: _Label(
                title: 'Responsive padding',
                body: 'Padding changes with the breakpoint '
                    '(current: ${context.breakpoint.name}).',
              ),
            ),
            BreakifySection(
              backgroundColor: Colors.orange.shade50,
              minHeight: _minHeight,
              alignment: Alignment.bottomCenter,
              child: const _Label(
                title: 'Responsive minHeight',
                body: 'The minimum height is 160, 240 or 320 depending on '
                    'the breakpoint, aligned to the bottom.',
              ),
            ),
            BreakifySection(
              backgroundColor: Colors.blueGrey.shade50,
              minHeight: const BreakifyValue(sm: 130),
              childScale: 2,
              alignment: Alignment.centerRight,
              padding: const BreakifyValue(sm: EdgeInsets.all(16)),
              child: const FlutterLogo(size: 64),
            ),
            BreakifySection(
              backgroundColor: Colors.purple.shade50,
              fullViewport: true,
              child: const _Label(
                title: 'fullViewport',
                body: 'This section is at least as tall as the viewport.',
              ),
            ),
            BreakifySection(
              backgroundColor: Colors.pink.shade50,
              fullViewport: true,
              padding: _padding,
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  const _Label(
                    title: 'Content taller than the viewport',
                    body: 'The section grows with its content without '
                        'overflow.',
                  ),
                  for (var i = 1; i <= 12; i++)
                    Card(
                      child: SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: Center(child: Text('Tall content item $i')),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String title;
  final String body;

  const _Label({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(body),
      ],
    );
  }
}
