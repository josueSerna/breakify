import 'package:breakify/src/breakpoints/breakify_breakpoints.dart';

/// Base interface for all responsive values.
///
/// A [BreakifyResolvable] can resolve a value based on the current
/// responsive breakpoint, the available width, and the active
/// breakpoint configuration.
///
/// This interface is implemented by classes such as
/// [BreakifyValue] and [BreakifyFluidValue], allowing widgets to
/// consume responsive values through a common API.
abstract interface class BreakifyResolvable<T> {
  /// Resolves the value for the current responsive context.
  ///
  /// The returned value may depend on:
  ///
  /// * The active [breakpoint].
  /// * The available screen [width].
  /// * The current [breakpoints] configuration.
  T resolve(
    BreakifyBreakpoint breakpoint,
    double width,
    BreakifyBreakpoints breakpoints,
  );
}
