import 'package:flexify/src/breakpoints/flexify_breakpoints.dart';
import 'package:flexify/src/values/flexify_resolvable.dart';

/// Represents a responsive value that scales fluidly across breakpoints.
///
/// `FlexifyFluidValue` stores values for one or more breakpoints and
/// automatically interpolates between them based on the current screen width.
///
/// Unlike [FlexifyValue], which changes values only when a breakpoint is
/// reached, this class produces smooth transitions between the defined
/// breakpoint values.
///
/// ## Example
///
/// ```dart
/// // Value that scales from 8 at `sm` to 16 at `md` and 24 at `lg`.
/// const spacing = FlexifyFluidValue(
///   sm: 8,
///   md: 16,
///   lg: 24,
/// );
///
/// // Returns the interpolated value for a screen width of 900px,
/// // using the breakpoints resolved from FlexifyScope/FlexifyBuilder.
/// final value = spacing.resolve(
///   FlexifyBreakpoint.lg,
///   900,
///   FlexifyBreakpoints.defaults,
/// );
/// ```
class FlexifyFluidValue implements FlexifyResolvable<double> {
  /// Value for the `sm` breakpoint.
  ///
  /// This value is required and acts as the starting point of the interpolation.
  final double sm;

  /// Value for the `md` breakpoint.
  ///
  /// If omitted, interpolation continues until the next defined breakpoint.
  final double? md;

  /// Value for the `lg` breakpoint.
  ///
  /// If omitted, interpolation continues until the next defined breakpoint.
  final double? lg;

  /// Value for the `xl` breakpoint.
  ///
  /// If omitted, interpolation continues until the next defined breakpoint.
  final double? xl;

  /// Value for the `xxl` breakpoint.
  ///
  /// If omitted, the last defined value is preserved.
  final double? xxl;

  /// Optional override for the breakpoint configuration used to calculate
  /// interpolation ranges.
  ///
  /// If null, the [FlexifyBreakpoints] passed into [resolve] is used
  /// (normally the one from [FlexifyScope] or [FlexifyBuilder]). Only set
  /// this if this specific value needs different breakpoint widths than
  /// the rest of the app.
  final FlexifyBreakpoints? overrideBreakpoints;

  /// Creates a fluid responsive value.
  ///
  /// At least the `sm` value must be provided.
  const FlexifyFluidValue({
    required this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    this.overrideBreakpoints,
  });

  /// Resolves the interpolated value for the given screen width.
  ///
  /// The [breakpoint] parameter is ignored by this implementation but is kept
  /// to satisfy the [FlexifyResolvable] interface.
  ///
  /// [breakpoints] is used to determine the pixel width of each breakpoint,
  /// unless [overrideBreakpoints] was set on this value.
  ///
  /// Resolution rules:
  ///
  /// * Before the first defined breakpoint, returns its value.
  /// * Between two defined breakpoints, linearly interpolates the value.
  /// * After the last defined breakpoint, returns the last value.
  @override
  double resolve(
    FlexifyBreakpoint breakpoint,
    double width,
    FlexifyBreakpoints breakpoints,
  ) {
    final effectiveBreakpoints = overrideBreakpoints ?? breakpoints;
    final points = <(FlexifyBreakpoint, double)>[
      (FlexifyBreakpoint.sm, sm),
      if (md != null) (FlexifyBreakpoint.md, md!),
      if (lg != null) (FlexifyBreakpoint.lg, lg!),
      if (xl != null) (FlexifyBreakpoint.xl, xl!),
      if (xxl != null) (FlexifyBreakpoint.xxl, xxl!),
    ];

    final firstWidth = effectiveBreakpoints.valueOf(points.first.$1);

    if (width <= firstWidth) {
      return points.first.$2;
    }

    for (var i = 0; i < points.length - 1; i++) {
      final (fromBreakpoint, fromValue) = points[i];
      final (toBreakpoint, toValue) = points[i + 1];

      final fromWidth = effectiveBreakpoints.valueOf(fromBreakpoint);
      final toWidth = effectiveBreakpoints.valueOf(toBreakpoint);

      if (width <= toWidth) {
        final t = (width - fromWidth) / (toWidth - fromWidth);

        return fromValue + (toValue - fromValue) * t;
      }
    }

    return points.last.$2;
  }

  /// Resolves the value and rounds it to the nearest whole number.
  ///
  /// Useful for values such as icon sizes, font sizes or spacing where
  /// fractional pixels are unnecessary.
  double resolveRounded(
    FlexifyBreakpoint breakpoint,
    double width,
    FlexifyBreakpoints breakpoints,
  ) {
    return resolve(breakpoint, width, breakpoints).roundToDouble();
  }
}
