import 'package:breakify/breakify.dart';
import 'package:example/features/breakify_adaptative_layout/widgets/action_card.dart';
import 'package:flutter/material.dart';

class DistributeAdaptativeScreen extends StatelessWidget {
  const DistributeAdaptativeScreen({super.key});

  static const spacing = BreakifyFluidValue(sm: 8, lg: 24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Distribute Evenly')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribute Evenly',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'When enabled, every child expands to share '
              'the available horizontal space.',
            ),

            const SizedBox(height: 24),
            Text(
              'Current breakpoint: '
              '${context.breakpoint.name.toUpperCase()}',
            ),

            const SizedBox(height: 32),

            BreakifyAdaptativeLayout(
              breakpoint: BreakifyBreakpoint.md,
              spacing: spacing,
              distributeEvenly: true,
              children: const [
                ActionCard(title: 'Home', icon: Icons.home),
                ActionCard(title: 'Profile', icon: Icons.person),
                ActionCard(title: 'Settings', icon: Icons.settings),
              ],
            ),
            const SizedBox(height: 32),

            const Text(
              'When enabled, vertical children stretch to fill '
              'the available horizontal space.',
            ),

            const SizedBox(height: 24),

            BreakifyAdaptativeLayout(
              breakpoint: BreakifyBreakpoint.md,
              spacing: spacing,
              stretchChildren: true,
              children: const [
                ActionCard(title: 'Home', icon: Icons.home),
                ActionCard(title: 'Profile', icon: Icons.person),
                ActionCard(title: 'Settings', icon: Icons.settings),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
