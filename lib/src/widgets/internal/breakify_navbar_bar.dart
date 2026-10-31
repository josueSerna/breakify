import 'package:flutter/material.dart';

import '../breakify_navbar_item.dart';

/// The visible bar of `BreakifyNavbar`: logo plus either the desktop items
/// or the hamburger button.
class BreakifyNavbarBar extends StatelessWidget {
  const BreakifyNavbarBar({
    super.key,
    required this.items,
    required this.desktop,
    required this.menuOpen,
    required this.onMenuPressed,
    required this.logo,
    required this.height,
    required this.logoMaxHeight,
    required this.topInset,
    required this.padding,
    required this.itemSpacing,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.elevation,
    required this.menuIcon,
    required this.closeIcon,
    required this.animationDuration,
  });

  final List<BreakifyNavbarItem> items;
  final bool desktop;
  final bool menuOpen;
  final VoidCallback onMenuPressed;
  final Widget? logo;
  final double height;
  final double logoMaxHeight;
  final double topInset;
  final EdgeInsetsGeometry padding;
  final double itemSpacing;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final IconData menuIcon;
  final IconData closeIcon;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    return Material(
      color: backgroundColor,
      elevation: elevation,
      child: Padding(
        padding: EdgeInsets.only(top: topInset),
        child: SizedBox(
          height: height,
          child: Padding(
            padding: padding,
            // Lets the logo grow up to logoMaxHeight even when it is taller
            // than the bar; the row stays centered and overflows evenly.
            child: OverflowBox(
              minHeight: 0,
              maxHeight: logoMaxHeight > height ? logoMaxHeight : height,
              child: Row(
                children: [
                  if (logo != null) logo!,
                  const Spacer(),
                  if (desktop)
                    for (var i = 0; i < items.length; i++) ...[
                      if (i > 0) SizedBox(width: itemSpacing),
                      _DesktopItem(
                        item: items[i],
                        foregroundColor: foregroundColor,
                      ),
                    ]
                  else
                    IconButton(
                      onPressed: onMenuPressed,
                      color: foregroundColor,
                      tooltip: menuOpen
                          ? localizations.closeButtonTooltip
                          : localizations.showMenuTooltip,
                      icon: AnimatedSwitcher(
                        duration: animationDuration,
                        transitionBuilder: (child, animation) =>
                            RotationTransition(
                          turns:
                              Tween(begin: 0.75, end: 1.0).animate(animation),
                          child:
                              FadeTransition(opacity: animation, child: child),
                        ),
                        child: Icon(
                          menuOpen ? closeIcon : menuIcon,
                          key: ValueKey(menuOpen),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopItem extends StatelessWidget {
  const _DesktopItem({required this.item, required this.foregroundColor});

  final BreakifyNavbarItem item;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final style = TextButton.styleFrom(
      foregroundColor: foregroundColor,
      disabledForegroundColor: foregroundColor.withValues(alpha: 0.38),
    );
    final onPressed = item.enabled ? item.onTap : null;

    if (item.icon == null) {
      return TextButton(
        style: style,
        onPressed: onPressed,
        child: Text(item.label),
      );
    }

    return TextButton.icon(
      style: style,
      onPressed: onPressed,
      icon: Icon(item.icon),
      label: Text(item.label),
    );
  }
}
