import 'package:flutter/widgets.dart';

/// A navigation option displayed by `BreakifyNavbar`.
///
/// The same item is rendered as a horizontal button on desktop and as a
/// list entry in the mobile menu.
///
/// **Experimental:** may change in future versions.
@immutable
class BreakifyNavbarItem {
  /// Text of the option.
  final String label;

  /// Optional icon shown before the [label].
  final IconData? icon;

  /// Called when the option is selected.
  ///
  /// In the mobile menu, the menu closes before this callback runs.
  final VoidCallback onTap;

  /// Whether the option can be selected.
  ///
  /// A disabled option is rendered with a dimmed style and ignores taps.
  final bool enabled;

  const BreakifyNavbarItem({
    required this.label,
    required this.onTap,
    this.icon,
    this.enabled = true,
  });
}
