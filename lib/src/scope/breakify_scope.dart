import 'package:flutter/widgets.dart';

import '../breakpoints/breakify_breakpoints.dart';
import '../values/breakify_resolvable.dart';

/// Makes responsive breakpoint information available to the widget tree.
///
/// Wrap your application (or a subtree) with [BreakifyScope] to enable
/// responsive features such as [BreakifyContext.breakpoint] and
/// [BreakifyContext.resolve].
///
/// Descendant widgets can access the current breakpoint, screen width,
/// and breakpoint configuration through the provided [BuildContext]
/// extension methods.
///
/// Example:
///
/// ```dart
/// void main() {
///   runApp(
///     BreakifyScope(
///       child: MaterialApp(
///         home: HomePage(),
///       ),
///     ),
///   );
/// }
/// ```
class BreakifyScope extends StatelessWidget {
  /// Breakpoint configuration available to all descendant widgets.
  final BreakifyBreakpoints breakpoints;

  /// The widget below this scope in the widget tree.
  final Widget child;

  const BreakifyScope({
    super.key,
    this.breakpoints = BreakifyBreakpoints.defaults,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final breakpoint = breakpoints.resolve(width);

    return BreakifyInheritedScope(
      breakpoint: breakpoint,
      breakpoints: breakpoints,
      width: width,
      child: child,
    );
  }
}

/// Internal inherited widget that stores responsive information.
///
/// This class is an implementation detail of Breakify.
/// Applications should access responsive data through
/// the [BreakifyContext] extension instead.
class BreakifyInheritedScope extends InheritedWidget {
  final BreakifyBreakpoint breakpoint;
  final BreakifyBreakpoints breakpoints;
  final double width;

  const BreakifyInheritedScope({
    super.key,
    required this.breakpoint,
    required this.breakpoints,
    required this.width,
    required super.child,
  });

  @override

  /// Notifies dependents when the breakpoint configuration changes.
  bool updateShouldNotify(BreakifyInheritedScope oldWidget) {
    return breakpoint != oldWidget.breakpoint ||
        width != oldWidget.width ||
        breakpoints != oldWidget.breakpoints;
  }
}

/// Extension methods that expose responsive information from
/// the nearest [BreakifyScope].
extension BreakifyContext on BuildContext {
  /// Returns the nearest [BreakifyInherited].
  ///
  /// Throws an assertion error if no [BreakifyScope] exists
  /// above this context.
  BreakifyInheritedScope get _breakifyInherited {
    final inherited =
        dependOnInheritedWidgetOfExactType<BreakifyInheritedScope>();

    assert(
      inherited != null,
      'No BreakifyScope found in context. '
      'Wrap your app with BreakifyScope(child: ...) near the root.',
    );

    return inherited!;
  }

  /// The active responsive breakpoint.
  BreakifyBreakpoint get breakpoint => _breakifyInherited.breakpoint;

  /// The breakpoint configuration provided by the nearest
  /// [BreakifyScope].
  BreakifyBreakpoints get breakifyBreakpoints => _breakifyInherited.breakpoints;

  /// The current available screen width.
  double get breakifyWidth => _breakifyInherited.width;

  /// Resolves a responsive value using the current context.
  ///
  /// The returned value depends on the active breakpoint,
  /// the available width and the breakpoint configuration.
  ///
  /// Example:
  ///
  /// ```dart
  /// final columns = context.resolve(
  ///   const BreakifyValue(
  ///     sm: 1,
  ///     md: 2,
  ///     lg: 4,
  ///   ),
  /// );
  /// ```
  T resolve<T>(BreakifyResolvable<T> value) {
    return value.resolve(breakpoint, breakifyWidth, breakifyBreakpoints);
  }
}
