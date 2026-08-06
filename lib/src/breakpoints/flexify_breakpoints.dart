///Defines the available resposive breakpoints used by Flexify
enum FlexifyBreakpoint { sm, md, lg, xl, xxl }

/// Defines the width values used to resolve responsive breakpoints.
///
/// By default, Flexify uses breakpoint values inspired by Tailwind CSS:
///
/// | Breakpoint | Width |
/// |-----------|------:|
/// | sm | 640 |
/// | md | 768 |
/// | lg | 1024 |
/// | xl | 1280 |
/// | xxl | 1536 |
///
/// You can provide custom values by creating a new
/// [FlexifyBreakpoints] instance.
///
/// ```dart
/// const breakpoints = FlexifyBreakpoints(
///   sm: 600,
///   md: 800,
///   lg: 1000,
///   xl: 1200,
///   xxl: 1600,
/// );
/// ```
class FlexifyBreakpoints {
  ///Minimum width for the small (`sm`) breakpoint.
  final double sm;

  /// Minimum width for the medium (`md`) breakpoint.
  final double md;

  /// Minimum width for the large (`lg`) breakpoint.
  final double lg;

  /// Minimum width for the extra-large (`xl`) breakpoint.
  final double xl;

  /// Minimum width for the extra-extra-large (`xxl`) breakpoint.
  final double xxl;

  /// Creates a set of responsive breakpoints.
  ///
  /// The breakpoint values must be provided in ascending order:
  /// `sm < md < lg < xl < xxl`.
  const FlexifyBreakpoints({
    this.sm = 640,
    this.md = 768,
    this.lg = 1024,
    this.xl = 1280,
    this.xxl = 1536,
  }) : assert(sm < md && md < lg && lg < xl && xl < xxl,
            'Los breakpoints deben estar en orden ascendente: sm < md < lg < xl < xxl');

  ///The default breakpoint values used by Flexify
  ///
  ///These values are inspired by Tailwind CSS.
  static const FlexifyBreakpoints defaults = FlexifyBreakpoints();

  ///Returns a copy of these breakpoints with the given values replaced
  FlexifyBreakpoints copyWith({
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return FlexifyBreakpoints(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  ///Returns the breakpoint that matches the give screen width.
  ///
  ///For example, a width of `900` resolves to [FlexifyBreakpoint.md]
  FlexifyBreakpoint resolve(double width) {
    if (width >= xxl) return FlexifyBreakpoint.xxl;
    if (width >= xl) return FlexifyBreakpoint.xl;
    if (width >= lg) return FlexifyBreakpoint.lg;
    if (width >= md) return FlexifyBreakpoint.md;
    return FlexifyBreakpoint.sm;
  }

  /// Returns the width associated with the given breakpoint.
  ///
  /// This is the inverse operation of [resolve].
  double valueOf(FlexifyBreakpoint breakpoint) {
    switch (breakpoint) {
      case FlexifyBreakpoint.sm:
        return sm;
      case FlexifyBreakpoint.md:
        return md;
      case FlexifyBreakpoint.lg:
        return lg;
      case FlexifyBreakpoint.xl:
        return xl;
      case FlexifyBreakpoint.xxl:
        return xxl;
    }
  }
}
