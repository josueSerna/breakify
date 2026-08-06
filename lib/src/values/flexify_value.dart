import 'package:flexify/src/breakpoints/flexify_breakpoints.dart';
import 'package:flexify/src/values/flexify_resolvable.dart';

/// A responsive value that changes based on the current breakpoint.
///
/// If a breakpoint is not defined, Flexify automatically falls back
/// to the nearest previous breakpoint with an available value.
///
/// ## Example
///
/// ```dart
/// const columns = FlexifyValue<int>(
///   sm: 2,
///   md: 3,
///   lg: 4,
/// );
/// ```
class FlexifyValue<T> implements FlexifyResolvable<T> {
  /// Value used for the `sm` breakpoint.
  ///
  /// This value is required and acts as the fallback for all breakpoints.
  final T sm;

  /// Value used for the `md` breakpoint.
  ///
  /// Falls back to [sm] when not provided.
  final T? md;

  /// Value used for the `lg` breakpoint.
  ///
  /// Falls back to the nearest previous breakpoint when not provided.
  final T? lg;

  /// Value used for the `xl` breakpoint.
  ///
  /// Falls back to the nearest previous breakpoint when not provided.
  final T? xl;

  /// Value used for the `xxl` breakpoint.
  ///
  /// Falls back to the nearest previous breakpoint when not provided.
  final T? xxl;

  /// Creates a responsive value.
  ///
  /// Only [sm] is required.
  /// Higher breakpoints automatically inherit the nearest previous
  /// value when omitted.
  const FlexifyValue({
    required this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
  });

  /// Returns the value for the given breakpoint.
  ///
  /// If no value is defined for that breakpoint, the nearest previous
  /// breakpoint with a value is returned.
  ///
  /// The [width] parameter is ignored because this class resolves values
  /// only by breakpoint.
  @override
  T resolve(
    FlexifyBreakpoint breakpoint,
    double width,
    FlexifyBreakpoints breakpoints,
  ) {
    switch (breakpoint) {
      case FlexifyBreakpoint.xxl:
        return xxl ?? _fallbackFrom(FlexifyBreakpoint.xl, width, breakpoints);

      case FlexifyBreakpoint.xl:
        return xl ?? _fallbackFrom(FlexifyBreakpoint.lg, width, breakpoints);

      case FlexifyBreakpoint.lg:
        return lg ?? _fallbackFrom(FlexifyBreakpoint.md, width, breakpoints);

      case FlexifyBreakpoint.md:
        return md ?? sm;

      case FlexifyBreakpoint.sm:
        return sm;
    }
  }

  T _fallbackFrom(
    FlexifyBreakpoint breakpoint,
    double width,
    FlexifyBreakpoints breakpoints,
  ) {
    return resolve(breakpoint, width, breakpoints);
  }
}
