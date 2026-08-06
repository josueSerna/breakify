import 'package:breakify/breakify.dart';
import 'package:flutter/widgets.dart';

import '../values/breakify_resolvable.dart';

/// Centers its child and constrains its maximum width.
///
/// `BreakifyContainer` helps keep content readable on large screens
/// while allowing it to naturally fill smaller ones.
///
/// The maximum width and padding can be responsive by using
/// [BreakifyValue] or [BreakifyFluidValue].
///
/// This widget is responsible only for layout. To apply colors,
/// borders, gradients or shadows, wrap it with a [Container] or
/// [DecoratedBox].
///
/// Example:
///
/// ```dart
/// Container(
///   color: Colors.white,
///   child: BreakifyContainer(
///     maxWidth: const BreakifyValue(sm: 1200),
///     child: content,
///   ),
/// )
/// ```
///
/// Requires a [BreakifyScope] ancestor unless a custom
/// [breakpoints] configuration is provided.
class BreakifyContainer extends StatelessWidget {
  /// Widget displayed inside the container.
  final Widget child;

  /// Maximum width of the constrained content.
  ///
  /// Supports responsive values.
  final BreakifyResolvable<double> maxWidth;

  /// Inner padding applied around the child.
  ///
  /// Supports responsive values.
  final BreakifyResolvable<EdgeInsetsGeometry>? padding;

  /// Outer margin surrounding the container.
  final EdgeInsetsGeometry? margin;

  /// Alignment of the constrained content within the available space.
  final AlignmentGeometry alignment;

  /// Breakpoint configuration used to resolve responsive values.
  ///
  /// If null, falls back to the [BreakifyBreakpoints] provided by the
  /// nearest [BreakifyScope] ancestor.
  final BreakifyBreakpoints? breakpoints;

  /// Creates a responsive container that constrains its maximum width.
  const BreakifyContainer({
    super.key,
    required this.child,
    this.maxWidth = const BreakifyValue(sm: 1200),
    this.padding,
    this.margin,
    this.alignment = Alignment.topCenter,
    this.breakpoints,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBreakpoints = breakpoints ?? context.breakifyBreakpoints;

    return BreakifyBuilder(
      breakpoints: effectiveBreakpoints,
      builder: (context, breakpoint, constraints) {
        final width = constraints.maxWidth;

        Widget content = ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth.resolve(breakpoint, width, effectiveBreakpoints),
          ),
          child: child,
        );

        if (margin != null) {
          content = Padding(
            padding: margin!,
            child: content,
          );
        }

        if (padding != null) {
          content = Padding(
            padding: padding!.resolve(breakpoint, width, effectiveBreakpoints),
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
