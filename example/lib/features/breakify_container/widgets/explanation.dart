import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';

class Explanation extends StatelessWidget {
  const Explanation({super.key});

  @override
  Widget build(BuildContext context) {
    return BreakifyContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How it works',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'BreakifyContainer limits the width of its content on '
              'larger screens while keeping it centered.',
            ),
            const SizedBox(height: 24),
            const Text(
              'This example also uses BreakifyValue for discrete '
              'responsive padding and BreakifyFluidValue for a '
              'smoothly changing border radius.',
            ),
          ],
        ),
      ),
    );
  }
}
