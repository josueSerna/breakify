import 'package:flutter/widgets.dart';

import '../breakpoints/flexify_breakpoints.dart';
import '../scope/flexify_scope.dart';

/// Shows or hides its child based on the current breakpoint.
///
/// By default, works in a mobile-first way: use [minBreakpoint] to show
/// the child only from a certain breakpoint upward (inclusive), or
/// [maxBreakpoint] to show it only up to a certain breakpoint (inclusive).
/// Combine both to define a range.
///
/// ```dart
/// // Shown only from `lg` upward (lg, xl, xxl)
/// FlexifyVisibility(
///   minBreakpoint: FlexifyBreakpoint.lg,
///   child: Sidebar(),
/// )
///
/// // Shown only on `sm` and `md`
/// FlexifyVisibility(
///   maxBreakpoint: FlexifyBreakpoint.md,
///   child: MobileNavBar(),
/// )
/// ```
///
/// For non-contiguous breakpoints (e.g. visible only on `sm` and `xl`,
/// but hidden on everything in between), use [visibleIn] instead:
///
/// ```dart
/// FlexifyVisibility.only(
///   visibleIn: {FlexifyBreakpoint.sm, FlexifyBreakpoint.xl},
///   child: SomeWidget(),
/// )
/// ```
///
/// When hidden, the child is not built at all (no space is reserved,
/// no state is preserved). If you need to preserve state or reserve
/// layout space while hidden, wrap the child yourself with [Visibility]
/// or [Offstage] instead.
///
/// Requires a [FlexifyScope] ancestor unless [breakpoints] is
/// explicitly provided.
class FlexifyVisibility extends StatelessWidget {
  /// Widget to show when visible.
  final Widget child;

  /// Optional widget to show instead, when hidden.
  ///
  /// If null, nothing is rendered when hidden.
  final Widget? replacement;

  /// Minimum breakpoint (inclusive) at which [child] becomes visible.
  ///
  /// Ignored when [visibleIn] is set.
  final FlexifyBreakpoint? minBreakpoint;

  /// Maximum breakpoint (inclusive) at which [child] is still visible.
  ///
  /// Ignored when [visibleIn] is set.
  final FlexifyBreakpoint? maxBreakpoint;

  /// Explicit set of breakpoints at which [child] is visible.
  ///
  /// When set, [minBreakpoint] and [maxBreakpoint] are ignored.
  final Set<FlexifyBreakpoint>? visibleIn;

  /// Breakpoint configuration used to resolve the current breakpoint.
  ///
  /// If null, falls back to the [FlexifyBreakpoints] provided by the
  /// nearest [FlexifyScope] ancestor.
  final FlexifyBreakpoints? breakpoints;

  /// Creates a visibility widget using a min/max breakpoint range.
  const FlexifyVisibility({
    super.key,
    required this.child,
    this.replacement,
    this.minBreakpoint,
    this.maxBreakpoint,
    this.breakpoints,
  }) : visibleIn = null;

  /// Creates a visibility widget using an explicit set of breakpoints.
  ///
  /// Useful for non-contiguous ranges, e.g. visible on `sm` and `xl`
  /// but hidden on `md`, `lg`, and `xxl`.
  const FlexifyVisibility.only({
    super.key,
    required this.child,
    required Set<FlexifyBreakpoint> this.visibleIn,
    this.replacement,
    this.breakpoints,
  })  : minBreakpoint = null,
        maxBreakpoint = null;

  @override
  Widget build(BuildContext context) {
    final effectiveBreakpoints = breakpoints ?? context.flexifyBreakpoints;
    final width = context.flexifyWidth;
    final breakpoint = effectiveBreakpoints.resolve(width);

    final isVisible = _resolveVisibility(breakpoint);

    if (isVisible) return child;
    return replacement ?? const SizedBox.shrink();
  }

  bool _resolveVisibility(FlexifyBreakpoint breakpoint) {
    if (visibleIn != null) {
      return visibleIn!.contains(breakpoint);
    }

    final index = breakpoint.index;
    final minIndex = minBreakpoint?.index ?? 0;
    final maxIndex =
        maxBreakpoint?.index ?? FlexifyBreakpoint.values.length - 1;

    return index >= minIndex && index <= maxIndex;
  }
}
