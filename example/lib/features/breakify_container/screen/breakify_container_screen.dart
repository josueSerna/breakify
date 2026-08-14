import 'package:breakify/breakify.dart';
import 'package:example/features/breakify_container/widgets/explanation.dart';
import 'package:example/features/breakify_container/widgets/header.dart';
import 'package:example/features/breakify_container/widgets/info_row.dart';
import 'package:flutter/material.dart';

class BreakifyContainerScreen extends StatelessWidget {
  const BreakifyContainerScreen({super.key});

  static const maxWidth = BreakifyValue<double>(
    sm: 600,
    md: 768,
    lg: 1024,
    xl: 1200,
    xxl: 1400,
  );

  static const padding = BreakifyValue<EdgeInsets>(
    sm: EdgeInsets.all(16),
    md: EdgeInsets.all(24),
    lg: EdgeInsets.all(32),
    xl: EdgeInsets.all(40),
  );

  static const radius = BreakifyFluidValue(sm: 8, lg: 20);

  @override
  Widget build(BuildContext context) {
    final resolvedRadius = context.resolve(radius);

    return Scaffold(
      appBar: AppBar(title: const Text('BreakifyContainer')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              breakpoint: context.breakpoint,
              width: context.breakifyWidth,
            ),
            const SizedBox(height: 32),

            BreakifyContainer(
              maxWidth: maxWidth,
              padding: padding,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(resolvedRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BreakifyContainer',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'A responsive container that limits the maximum '
                      'width of your content and keeps it centered.',
                    ),

                    const SizedBox(height: 32),

                    InfoRow(
                      label: 'Breakpoint',
                      value: context.breakpoint.name.toUpperCase(),
                    ),

                    InfoRow(
                      label: 'Available width',
                      value: '${context.breakifyWidth.toStringAsFixed(0)} px',
                    ),

                    InfoRow(
                      label: 'Max width',
                      value: _resolveMaxWidth(context),
                    ),

                    InfoRow(
                      label: 'Border radius',
                      value: '${resolvedRadius.toStringAsFixed(1)} px',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            BreakifyContainer(
              padding: const BreakifyValue(
                sm: EdgeInsets.all(16),
                md: EdgeInsets.all(20),
                lg: EdgeInsets.all(24),
              ),
              child: const Explanation(),
            ),
          ],
        ),
      ),
    );
  }

  String _resolveMaxWidth(BuildContext context) {
    final value = context.resolve(maxWidth);

    return '${value.toStringAsFixed(0)} px';
  }
}
