import 'package:flutter/widgets.dart';

import '../breakpoints/flexify_breakpoints.dart';
import '../builders/flexify_builder.dart';
import '../scope/flexify_scope.dart';
import '../values/flexify_resolvable.dart';
import '../values/flexify_value.dart';

/// Centers its child and constrains its maximum width.
///
/// Inspired by Tailwind CSS containers, this widget keeps content
/// readable on large screens while allowing it to naturally fill
/// smaller screens.
///
/// The maximum width and padding can be responsive by using
/// [FlexifyValue] or [FlexifyFluidValue].
///
/// This widget only handles responsive sizing and alignment.
/// For decoration (colors, borders, shadows, gradients), wrap it
/// with a regular [Container] or [DecoratedBox]:
///
/// ```dart
/// Container(
///   color: Colors.white,
///   child: FlexifyContainer(
///     maxWidth: const FlexifyValue(sm: 1200),
///     child: content,
///   ),
/// )
/// ```
///
/// Requires a [FlexifyScope] ancestor unless [breakpoints] is
/// explicitly provided.
class FlexifyContainer extends StatelessWidget {
  /// Widget displayed inside the container.
  final Widget child;

  /// Maximum width of the container.
  final FlexifyResolvable<double> maxWidth;

  /// Responsive inner padding.
  final FlexifyResolvable<EdgeInsetsGeometry>? padding;

  /// Outer margin.
  final EdgeInsetsGeometry? margin;

  /// Alignment of the constrained content.
  final AlignmentGeometry alignment;

  /// Breakpoint configuration.
  ///
  /// If null, falls back to the [FlexifyBreakpoints] provided by the
  /// nearest [FlexifyScope] ancestor.
  final FlexifyBreakpoints? breakpoints;

  const FlexifyContainer({
    super.key,
    required this.child,
    this.maxWidth = const FlexifyValue(sm: 1200),
    this.padding,
    this.margin,
    this.alignment = Alignment.topCenter,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBreakpoints = breakpoints ?? context.flexifyBreakpoints;

    return FlexifyBuilder(
      breakpoints: effectiveBreakpoints,
      builder: (context, breakpoint, constraints) {
        final width = constraints.maxWidth;

        Widget content = ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth.resolve(breakpoint, width, effectiveBreakpoints),
          ),
          child: child,
        );

        if (padding != null) {
          content = Padding(
            padding: padding!.resolve(breakpoint, width, effectiveBreakpoints),
            child: content,
          );
        }

        if (margin != null) {
          content = Padding(
            padding: margin!,
            child: content,
          );
        }

        return Align(
          alignment: alignment,
          child: content,
        );
      },
    );
  }
}
