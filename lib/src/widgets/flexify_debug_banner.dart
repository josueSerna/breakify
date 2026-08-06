import 'package:flutter/widgets.dart';

import '../breakpoints/flexify_breakpoints.dart';
import '../scope/flexify_scope.dart';

/// Defines where the debug banner is displayed.
enum FlexifyBannerCorner {
  /// Displays the banner in the top-left corner.
  topLeft,

  /// Displays the banner in the top-right corner.
  topRight,

  /// Displays the banner in the bottom-left corner.
  bottomLeft,

  /// Displays the banner in the bottom-right corner.
  bottomRight,
}

/// Displays an overlay showing the current responsive breakpoint.
///
/// This widget is intended for development and debugging. It overlays
/// the current breakpoint name and screen width on top of its child,
/// making it easy to verify responsive layouts while resizing the window.
///
/// The banner can be positioned in any corner of the screen and can
/// be enabled or disabled without removing it from the widget tree.
///
/// Typically, this widget should not be included in production builds.
///
/// Requires a [FlexifyScope] ancestor unless [breakpoints] is
/// explicitly provided.
class FlexifyDebugBanner extends StatelessWidget {
  /// The widget below this banner.
  final Widget child;

  /// Whether the banner is visible.
  ///
  /// Defaults to `true`.
  final bool enabled;

  /// Breakpoint configuration used to resolve the current screen size.
  ///
  /// If null, falls back to the [FlexifyBreakpoints] provided by the
  /// nearest [FlexifyScope] ancestor.
  final FlexifyBreakpoints? breakpoints;

  /// Position of the banner on the screen.
  final FlexifyBannerCorner corner;

  /// Creates a debug banner that displays the current breakpoint.
  const FlexifyDebugBanner({
    super.key,
    required this.child,
    this.enabled = true,
    this.breakpoints,
    this.corner = FlexifyBannerCorner.topRight,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final effectiveBreakpoints = breakpoints ?? context.flexifyBreakpoints;
    final width = context.flexifyWidth;
    final breakpoint = effectiveBreakpoints.resolve(width);

    return Stack(
      children: [
        child,
        Positioned(
          top: _isTop ? 0 : null,
          bottom: _isTop ? null : 0,
          left: _isLeft ? 0 : null,
          right: _isLeft ? null : 0,
          child: IgnorePointer(
            child: SafeArea(
              child: _Banner(
                breakpoint: breakpoint,
                width: width,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Returns whether the banner should be aligned to the top edge.
  bool get _isTop =>
      corner == FlexifyBannerCorner.topLeft ||
      corner == FlexifyBannerCorner.topRight;

  /// Returns whether the banner should be aligned to the left edge.
  bool get _isLeft =>
      corner == FlexifyBannerCorner.topLeft ||
      corner == FlexifyBannerCorner.bottomLeft;
}

/// Internal widget that renders the debug banner.
///
/// Displays the resolved breakpoint together with the current
/// screen width.
class _Banner extends StatelessWidget {
  /// Current responsive breakpoint.
  final FlexifyBreakpoint breakpoint;

  /// Current screen width in logical pixels.
  final double width;

  const _Banner({
    required this.breakpoint,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _colorFor(breakpoint),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '${breakpoint.name} · ${width.round()}px',
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Returns the banner color associated with each breakpoint.
  Color _colorFor(FlexifyBreakpoint breakpoint) {
    switch (breakpoint) {
      case FlexifyBreakpoint.sm:
        return const Color(0xFFE53935);
      case FlexifyBreakpoint.md:
        return const Color(0xFFFB8C00);
      case FlexifyBreakpoint.lg:
        return const Color(0xFFFDD835);
      case FlexifyBreakpoint.xl:
        return const Color(0xFF43A047);
      case FlexifyBreakpoint.xxl:
        return const Color(0xFF1E88E5);
    }
  }
}
