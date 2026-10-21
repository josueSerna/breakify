import 'package:flutter/widgets.dart';

import '../breakpoints/breakify_breakpoints.dart';
import '../scope/breakify_scope.dart';

/// Defines how BreakifyVisibility determines the active breakpoint.
enum BreakifyVisibilityMode {
  /// Uses the width provided by the nearest BreakifyScope.
  ///
  /// This preserves the traditional BreakifyVisibility behavior.
  global,

  /// Uses the width available to this widget.
  ///
  /// If the local width is unbounded, falls back to the global width.
  local,
}

/// Shows or hides its child based on the current breakpoint.
///
/// By default, visibility is resolved using the global width provided
/// by [BreakifyScope]. Set [mode] to [BreakifyVisibilityMode.local]
/// to use the width available to this widget instead.
///
/// Use [minBreakpoint] to show the child from a breakpoint upward,
/// or [maxBreakpoint] to show it up to a breakpoint. Both can be
/// combined to define a range.
///
/// ```dart
/// // Visible from lg upward, using the global screen width.
/// BreakifyVisibility(
///   minBreakpoint: BreakifyBreakpoint.lg,
///   child: Sidebar(),
/// )
///
/// // Visible from lg upward, using the local available width.
/// BreakifyVisibility(
///   minBreakpoint: BreakifyBreakpoint.lg,
///   mode: BreakifyVisibilityMode.local,
///   child: Sidebar(),
/// )
/// ```
///
/// For non-contiguous breakpoints, use [BreakifyVisibility.only]:
///
/// ```dart
/// BreakifyVisibility.only(
///   visibleIn: {BreakifyBreakpoint.sm, BreakifyBreakpoint.xl},
///   child: SomeWidget(),
/// )
/// ```
///
/// When hidden, the child is not built and no space is reserved.
/// Use Flutter's [Visibility] if you need to preserve state or layout space.
///
/// Requires a [BreakifyScope] ancestor unless [breakpoints] is provided.
class BreakifyVisibility extends StatelessWidget {
  /// Widget displayed when the current breakpoint is visible.
  final Widget child;

  /// Widget displayed when the child is hidden.
  ///
  /// If null, an empty widget is rendered instead.
  final Widget? replacement;

  /// Lowest breakpoint (inclusive) where the child is visible.
  ///
  /// Ignored when [visibleIn] is provided.
  final BreakifyBreakpoint? minBreakpoint;

  /// Highest breakpoint (inclusive) where the child remains visible.
  ///
  /// Ignored when [visibleIn] is provided.
  final BreakifyBreakpoint? maxBreakpoint;

  /// Explicit breakpoints where the child is visible.
  ///
  /// When provided, [minBreakpoint] and [maxBreakpoint] are ignored.
  final Set<BreakifyBreakpoint>? visibleIn;

  /// Breakpoint configuration used to determine visibility.
  ///
  /// If null, the nearest [BreakifyScope] configuration is used.
  final BreakifyBreakpoints? breakpoints;

  /// Determines whether visibility uses global or local width.
  ///
  /// Defaults to [BreakifyVisibilityMode.global] to preserve
  /// the existing behavior.
  final BreakifyVisibilityMode mode;

  /// Creates a visibility widget using a breakpoint range.
  const BreakifyVisibility({
    super.key,
    required this.child,
    this.replacement,
    this.minBreakpoint,
    this.maxBreakpoint,
    this.breakpoints,
    this.mode = BreakifyVisibilityMode.global,
  }) : visibleIn = null;

  /// Creates a visibility widget using explicit breakpoints.
  const BreakifyVisibility.only({
    super.key,
    required this.child,
    required Set<BreakifyBreakpoint> this.visibleIn,
    this.replacement,
    this.breakpoints,
    this.mode = BreakifyVisibilityMode.global,
  })  : minBreakpoint = null,
        maxBreakpoint = null;

  @override
  Widget build(BuildContext context) {
    final effectiveBreakpoints = breakpoints ?? context.breakifyBreakpoints;
    final globalWidth = context.breakifyWidth;

    if (mode == BreakifyVisibilityMode.global) {
      return _buildForWidth(
        globalWidth,
        effectiveBreakpoints,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final localWidth =
            constraints.maxWidth.isFinite ? constraints.maxWidth : globalWidth;

        return _buildForWidth(
          localWidth,
          effectiveBreakpoints,
        );
      },
    );
  }

  Widget _buildForWidth(
    double width,
    BreakifyBreakpoints effectiveBreakpoints,
  ) {
    final breakpoint = effectiveBreakpoints.resolve(width);
    final isVisible = _resolveVisibility(breakpoint);

    if (isVisible) return child;

    return replacement ?? const SizedBox.shrink();
  }

  bool _resolveVisibility(BreakifyBreakpoint breakpoint) {
    if (visibleIn != null) {
      return visibleIn!.contains(breakpoint);
    }

    final index = breakpoint.index;
    final minIndex = minBreakpoint?.index ?? 0;
    final maxIndex =
        maxBreakpoint?.index ?? BreakifyBreakpoint.values.length - 1;

    return index >= minIndex && index <= maxIndex;
  }
}
