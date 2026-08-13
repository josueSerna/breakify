import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final BreakifyBreakpoint breakpoint;
  final double width;

  const Header({super.key, required this.breakpoint, required this.width});

  static const fontSize = BreakifyFluidValue(sm: 15, md: 25, lg: 35);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: BreakifyContainer(
        child: Column(
          children: [
            Text(
              'Container',
              style: TextStyle(
                fontSize: context.resolve(fontSize),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Responsive content container',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              '${breakpoint.name.toUpperCase()} - '
              '${width.toStringAsFixed(0)} px',
            ),
          ],
        ),
      ),
    );
  }
}
