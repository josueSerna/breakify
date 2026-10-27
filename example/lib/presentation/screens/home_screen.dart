import 'package:breakify/breakify.dart';
import 'package:example/features/breakify_adaptative_layout/screen/breakify_adaptativ_layout_screen.dart';
import 'package:example/features/breakify_container/screen/breakify_container_screen.dart';
import 'package:example/features/breakify_grid/screen/breakify_grid_screen.dart';
import 'package:example/features/breakify_list_view/screen/breakify_list_view_screen.dart';
import 'package:example/features/breakify_panel_layout/screen/breakify_panel_layout_screen.dart';
import 'package:example/features/breakify_responsive_grid/screen/breakify_responsive_grid_screen.dart';
import 'package:example/features/breakify_visibility/screen/breakify_visibility_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/example_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Breakify Examples')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Breakify',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore the responsive widgets and utilities '
            'provided by Breakify.',
          ),
          const SizedBox(height: 24),
          const _BreakpointStatusCard(),
          const SizedBox(height: 16),
          const _LocalBreakpointProbe(),
          const SizedBox(height: 32),
          ExampleCard(
            title: 'BreakifyContainer',
            description: 'Constrains the maximum width of your content '
                'and keeps it centered.',
            icon: Icons.crop_square,
            page: BreakifyContainerScreen(),
          ),
          ExampleCard(
            title: 'BreakifyGrid',
            description: 'Creates responsive grids that adapt to '
                'the available space.',
            icon: Icons.grid_view,
            page: BreakifyGridScreen(),
          ),
          ExampleCard(
            title: 'BreakifyResponsiveGrid',
            description: 'Automatically calculates the columns that fit '
                'the available width.',
            icon: Icons.grid_4x4,
            page: BreakifyResponsiveGridScreen(),
          ),
          ExampleCard(
            title: 'BreakifyAdaptativeLayout',
            description: 'Automatically switches between a Column and Row '
                'based on the current breakpoint.',
            icon: Icons.view_agenda,
            page: BreakifyAdaptativLayoutScreen(),
          ),
          ExampleCard(
            title: 'BreakifyPanelLayout',
            description: 'Places a main panel beside stacked secondary panels '
                'at a selected breakpoint.',
            icon: Icons.dashboard,
            page: BreakifyPanelLayoutScreen(),
          ),
          ExampleCard(
            title: 'BreakifyListView',
            description: 'Builds a responsive and scrollable list with '
                'configurable spacing, separators and scroll direction.',
            icon: Icons.list,
            page: BreakifyListViewScreen(),
          ),
          ExampleCard(
            title: 'BreakifyVisibility',
            description:
                'Shows or hides widgets based on responsive breakpoints '
                'using ranges or specific breakpoint values.',
            icon: Icons.visibility,
            page: BreakifyVisibilityScreen(),
          ),
        ],
      ),
    );
  }
}

class _BreakpointStatusCard extends StatelessWidget {
  const _BreakpointStatusCard();

  @override
  Widget build(BuildContext context) {
    final breakpoint = context.breakpoint;
    final breakpoints = context.breakifyBreakpoints;
    final entries = <(BreakifyBreakpoint, double)>[
      (BreakifyBreakpoint.sm, breakpoints.sm),
      (BreakifyBreakpoint.md, breakpoints.md),
      (BreakifyBreakpoint.lg, breakpoints.lg),
      (BreakifyBreakpoint.xl, breakpoints.xl),
      (BreakifyBreakpoint.xxl, breakpoints.xxl),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Breakpoint status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Global width: ${context.breakifyWidth.round()} px · '
              'Current: ${breakpoint.name}',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (name, threshold) in entries)
                  Chip(
                    label: Text('${name.name} ≥ ${threshold.round()}'),
                    backgroundColor: name == breakpoint
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Resize the window and verify that the highlighted '
              'breakpoint changes at its exact threshold.',
            ),
          ],
        ),
      ),
    );
  }
}

class _LocalBreakpointProbe extends StatelessWidget {
  const _LocalBreakpointProbe();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Local breakpoint probe',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'The global banner above follows the window. This banner is '
              'inside a 720 px container and follows that local width.',
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 720,
                height: 72,
                child: BreakifyDebugBanner(
                  corner: BreakifyBannerCorner.topLeft,
                  child: Container(
                    alignment: Alignment.center,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: const Text('Local container: 720 px'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
