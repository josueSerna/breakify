import 'package:flexify/src/breakpoints/flexify_breakpoints.dart';

/// Base interface for all responsive values.
///
/// Implementations resolve a value based on the current breakpoint
/// and the available screen width.
abstract interface class FlexifyResolvable<T> {
  T resolve(
    FlexifyBreakpoint breakpoint,
    double width,
    FlexifyBreakpoints breakpoints,
  );
}
