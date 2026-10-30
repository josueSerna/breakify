/// Mobile menu style used by `BreakifyNavbar` below its breakpoint.
///
/// **Experimental:** may change in future versions.
enum BreakifyNavbarMenuType {
  /// A panel that expands right below the navbar.
  dropdown,

  /// A side panel that slides over the page content.
  drawer,
}

/// How `BreakifyNavbar` reacts to the scrolling of its `body`.
///
/// Only vertical scrolling at the top of the body's scroll tree is observed.
/// Scrollables nested inside the body (for example horizontal carousels)
/// are ignored.
///
/// **Experimental:** may change in future versions.
enum BreakifyNavbarScrollBehavior {
  /// The navbar sits at the top of the page and scrolls away with the
  /// content, following the scroll offset one to one.
  ///
  /// For the content to move in sync with the navbar, the body scrollable
  /// must apply the top padding provided by the navbar (see
  /// `BreakifyNavbar.body`).
  static,

  /// The navbar always stays visible at the top.
  fixed,

  /// The navbar hides when scrolling down and reappears when scrolling up.
  hideOnScroll,
}

/// Side from which the drawer of `BreakifyNavbar` appears.
///
/// **Experimental:** may change in future versions.
enum BreakifyNavbarDrawerSide {
  /// The drawer slides in from the left edge.
  left,

  /// The drawer slides in from the right edge.
  right,
}
