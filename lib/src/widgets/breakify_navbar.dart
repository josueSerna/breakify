import 'package:flutter/material.dart';

import '../scope/breakify_scope.dart';
import '../breakpoints/breakify_breakpoints.dart';
import 'breakify_navbar_item.dart';
import 'internal/breakify_navbar_bar.dart';
import 'internal/breakify_navbar_menu.dart';
import 'internal/breakify_navbar_scroll_driver.dart';
import 'internal/breakify_navbar_types.dart';

/// A responsive navigation bar with a built-in mobile menu.
///
/// > **Experimental.** Introduced in Breakify 0.3.0. Its API and behavior
/// > may change in future versions.
///
/// At [breakpoint] and above (read from the nearest `BreakifyScope`), the
/// [items] are laid out horizontally. Below it, the navbar shows a hamburger
/// button that opens either a dropdown or a drawer ([menuType]).
///
/// ## Usage
///
/// [BreakifyNavbar] wraps the page content ([body]) and draws the navbar,
/// the dropdown and the drawer on top of it:
///
/// ```dart
/// BreakifyNavbar(
///   logo: const Text('My App'),
///   items: [
///     BreakifyNavbarItem(label: 'Home', icon: Icons.home, onTap: () {}),
///     BreakifyNavbarItem(label: 'Contact', onTap: () {}),
///   ],
///   menuType: BreakifyNavbarMenuType.drawer,
///   scrollBehavior: BreakifyNavbarScrollBehavior.hideOnScroll,
///   body: ListView(children: const [/* ... */]),
/// )
/// ```
///
/// ## Scroll behavior
///
/// The navbar never creates or owns a `ScrollController`. It listens to the
/// `ScrollNotification`s that bubble up from [body] and only considers the
/// vertical, top-level (depth 0) scrollable. Scrollables nested deeper, or
/// scrolling outside [body], are ignored.
///
/// - [BreakifyNavbarScrollBehavior.static]: moves up 1:1 with the scroll
///   offset until it leaves the screen.
/// - [BreakifyNavbarScrollBehavior.fixed]: always visible.
/// - [BreakifyNavbarScrollBehavior.hideOnScroll]: slides out when scrolling
///   down and back in when scrolling up. It stays visible while the mobile
///   menu is open.
///
/// ## Known limitations
///
/// - Requires a `BreakifyScope` and a Material ancestor (such as
///   `MaterialApp`).
/// - With `fixed` and `hideOnScroll`, [body] is laid out below the navbar and
///   is never covered. With `hideOnScroll` it grows to fill the space when
///   the navbar hides.
/// - With `static`, the navbar overlays [body] so it can scroll away with
///   the content. [body] receives the navbar height as top `MediaQuery`
///   padding, which a default `ListView`/`GridView` applies automatically. If
///   you set your own `padding` or use `SingleChildScrollView` /
///   `CustomScrollView`, add `MediaQuery.paddingOf(context).top` yourself,
///   otherwise the first content is covered.
/// - `static` and `hideOnScroll` need a vertical scrollable as the top-level
///   scrollable of [body].
/// - Desktop items are not scrollable: too many items for the available
///   width will overflow.
/// - Resizing to a desktop width closes the mobile menu.
/// - The Android back button does not close the mobile menu.
class BreakifyNavbar extends StatefulWidget {
  /// Breakpoint at which the horizontal (desktop) navbar starts to be used.
  ///
  /// Below it, the mobile menu is shown. Defaults to [BreakifyBreakpoint.md].
  final BreakifyBreakpoint breakpoint;

  /// Optional widget shown at the start of the navbar.
  final Widget? logo;

  /// Navigation options.
  final List<BreakifyNavbarItem> items;

  /// Page content displayed under the navbar.
  ///
  /// See the class documentation for the padding provided to it.
  final Widget body;

  /// Style of the mobile menu. Defaults to [BreakifyNavbarMenuType.dropdown].
  final BreakifyNavbarMenuType menuType;

  /// Reaction to the scroll of [body]. Defaults to
  /// [BreakifyNavbarScrollBehavior.fixed].
  final BreakifyNavbarScrollBehavior scrollBehavior;

  /// Accumulated scroll distance, in logical pixels, in one direction needed
  /// before [BreakifyNavbarScrollBehavior.hideOnScroll] toggles. Defaults to 8.
  final double scrollThreshold;

  /// Icon of the button that opens the mobile menu.
  final IconData menuIcon;

  /// Icon of the button that closes the mobile menu.
  final IconData closeIcon;

  /// Navbar background. Defaults to the theme's `colorScheme.surface`.
  final Color? backgroundColor;

  /// Color of texts and icons. Defaults to the theme's `colorScheme.onSurface`.
  final Color? foregroundColor;

  /// Height of the bar, excluding the top safe area. Defaults to 64.
  final double height;

  /// Maximum height the [logo] can take in the bar. Defaults to 80.
  ///
  /// The logo is no longer limited to [height]: if it is taller than the bar
  /// (up to this value) it is centered and paints beyond the bar's edges
  /// without being clipped. Increase [height] to give it room.
  final double logoMaxHeight;

  /// Inner horizontal padding of the bar. Defaults to 16 on both sides.
  final EdgeInsetsGeometry padding;

  /// Horizontal gap between desktop items. Defaults to 8.
  final double itemSpacing;

  /// Background of the dropdown or drawer. Defaults to [backgroundColor].
  final Color? menuBackgroundColor;

  /// Side from which the drawer appears. Defaults to
  /// [BreakifyNavbarDrawerSide.left].
  final BreakifyNavbarDrawerSide drawerSide;

  /// Width of the drawer, limited to 85% of the available width.
  /// Defaults to 280.
  final double drawerWidth;

  /// Color of the barrier shown behind the drawer.
  final Color drawerOverlayColor;

  /// Duration of the menu and scroll animations. Defaults to 250 ms.
  final Duration animationDuration;

  /// Shadow elevation of the navbar and dropdown. Defaults to 2.
  final double elevation;

  const BreakifyNavbar({
    super.key,
    required this.items,
    required this.body,
    this.breakpoint = BreakifyBreakpoint.md,
    this.logo,
    this.menuType = BreakifyNavbarMenuType.dropdown,
    this.scrollBehavior = BreakifyNavbarScrollBehavior.fixed,
    this.scrollThreshold = 8,
    this.menuIcon = Icons.menu,
    this.closeIcon = Icons.close,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 64,
    this.logoMaxHeight = 80,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.itemSpacing = 8,
    this.menuBackgroundColor,
    this.drawerSide = BreakifyNavbarDrawerSide.left,
    this.drawerWidth = 280,
    this.drawerOverlayColor = Colors.black54,
    this.animationDuration = const Duration(milliseconds: 250),
    this.elevation = 2,
  });

  @override
  State<BreakifyNavbar> createState() => _BreakifyNavbarState();
}

class _BreakifyNavbarState extends State<BreakifyNavbar>
    with TickerProviderStateMixin {
  late final AnimationController _menu;
  late final CurvedAnimation _drawerAnimation;
  late final BreakifyNavbarScrollDriver _scroll;
  bool _menuOpen = false;

  @override
  void initState() {
    super.initState();
    _menu =
        AnimationController(vsync: this, duration: widget.animationDuration);
    _drawerAnimation = CurvedAnimation(
      parent: _menu,
      curve: Curves.easeInOut,
    );
    _scroll = BreakifyNavbarScrollDriver(
      vsync: this,
      behavior: widget.scrollBehavior,
      threshold: widget.scrollThreshold,
      duration: widget.animationDuration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _closeIfDesktop();
  }

  @override
  void didUpdateWidget(BreakifyNavbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _menu.duration = widget.animationDuration;
    _scroll
      ..duration = widget.animationDuration
      ..threshold = widget.scrollThreshold;
    if (oldWidget.scrollBehavior != widget.scrollBehavior) {
      _scroll
        ..behavior = widget.scrollBehavior
        ..reset();
    }
    _closeIfDesktop();
  }

  @override
  void dispose() {
    _drawerAnimation.dispose();
    _menu.dispose();
    _scroll.dispose();
    super.dispose();
  }

  bool get _isDesktop => context.breakpoint.index >= widget.breakpoint.index;

  void _closeIfDesktop() {
    if (_isDesktop && _menuOpen) {
      _menuOpen = false;
      _menu.value = 0;
      _scroll.locked = false;
    }
  }

  void _toggleMenu() {
    setState(() => _menuOpen = !_menuOpen);
    _scroll.locked = _menuOpen;
    _menuOpen ? _menu.forward() : _menu.reverse();
  }

  void _closeMenu() {
    if (_menuOpen) _toggleMenu();
  }

  void _select(BreakifyNavbarItem item) {
    _closeMenu();
    item.onTap();
  }

  /// `static` overlays the body (it must apply the top padding itself so the
  /// navbar can scroll away with it). The other behaviors place the body
  /// below the navbar, so it is never covered.
  Widget _buildBody(MediaQueryData media, double extent) {
    if (widget.scrollBehavior == BreakifyNavbarScrollBehavior.static) {
      return MediaQuery(
        data: media.copyWith(padding: media.padding.copyWith(top: extent)),
        child: widget.body,
      );
    }

    return AnimatedBuilder(
      animation: _scroll,
      builder: (context, child) => Column(
        children: [
          SizedBox(height: extent * (1 - _scroll.progress)),
          Expanded(child: child!),
        ],
      ),
      child: MediaQuery(
        data: media.copyWith(padding: media.padding.copyWith(top: 0)),
        child: widget.body,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = widget.backgroundColor ?? theme.colorScheme.surface;
    final foreground = widget.foregroundColor ?? theme.colorScheme.onSurface;
    final menuBackground = widget.menuBackgroundColor ?? background;
    final desktop = _isDesktop;
    final isDrawer = widget.menuType == BreakifyNavbarMenuType.drawer;

    final media = MediaQuery.of(context);
    final topInset = media.padding.top;
    final extent = widget.height + topInset;
    final hideDistance = extent + widget.elevation * 4;

    return Stack(
      children: [
        Positioned.fill(
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) => _scroll.onNotification(n, extent),
            child: RepaintBoundary(child: _buildBody(media, extent)),
          ),
        ),
        Positioned.fill(
          child: !desktop && !isDrawer
              ? _DismissBarrier(animation: _menu, onTap: _closeMenu)
              : const SizedBox.shrink(),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AnimatedBuilder(
            animation: _scroll,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, _scroll.translation(hideDistance)),
              child: child,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Keeps the bar (logo, shadow) in its own layer so moving it
                // or scrolling the body does not repaint it every frame.
                RepaintBoundary(
                  child: BreakifyNavbarBar(
                    items: widget.items,
                    desktop: desktop,
                    menuOpen: _menuOpen && !isDrawer,
                    onMenuPressed: _toggleMenu,
                    logo: widget.logo,
                    height: widget.height,
                    logoMaxHeight: widget.logoMaxHeight,
                    topInset: topInset,
                    padding: widget.padding,
                    itemSpacing: widget.itemSpacing,
                    backgroundColor: background,
                    foregroundColor: foreground,
                    elevation: widget.elevation,
                    menuIcon: widget.menuIcon,
                    closeIcon: widget.closeIcon,
                    animationDuration: widget.animationDuration,
                  ),
                ),
                if (!desktop && !isDrawer)
                  BreakifyNavbarDropdown(
                    animation: _menu,
                    items: widget.items,
                    backgroundColor: menuBackground,
                    foregroundColor: foreground,
                    elevation: widget.elevation,
                    onSelected: _select,
                  ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: !desktop && isDrawer
              ? BreakifyNavbarDrawer(
                  animation: _drawerAnimation,
                  items: widget.items,
                  side: widget.drawerSide,
                  width: widget.drawerWidth,
                  logo: widget.logo,
                  closeIcon: widget.closeIcon,
                  backgroundColor: menuBackground,
                  foregroundColor: foreground,
                  overlayColor: widget.drawerOverlayColor,
                  onClose: _closeMenu,
                  onSelected: _select,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// Transparent layer that closes the dropdown when tapping outside of it.
class _DismissBarrier extends StatelessWidget {
  const _DismissBarrier({required this.animation, required this.onTap});

  final Animation<double> animation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        if (animation.isDismissed) return const SizedBox.shrink();
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
        );
      },
    );
  }
}
