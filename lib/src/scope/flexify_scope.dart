import 'package:flutter/widgets.dart';

import '../breakpoints/flexify_breakpoints.dart';
import '../values/flexify_resolvable.dart';

/// Provides responsive breakpoint information to the widget tree.
///
/// Wrap your app (or any subtree that needs responsive behavior) with
/// [FlexifyScope] to enable [BuildContext] extensions like
/// `context.breakpoint` and `context.resolve()`.
///
/// ```dart
/// void main() {
///   runApp(
///     FlexifyScope(
///       child: MaterialApp(
///         home: const HomePage(),
///       ),
///     ),
///   );
/// }
/// ```
class FlexifyScope extends StatelessWidget {
  /// Breakpoint configuration used across the subtree.
  final FlexifyBreakpoints breakpoints;

  /// Widget subtree that can access responsive context extensions.
  final Widget child;

  const FlexifyScope({
    super.key,
    this.breakpoints = FlexifyBreakpoints.defaults,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final breakpoint = breakpoints.resolve(width);

    return FlexifyInherited(
      breakpoint: breakpoint,
      breakpoints: breakpoints,
      width: width,
      child: child,
    );
  }
}

/// Internal inherited widget that stores the resolved breakpoint data.
///
/// This is not part of the public API. Access responsive data through
/// the [FlexifyContext] extensions instead (`context.breakpoint`,
/// `context.resolve()`). It's kept public (not prefixed with `_`) only
/// so it can be referenced from tests within this package.
class FlexifyInherited extends InheritedWidget {
  final FlexifyBreakpoint breakpoint;
  final FlexifyBreakpoints breakpoints;
  final double width;

  const FlexifyInherited({
    super.key,
    required this.breakpoint,
    required this.breakpoints,
    required this.width,
    required super.child,
  });

  @override
  bool updateShouldNotify(FlexifyInherited oldWidget) {
    return breakpoint != oldWidget.breakpoint ||
        width != oldWidget.width ||
        breakpoints != oldWidget.breakpoints;
  }
}

/// Convenience extensions to access responsive data from any [BuildContext]
/// within a [FlexifyScope].
extension FlexifyContext on BuildContext {
  FlexifyInherited get _flexifyInherited {
    final inherited = dependOnInheritedWidgetOfExactType<FlexifyInherited>();

    assert(
      inherited != null,
      'No FlexifyScope found in context. '
      'Wrap your app with FlexifyScope(child: ...) near the root.',
    );

    return inherited!;
  }

  /// The current [FlexifyBreakpoint] based on the screen width.
  FlexifyBreakpoint get breakpoint => _flexifyInherited.breakpoint;

  /// The [FlexifyBreakpoints] configuration provided by the nearest
  /// [FlexifyScope].
  FlexifyBreakpoints get flexifyBreakpoints => _flexifyInherited.breakpoints;

  /// The current screen width, as measured by [FlexifyScope].
  double get flexifyWidth => _flexifyInherited.width;

  /// Resolves a [FlexifyResolvable] value using the current breakpoint
  /// and screen width.
  ///
  /// ```dart
  /// final columns = context.resolve(
  ///   const FlexifyValue(sm: 1, md: 2, lg: 3),
  /// );
  /// ```
  T resolve<T>(FlexifyResolvable<T> value) {
    return value.resolve(breakpoint, flexifyWidth, flexifyBreakpoints);
  }
}
