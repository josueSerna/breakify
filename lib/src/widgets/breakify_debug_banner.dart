import 'package:flutter/widgets.dart';

import '../breakpoints/breakify_breakpoints.dart';
import '../scope/breakify_scope.dart';

/// Defines the available positions for the debug banner.
enum BreakifyBannerCorner {
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
/// This widget is intended for development and debugging purposes.
/// It overlays the current breakpoint and screen width on top of its
/// child, making it easier to verify responsive layouts while
/// resizing the application.
///
/// The banner can be positioned in any corner of the screen and
/// can be enabled or disabled without removing it from the widget tree.
///
/// This widget should typically be excluded from production builds.
///
/// Requires a [BreakifyScope] ancestor unless a custom
/// [breakpoints] configuration is provided.
class BreakifyDebugBanner extends StatelessWidget {
  /// The widget below the debug banner.
  final Widget child;

  /// Whether the banner is visible.
  ///
  /// Defaults to `true`.
  final bool enabled;

  /// Breakpoint configuration used to resolve the current breakpoint.
  ///
  /// If null, the configuration provided by the nearest
  /// [BreakifyScope] is used.
  final BreakifyBreakpoints? breakpoints;

  /// Position of the banner.
  final BreakifyBannerCorner corner;

  /// Creates a debug banner that displays the current breakpoint.
  const BreakifyDebugBanner({
    super.key,
    required this.child,
    this.enabled = true,
    this.breakpoints,
    this.corner = BreakifyBannerCorner.topRight,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final effectiveBreakpoints = breakpoints ?? context.breakifyBreakpoints;
    final width = context.breakifyWidth;
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

  /// Whether the banner is positioned at the top.
  bool get _isTop =>
      corner == BreakifyBannerCorner.topLeft ||
      corner == BreakifyBannerCorner.topRight;

  /// Whether the banner is positioned on the left side.
  bool get _isLeft =>
      corner == BreakifyBannerCorner.topLeft ||
      corner == BreakifyBannerCorner.bottomLeft;
}

/// Internal widget that renders the debug banner.
class _Banner extends StatelessWidget {
  /// Current responsive breakpoint.
  final BreakifyBreakpoint breakpoint;

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

  /// Returns the color associated with a breakpoint.
  Color _colorFor(BreakifyBreakpoint breakpoint) {
    switch (breakpoint) {
      case BreakifyBreakpoint.sm:
        return const Color(0xFFE53935);
      case BreakifyBreakpoint.md:
        return const Color(0xFFFB8C00);
      case BreakifyBreakpoint.lg:
        return const Color(0xFFFDD835);
      case BreakifyBreakpoint.xl:
        return const Color(0xFF43A047);
      case BreakifyBreakpoint.xxl:
        return const Color(0xFF1E88E5);
    }
  }
}
