import 'package:flexify/src/breakpoints/flexify_breakpoints.dart';
import 'package:flutter/widgets.dart';

/// Signature for the builder function used by [FlexifyBuilder].
///
/// Provides the current [BuildContext], resolved
/// [FlexifyBreakpoint], and [BoxConstraints].
typedef FlexifyBuilderCallback = Widget Function(
  BuildContext context,
  FlexifyBreakpoint breakpoint,
  BoxConstraints constraints,
);

/// A widget that rebuilds its child based on the current breakpoint.
///
/// Internally, it uses a [LayoutBuilder] to obtain the available width
/// and resolves the corresponding [FlexifyBreakpoint].
class FlexifyBuilder extends StatelessWidget {
  /// Builds the widget using the current resolved breakpoint.
  final FlexifyBuilderCallback builder;

  /// The breakpoint configuration used to resolve the current screen width.
  final FlexifyBreakpoints breakpoints;

  /// Creates a [FlexifyBuilder].
  ///
  /// Defaults to [FlexifyBreakpoints.defaults] when no custom
  /// breakpoints are provided.
  const FlexifyBuilder({
    super.key,
    required this.builder,
    this.breakpoints = FlexifyBreakpoints.defaults,
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
