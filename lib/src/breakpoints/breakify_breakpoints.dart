/// Defines the responsive breakpoints available in Breakify.
enum BreakifyBreakpoint { sm, md, lg, xl, xxl }

/// Defines the width thresholds used to resolve responsive breakpoints.
///
/// A [BreakifyBreakpoints] object maps each breakpoint to a minimum width,
/// allowing widgets to adapt their layout based on the available space.
///
/// By default, Breakify provides a predefined set of breakpoint values,
/// but you can supply your own configuration if your application requires
/// different responsive thresholds.
///
/// Example:
///
/// ```dart
/// const breakpoints = breakifyBreakpoints(
///   sm: 600,
///   md: 768,
///   lg: 1024,
///   xl: 1280,
///   xxl: 1600,
/// );
/// ```
class BreakifyBreakpoints {
  /// Minimum width for the `sm` breakpoint.
  final double sm;

  /// Minimum width for the `md` breakpoint.
  final double md;

  /// Minimum width for the `lg` breakpoint.
  final double lg;

  /// Minimum width for the `xl` breakpoint.
  final double xl;

  /// Minimum width for the `xxl` breakpoint.
  final double xxl;

  /// Creates a breakpoint configuration.
  ///
  /// Beakpoint values must be provided in ascending order:
  ///
  /// `sm < md < lg < xl < xxl`.
  const BreakifyBreakpoints({
    this.sm = 640,
    this.md = 768,
    this.lg = 1024,
    this.xl = 1280,
    this.xxl = 1536,
  }) : assert(sm < md && md < lg && lg < xl && xl < xxl,
            'Los breakpoints deben estar en orden ascendente: sm < md < lg < xl < xxl');

  /// The default breakpoint configuration used by Breakify.
  static const BreakifyBreakpoints defaults = BreakifyBreakpoints();

  /// Returns a copy of this object with the specified values replaced.
  ///
  /// Any parameter left as `null` keeps its current value.
  BreakifyBreakpoints copyWith({
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return BreakifyBreakpoints(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  /// Returns the breakpoint corresponding to the given screen width.
  ///
  /// For example:
  ///
  /// ```dart
  /// breakpoints.resolve(900);
  /// // BreakifyBreakpoint.md
  /// ```
  BreakifyBreakpoint resolve(double width) {
    if (width >= xxl) return BreakifyBreakpoint.xxl;
    if (width >= xl) return BreakifyBreakpoint.xl;
    if (width >= lg) return BreakifyBreakpoint.lg;
    if (width >= md) return BreakifyBreakpoint.md;
    return BreakifyBreakpoint.sm;
  }

  /// Returns the minimum width associated with the given breakpoint.
  ///
  /// This is the inverse operation of [resolve].
  double valueOf(BreakifyBreakpoint breakpoint) {
    switch (breakpoint) {
      case BreakifyBreakpoint.sm:
        return sm;
      case BreakifyBreakpoint.md:
        return md;
      case BreakifyBreakpoint.lg:
        return lg;
      case BreakifyBreakpoint.xl:
        return xl;
      case BreakifyBreakpoint.xxl:
        return xxl;
    }
  }
}
