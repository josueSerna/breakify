import 'package:breakify/src/breakpoints/breakify_breakpoints.dart';
import 'package:breakify/src/values/breakify_resolvable.dart';

/// Represents a responsive value that scales smoothly across breakpoints.
///
/// Unlike [BreakifyValue], which changes only when a breakpoint is reached,
/// [BreakifyFluidValue] interpolates between consecutive breakpoint values,
/// producing smooth transitions as the available width changes.
///
/// Only the breakpoints that need a different value must be specified.
/// Missing breakpoints are skipped automatically during interpolation.
///
/// ## Example
///
/// ```dart
/// const fontSize = BreakifyFluidValue(
///   sm: 14,
///   md: 16,
///   lg: 20,
/// );
///
/// Text(
///   'Breakify',
///   style: TextStyle(
///     fontSize: context.resolve(fontSize),
///   ),
/// )
/// ```
///
/// The resolved value changes smoothly as the available width increases:
///
/// ```text
/// Width 640px  -> 14
/// Width 704px  -> 15
/// Width 768px  -> 16
/// ```

class BreakifyFluidValue implements BreakifyResolvable<double> {
  /// This value is required.
  final double sm;

  /// Value for the `md` breakpoint.
  ///
  /// If omitted, interpolation skips directly to the next defined breakpoint.
  final double? md;

  /// Value for the `lg` breakpoint.
  ///
  /// If omitted, interpolation skips directly to the next defined breakpoint.
  final double? lg;

  /// Value for the `xl` breakpoint.
  ///
  /// If omitted, interpolation skips directly to the next defined breakpoint.
  final double? xl;

  /// Value for the `xxl` breakpoint.
  ///
  /// If omitted, interpolation ends at the previous defined breakpoint.
  final double? xxl;

  /// Optional override for the breakpoint configuration used to calculate
  /// interpolation ranges.
  ///
  /// If null, the [BreakifyBreakpoints] passed into [resolve] is used
  /// (normally the one from [BreakifyScope] or [BreakifyBuilder]).
  /// This is useful when a specific value should use different
  /// breakpoint widths than the rest of the application.
  final BreakifyBreakpoints? overrideBreakpoints;

  /// Creates a fluid responsive value.
  ///
  /// At least the `sm` value must be provided.
  const BreakifyFluidValue({
    required this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    this.overrideBreakpoints,
  });

  /// Resolves the interpolated value for the given screen width.
  ///
  /// This implementation performs linear interpolation between
  /// consecutive defined breakpoint values.
  ///
  /// The [breakpoint] parameter is ignored by this implementation but is kept
  /// to satisfy the [BreakifyResolvable] interface.
  ///
  /// The [breakpoints] parameter provides the breakpoint widths used during
  /// interpolation, unless [overrideBreakpoints] is specified.
  ///
  /// Resolution rules:
  ///
  /// * Before the first defined breakpoint, returns its value.
  /// * Between two defined breakpoints, linearly interpolates the value.
  /// * After the last defined breakpoint, returns the last defined value.
  @override
  double resolve(
    BreakifyBreakpoint breakpoint,
    double width,
    BreakifyBreakpoints breakpoints,
  ) {
    final effectiveBreakpoints = overrideBreakpoints ?? breakpoints;
    final points = <(BreakifyBreakpoint, double)>[
      (BreakifyBreakpoint.sm, sm),
      if (md != null) (BreakifyBreakpoint.md, md!),
      if (lg != null) (BreakifyBreakpoint.lg, lg!),
      if (xl != null) (BreakifyBreakpoint.xl, xl!),
      if (xxl != null) (BreakifyBreakpoint.xxl, xxl!),
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

  /// Resolves the value and rounds it to the nearest logical pixel.
  double resolveRounded(
    BreakifyBreakpoint breakpoint,
    double width,
    BreakifyBreakpoints breakpoints,
  ) {
    return resolve(breakpoint, width, breakpoints).roundToDouble();
  }
}
