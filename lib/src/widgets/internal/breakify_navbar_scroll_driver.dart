import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'breakify_navbar_types.dart';

/// Translates scroll notifications into a vertical offset for the navbar.
///
/// It never owns or attaches to a `ScrollController`; it only observes the
/// notifications bubbling up from the navbar's `body`.
class BreakifyNavbarScrollDriver extends ChangeNotifier {
  BreakifyNavbarScrollDriver({
    required TickerProvider vsync,
    required this.behavior,
    required this.threshold,
    required Duration duration,
  }) : _hide = AnimationController(vsync: vsync, duration: duration) {
    _hide.addListener(notifyListeners);
  }

  BreakifyNavbarScrollBehavior behavior;
  double threshold;

  final AnimationController _hide;
  double _scrollOffset = 0;
  double _accumulated = 0;
  bool _locked = false;

  set duration(Duration value) => _hide.duration = value;

  /// Keeps the navbar visible, e.g. while its menu is open.
  set locked(bool value) {
    if (_locked == value) return;
    _locked = value;
    if (value) _show();
  }

  /// Resets the state after the behavior changes.
  void reset() {
    _scrollOffset = 0;
    _accumulated = 0;
    _hide.value = 0;
    notifyListeners();
  }

  /// How much of the navbar is hidden by `hideOnScroll`, from 0 to 1.
  double get progress => Curves.easeInOut.transform(_hide.value);

  /// Vertical translation to apply to the navbar. Always `<= 0`.
  ///
  /// [distance] is how far the navbar must travel to be completely off screen.
  double translation(double distance) {
    switch (behavior) {
      case BreakifyNavbarScrollBehavior.static:
        return -math.min(math.max(_scrollOffset, 0.0), distance);
      case BreakifyNavbarScrollBehavior.fixed:
        return 0;
      case BreakifyNavbarScrollBehavior.hideOnScroll:
        return -distance * progress;
    }
  }

  /// Handles a notification. Always returns `false` so it keeps bubbling.
  bool onNotification(ScrollNotification notification, double extent) {
    if (notification.depth != 0 ||
        notification.metrics.axis != Axis.vertical ||
        behavior == BreakifyNavbarScrollBehavior.fixed) {
      return false;
    }

    final metrics = notification.metrics;

    if (behavior == BreakifyNavbarScrollBehavior.static) {
      if (notification is ScrollUpdateNotification ||
          notification is ScrollMetricsNotification) {
        _scrollOffset = metrics.pixels;
        notifyListeners();
      }
      return false;
    }

    if (notification is! ScrollUpdateNotification) return false;

    final pixels = metrics.pixels;
    final delta = notification.scrollDelta ?? 0;

    if (pixels <= 0 || pixels >= metrics.maxScrollExtent) {
      // Top / bottom edges (including overscroll): bounce must not toggle.
      if (pixels <= 0) _show();
      _accumulated = 0;
      return false;
    }

    if (delta == 0) return false;
    if (_accumulated.sign != delta.sign) _accumulated = 0;
    _accumulated += delta;

    if (_accumulated > threshold && pixels > extent && !_locked) {
      _hide.forward();
    } else if (_accumulated < -threshold) {
      _show();
    }
    return false;
  }

  void _show() {
    if (_hide.value > 0 || _hide.isAnimating) _hide.reverse();
  }

  @override
  void dispose() {
    _hide.dispose();
    super.dispose();
  }
}
