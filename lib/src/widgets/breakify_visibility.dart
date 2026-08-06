import 'package:flutter/widgets.dart';

import '../breakpoints/breakify_breakpoints.dart';
import '../scope/breakify_scope.dart';

/// Shows or hides its child based on the current breakpoint.
///
/// By default, works in a mobile-first way: use [minBreakpoint] to show
/// the child only from a certain breakpoint upward (inclusive), or
/// [maxBreakpoint] to show it only up to a certain breakpoint (inclusive).
/// Combine both to define a range.
///
/// ```dart
/// // Shown only from `lg` upward (lg, xl, xxl)
/// BreakifyVisibility(
///   minBreakpoint: BreakifyBreakpoint.lg,
///   child: Sidebar(),
/// )
///
/// // Shown only on `sm` and `md`
/// BreakifyVisibility(
///   maxBreakpoint: BreakifyBreakpoint.md,
///   child: MobileNavBar(),
/// )
/// ```
///
/// For non-contiguous breakpoints (e.g. visible only on `sm` and `xl`,
/// but hidden on everything in between), use [visibleIn] instead:
///
/// ```dart
/// BreakifyVisibility.only(
///   visibleIn: {BreakifyBreakpoint.sm, BreakifyBreakpoint.xl},
///   child: SomeWidget(),
/// )
/// ```
///
/// When hidden, the child is not built at all (no space is reserved,
/// no state is preserved). If you need to preserve state or reserve
/// layout space while hidden, wrap the child yourself with [Visibility]
/// or [Offstage] instead.
///
/// Requires a [BreakifyScope] ancestor unless [breakpoints] is
/// explicitly provided.
class BreakifyVisibility extends StatelessWidget {
  /// Widget displayed when the current breakpoint is visible.
  final Widget child;

  /// Widget displayed when the child is hidden.
  ///
  /// If null, an empty widget (`SizedBox.shrink`) is rendered instead.
  final Widget? replacement;

  /// Lowest breakpoint (inclusive) where the child is visible.
  ///
  /// Ignored when [visibleIn] is provided.
  final BreakifyBreakpoint? minBreakpoint;

  /// Highest breakpoint (inclusive) where the child remains visible.
  ///
  /// Ignored when [visibleIn] is provided.
  final BreakifyBreakpoint? maxBreakpoint;

  /// Explicit list of breakpoints where the child is visible.
  ///
  /// This is useful when visibility does not follow a continuous range,
  /// for example showing the widget only on `sm` and `xl`.
  ///
  /// When provided, [minBreakpoint] and [maxBreakpoint] are ignored.
  final Set<BreakifyBreakpoint>? visibleIn;

  /// Breakpoint configuration used to determine the current breakpoint.
  ///
  /// If null, the nearest [BreakifyScope] configuration is used.
  final BreakifyBreakpoints? breakpoints;

  /// Creates a visibility widget using a breakpoint range.
  const BreakifyVisibility({
    super.key,
    required this.child,
    this.replacement,
    this.minBreakpoint,
    this.maxBreakpoint,
    this.breakpoints,
  }) : visibleIn = null;

  /// Creates a visibility widget using explicit breakpoints.
  ///
  /// This constructor is useful when visibility cannot be represented
  /// by a continuous breakpoint range.
  const BreakifyVisibility.only({
    super.key,
    required this.child,
    required Set<BreakifyBreakpoint> this.visibleIn,
    this.replacement,
    this.breakpoints,
  })  : minBreakpoint = null,
        maxBreakpoint = null;

  @override
  Widget build(BuildContext context) {
    final effectiveBreakpoints = breakpoints ?? context.breakifyBreakpoints;
    final width = context.breakifyWidth;
    final breakpoint = effectiveBreakpoints.resolve(width);

    final isVisible = _resolveVisibility(breakpoint);

    if (isVisible) return child;
    return replacement ?? const SizedBox.shrink();
  }

  /// Returns whether the widget should be visible for the
  /// current breakpoint.
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
