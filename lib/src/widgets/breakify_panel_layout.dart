import 'package:breakify/breakify.dart';
import 'package:breakify/src/values/breakify_resolvable.dart';
import 'package:breakify/src/widgets/internal/breakify_gap_children.dart';
import 'package:flutter/widgets.dart';

/// A responsive layout with a main panel and secondary panels.
///
/// Below [breakpoint], the main panel and secondary panels
/// are arranged vertically.
///
/// From [breakpoint] onward, the main panel occupies one side
/// and the secondary panels are arranged vertically on the other.
///
/// The horizontal layout uses [mainFlex] and [secondaryFlex]
/// to control the width ratio between both areas.
///
/// Requires a [BreakifyScope] ancestor unless [breakpoints]
/// is provided.
class BreakifyPanelLayout extends StatelessWidget {
  /// The main content panel.
  final Widget mainPanel;

  /// Secondary panels displayed alongside or below the main panel.
  final List<Widget> secondaryPanels;

  /// Breakpoint at which the layout switches to a horizontal arrangement.
  final BreakifyBreakpoint breakpoint;

  /// Spacing between panels, resolved responsively.
  final BreakifyResolvable<double> spacing;

  /// Relative width of the main panel in horizontal mode.
  final int mainFlex;

  /// Relative width of the secondary panels area in horizontal mode.
  final int secondaryFlex;

  /// Alignment of panel contents along the cross axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// Breakpoint configuration used to resolve responsive values.
  ///
  /// If null, the configuration from the nearest [BreakifyScope] is used.
  final BreakifyBreakpoints? breakpoints;

  /// Creates a responsive main-and-secondary panel layout.
  const BreakifyPanelLayout({
    super.key,
    required this.mainPanel,
    required this.secondaryPanels,
    required this.breakpoint,
    required this.spacing,
    this.mainFlex = 2,
    this.secondaryFlex = 1,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
    this.breakpoints,
  })  : assert(mainFlex > 0, 'mainFlex must be greater than zero.'),
        assert(
          secondaryFlex > 0,
          'secondaryFlex must be greater than zero.',
        );

  @override
  Widget build(BuildContext context) {
    final effectiveBreakpoints = breakpoints ?? context.breakifyBreakpoints;

    return BreakifyBuilder(
      breakpoints: effectiveBreakpoints,
      builder: (context, currentBreakpoint, constraints) {
        final width = constraints.maxWidth;

        final isHorizontal = currentBreakpoint.index >= breakpoint.index &&
            width.isFinite &&
            secondaryPanels.isNotEmpty;

        final gap = spacing.resolve(
          currentBreakpoint,
          width,
          effectiveBreakpoints,
        );

        if (isHorizontal) {
          final secondaryColumn = Column(
            crossAxisAlignment: crossAxisAlignment,
            children: breakifyGapChildren(
              secondaryPanels,
              gap,
              Axis.vertical,
            ),
          );

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: breakifyGapChildren(
              [
                Expanded(
                  flex: mainFlex,
                  child: mainPanel,
                ),
                Expanded(
                  flex: secondaryFlex,
                  child: secondaryColumn,
                ),
              ],
              gap,
              Axis.horizontal,
            ),
          );
        }

        return Column(
          crossAxisAlignment: crossAxisAlignment,
          children: breakifyGapChildren(
            [
              mainPanel,
              ...secondaryPanels,
            ],
            gap,
            Axis.vertical,
          ),
        );
      },
    );
  }
}
