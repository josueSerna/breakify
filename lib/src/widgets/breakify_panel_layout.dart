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
/// In horizontal mode, [reverse] swaps the two areas so the secondary
/// panels are on the left and the main panel on the right, and
/// [secondaryDirection] chooses whether the secondary panels are stacked
/// in a [Column] (default) or placed side by side in a [Row]. Neither
/// property affects the vertical layout.
///
/// ## Example
///
/// ```dart
/// BreakifyPanelLayout(
///   breakpoint: BreakifyBreakpoint.lg,
///   spacing: const BreakifyFluidValue(sm: 12, lg: 24),
///   reverse: true,
///   secondaryDirection: Axis.horizontal,
///   mainPanel: Main(),
///   secondaryPanels: [Summary(), Actions()],
/// )
/// ```
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
  ///
  /// When [secondaryDirection] is [Axis.horizontal] in horizontal mode,
  /// [CrossAxisAlignment.stretch] is applied as
  /// [CrossAxisAlignment.start] for the secondary [Row], because its
  /// height is unbounded.
  final CrossAxisAlignment crossAxisAlignment;

  /// Whether to swap the position of the main panel and the secondary
  /// panels in horizontal mode.
  ///
  /// When `false` (default), the main panel is on the left and the
  /// secondary panels on the right. When `true`, the secondary panels are
  /// on the left and the main panel on the right.
  ///
  /// Only the two areas are swapped: the order of [secondaryPanels] is
  /// kept, and [mainFlex] and [secondaryFlex] still apply to the main
  /// panel and the secondary area respectively.
  ///
  /// Has no effect in vertical mode.
  final bool reverse;

  /// Direction in which [secondaryPanels] are arranged in horizontal mode.
  ///
  /// Defaults to [Axis.vertical], which stacks them in a [Column].
  /// With [Axis.horizontal] they are placed in a [Row] and each one
  /// receives an equal share of the width of the secondary area
  /// (wrapped in [Expanded]), separated by the resolved [spacing].
  ///
  /// Has no effect in vertical mode, where the secondary panels always
  /// appear below the main panel.
  final Axis secondaryDirection;

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
    this.reverse = false,
    this.secondaryDirection = Axis.vertical,
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
          final Widget secondaryArea = secondaryDirection == Axis.horizontal
              ? Row(
                  crossAxisAlignment:
                      crossAxisAlignment == CrossAxisAlignment.stretch
                          ? CrossAxisAlignment.start
                          : crossAxisAlignment,
                  children: breakifyGapChildren(
                    [
                      for (final panel in secondaryPanels)
                        Expanded(child: panel),
                    ],
                    gap,
                    Axis.horizontal,
                  ),
                )
              : Column(
                  crossAxisAlignment: crossAxisAlignment,
                  children: breakifyGapChildren(
                    secondaryPanels,
                    gap,
                    Axis.vertical,
                  ),
                );

          final areas = [
            Expanded(
              flex: mainFlex,
              child: mainPanel,
            ),
            Expanded(
              flex: secondaryFlex,
              child: secondaryArea,
            ),
          ];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: breakifyGapChildren(
              reverse ? areas.reversed.toList() : areas,
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
