import 'package:flutter/material.dart';

class GridCard extends StatelessWidget {
  final int index;

  const GridCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Center(
          child: Text(
            'Item ${index.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
