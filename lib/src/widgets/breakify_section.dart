import 'package:breakify/breakify.dart';
import 'package:flutter/widgets.dart';

import '../values/breakify_resolvable.dart';

/// A full-width section for building web pages and landing pages.
///
/// **Experimental:** `BreakifySection` is experimental in version 0.2.3 and
/// its API may change in future releases.
///
/// The section spans the available width, can paint a [backgroundColor],
/// and aligns its [child] inside a minimum height. The section grows
/// vertically when its content needs more room, so the content is never
/// clipped by [minHeight] or [fullViewport].
///
/// [padding] and [minHeight] are resolved with the current breakpoint, so
/// they can be responsive by using [BreakifyValue] or [BreakifyFluidValue].
/// The padding is included in the minimum height.
///
/// This widget does not scroll. Place it inside a scrollable such as a
/// [SingleChildScrollView] or [ListView] to build a page.
///
/// Example:
///
/// ```dart
/// BreakifySection(
///   backgroundColor: Colors.indigo,
///   fullViewport: true,
///   padding: const BreakifyValue(
///     sm: EdgeInsets.all(16),
///     lg: EdgeInsets.symmetric(horizontal: 64, vertical: 32),
///   ),
///   child: const BreakifyContainer(child: Hero()),
/// )
/// ```
///
/// Requires a [BreakifyScope] ancestor.
class BreakifySection extends StatelessWidget {
  /// Widget displayed inside the section.
  final Widget child;

  /// Color painted behind the whole section.
  ///
  /// If null, the background is transparent.
  final Color? backgroundColor;

  /// Alignment of the [child] within the section.
  final AlignmentGeometry alignment;

  /// Padding applied around the child.
  ///
  /// Supports responsive values. If null, no padding is added.
  final BreakifyResolvable<EdgeInsetsGeometry>? padding;

  /// Minimum height of the section.
  ///
  /// Supports responsive values. The section still grows to fit its content.
  final BreakifyResolvable<double>? minHeight;

  /// Whether the section is at least as tall as the viewport.
  ///
  /// Uses the height reported by [MediaQuery.sizeOf]. When combined with
  /// [minHeight], the larger of both values is used. The section can still
  /// grow beyond the viewport height.
  final bool fullViewport;

  /// Creates an experimental responsive page section.
  const BreakifySection({
    super.key,
    required this.child,
    this.backgroundColor,
    this.alignment = Alignment.center,
    this.padding,
    this.minHeight,
    this.fullViewport = false,
  });

  @override
  Widget build(BuildContext context) {
    final breakpoints = context.breakifyBreakpoints;
    final viewportHeight =
        fullViewport ? MediaQuery.sizeOf(context).height : 0.0;

    return BreakifyBuilder(
      breakpoints: breakpoints,
      builder: (context, breakpoint, constraints) {
        final width = constraints.maxWidth;
        final resolvedMinHeight =
            minHeight?.resolve(breakpoint, width, breakpoints) ?? 0.0;
        final effectiveMinHeight = resolvedMinHeight > viewportHeight
            ? resolvedMinHeight
            : viewportHeight;

        Widget content = Align(
          alignment: alignment,
          heightFactor: 1,
          child: child,
        );

        if (padding != null) {
          content = Padding(
            padding: padding!.resolve(breakpoint, width, breakpoints),
            child: content,
          );
        }

        return ColoredBox(
          color: backgroundColor ?? const Color(0x00000000),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: effectiveMinHeight < 0 ? 0 : effectiveMinHeight,
            ),
            child: content,
          ),
        );
      },
    );
  }
}
