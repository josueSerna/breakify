import 'package:breakify/src/breakpoints/breakify_breakpoints.dart';
import 'package:breakify/src/values/breakify_resolvable.dart';

/// A responsive value that resolves different values at different breakpoints.
///
/// Each breakpoint can define its own value. If a value is omitted,
/// Brekify automatically falls back to the nearest previous breakpoint
/// with a defined value.
///
/// This makes it possible to specify only the breakpoints that need
/// to change while inheriting values for the others.
///
/// ## Example
///
/// ```dart
/// const columns = BreakifyValue<int>(
///   sm: 2,
///   md: 3,
///   lg: 4,
/// );
/// // xl and xxl automatically inherit the value 4.
/// ```
class BreakifyValue<T> implements BreakifyResolvable<T> {
  /// This value is required.
  ///
  /// All higher breakpoints inherit from this value unless overridden.
  final T sm;

  /// Value for the `md` breakpoint.
  ///
  /// If omitted, the value from `sm` is used.
  final T? md;

  /// Value for the `lg` breakpoint.
  ///
  /// If omitted, the nearest previous defined value is used.
  final T? lg;

  /// Value for the `xl` breakpoint.
  ///
  /// If omitted, the nearest previous defined value is used.
  final T? xl;

  /// Value for the `xxl` breakpoint.
  ///
  /// If omitted, the nearest previous defined value is used.
  final T? xxl;

  /// Creates a responsive value.
  ///
  /// Only [sm] is required. Higher breakpoints inherit the
  /// nearest previous value when omitted.
  const BreakifyValue({
    required this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
  });

  /// Resolves the value for the current breakpoint.
  ///
  /// If the requested breakpoint does not define a value,
  /// the nearest previous breakpoint with a value is used.
  ///
  /// The [width] and [breakpoints] parameters are accepted to satisfy
  /// the [BreakifyResolvable] interface but are ignored by this
  /// implementation, since resolution depends only on the active
  /// breakpoint.
  @override
  T resolve(
    BreakifyBreakpoint breakpoint,
    double width,
    BreakifyBreakpoints breakpoints,
  ) {
    switch (breakpoint) {
      case BreakifyBreakpoint.xxl:
        return xxl ?? _fallbackFrom(BreakifyBreakpoint.xl, width, breakpoints);

      case BreakifyBreakpoint.xl:
        return xl ?? _fallbackFrom(BreakifyBreakpoint.lg, width, breakpoints);

      case BreakifyBreakpoint.lg:
        return lg ?? _fallbackFrom(BreakifyBreakpoint.md, width, breakpoints);

      case BreakifyBreakpoint.md:
        return md ?? sm;

      case BreakifyBreakpoint.sm:
        return sm;
    }
  }

  /// Resolves the nearest previous breakpoint with a defined value.
  T _fallbackFrom(
    BreakifyBreakpoint breakpoint,
    double width,
    BreakifyBreakpoints breakpoints,
  ) {
    return resolve(breakpoint, width, breakpoints);
  }
}
