import 'package:example/features/breakify_adaptative_layout/screen/basic_adaptative_screen.dart';
import 'package:example/features/breakify_adaptative_layout/screen/distribute_adaptative_screen.dart';
import 'package:example/presentation/widgets/example_card.dart';
import 'package:flutter/material.dart';

class BreakifyAdaptativLayoutScreen extends StatelessWidget {
  const BreakifyAdaptativLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BreakifyAdaptativeLayout')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'BreakifyAdaptativeLayout',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Switch between vertical and horizontal layouts '
            'depending on the current breakpoint.',
          ),
          const SizedBox(height: 32),
          ExampleCard(
            title: 'Basic Layout',
            description:
                'Switches between Column and Row at a selected breakpoint.',
            icon: Icons.view_agenda,
            page: BasicAdaptativeScreen(),
          ),

          ExampleCard(
            title: 'Distribute Evenly',
            description:
                'Makes children share the available horizontal space equally.',
            icon: Icons.view_column,
            page: DistributeAdaptativeScreen(),
          ),
        ],
      ),
    );
  }
}
