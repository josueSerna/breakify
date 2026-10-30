import 'package:flutter/material.dart';

import '../breakify_navbar_item.dart';
import 'breakify_navbar_types.dart';

/// Vertical list of navigation items shared by the dropdown and the drawer.
class BreakifyNavbarMenuItems extends StatelessWidget {
  const BreakifyNavbarMenuItems({
    super.key,
    required this.items,
    required this.foregroundColor,
    required this.onSelected,
  });

  final List<BreakifyNavbarItem> items;
  final Color foregroundColor;
  final ValueChanged<BreakifyNavbarItem> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in items)
          ListTile(
            enabled: item.enabled,
            iconColor: foregroundColor,
            textColor: foregroundColor,
            leading: item.icon == null ? null : Icon(item.icon),
            title: Text(item.label),
            onTap: item.enabled ? () => onSelected(item) : null,
          ),
      ],
    );
  }
}

/// Panel that expands right below the navbar.
class BreakifyNavbarDropdown extends StatelessWidget {
  const BreakifyNavbarDropdown({
    super.key,
    required this.animation,
    required this.items,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.elevation,
    required this.onSelected,
  });

  final Animation<double> animation;
  final List<BreakifyNavbarItem> items;
  final Color backgroundColor;
  final Color foregroundColor;
  final double elevation;
  final ValueChanged<BreakifyNavbarItem> onSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        if (animation.isDismissed) return const SizedBox.shrink();
        return ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: Curves.easeInOut.transform(animation.value),
            child: child,
          ),
        );
      },
      child: Material(
        color: backgroundColor,
        elevation: elevation,
        child: SafeArea(
          top: false,
          child: BreakifyNavbarMenuItems(
            items: items,
            foregroundColor: foregroundColor,
            onSelected: onSelected,
          ),
        ),
      ),
    );
  }
}

/// Side panel with a dimmed barrier. Covers the whole area of the navbar.
class BreakifyNavbarDrawer extends StatelessWidget {
  const BreakifyNavbarDrawer({
    super.key,
    required this.animation,
    required this.items,
    required this.side,
    required this.width,
    required this.logo,
    required this.closeIcon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.overlayColor,
    required this.onClose,
    required this.onSelected,
  });

  final Animation<double> animation;
  final List<BreakifyNavbarItem> items;
  final BreakifyNavbarDrawerSide side;
  final double width;
  final Widget? logo;
  final IconData closeIcon;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color overlayColor;
  final VoidCallback onClose;
  final ValueChanged<BreakifyNavbarItem> onSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        if (animation.isDismissed) return const SizedBox.shrink();

        final isLeft = side == BreakifyNavbarDrawerSide.left;

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onClose,
                child: FadeTransition(
                  opacity: animation,
                  child: ColoredBox(color: overlayColor),
                ),
              ),
            ),
            Align(
              alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
              child: SlideTransition(
                position: Tween(
                  begin: Offset(isLeft ? -1 : 1, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
          ],
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final drawerWidth =
              width.clamp(0.0, constraints.maxWidth * 0.85).toDouble();

          return SizedBox(
            width: drawerWidth,
            height: double.infinity,
            child: Material(
              color: backgroundColor,
              elevation: 16,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          if (logo != null)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: logo,
                                ),
                              ),
                            )
                          else
                            const Spacer(),
                          IconButton(
                            onPressed: onClose,
                            color: foregroundColor,
                            tooltip: MaterialLocalizations.of(context)
                                .closeButtonTooltip,
                            icon: Icon(closeIcon),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: BreakifyNavbarMenuItems(
                          items: items,
                          foregroundColor: foregroundColor,
                          onSelected: onSelected,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
