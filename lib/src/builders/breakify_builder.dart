import 'package:breakify/src/breakpoints/breakify_breakpoints.dart';
import 'package:flutter/widgets.dart';

/// Signature for the builder function used by [BreakifyBuilder].
///
/// The callback provides the current [BuildContext], the resolved
/// [BreakifyBreakpoint], and the available [BoxConstraints].
typedef BreakifyBuilderCallback = Widget Function(
  BuildContext context,
  BreakifyBreakpoint breakpoint,
  BoxConstraints constraints,
);

/// Builds widgets using the current responsive breakpoint.
///
/// [BreakifyBuilder] is similar to Flutter's [LayoutBuilder], but also
/// resolves the current [BreakifyBreakpoint] before calling the builder.
///
/// This allows widgets to react to the available width without manually
/// checking screen sizes or resolving breakpoints.
///
/// Example:
///
/// ```dart
/// BreakifyBuilder(
///   builder: (context, breakpoint, constraints) {
///     return Text(
///       'Current breakpoint: ${breakpoint.name}',
///     );
///   },
/// )
/// ```
class BreakifyBuilder extends StatelessWidget {
  /// Called whenever the layout constraints change.
  ///
  /// The callback receives the current [BuildContext], the resolved
  /// [BreakifyBreakpoint], and the available [BoxConstraints].
  final BreakifyBuilderCallback builder;

  /// Breakpoint configuration used to resolve the current width.
  ///
  /// Defaults to [BreakifyBreakpoints.defaults].
  final BreakifyBreakpoints breakpoints;

  /// Creates a widget that rebuilds using the current responsive breakpoint.
  const BreakifyBuilder({
    super.key,
    required this.builder,
    this.breakpoints = BreakifyBreakpoints.defaults,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = breakpoints.resolve(constraints.maxWidth);
        return builder(context, breakpoint, constraints);
      },
    );
  }
}
