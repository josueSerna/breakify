# 0.3.0

Breakify 0.3.0 contains breaking changes in the grid widgets and introduces
the experimental `BreakifyNavbar`.

## Breaking changes

- Replaced the `equalHeight` boolean of `BreakifyGrid` and
  `BreakifyResponsiveGrid` with a nullable `heightMode` of the new
  `BreakifyHeightMode` enum, exported from `package:breakify/breakify.dart`.
  - `equalHeight: true` → `heightMode: BreakifyHeightMode.equalInRow`
    (identical behavior).
  - `equalHeight: false` → `heightMode: null` (default); items keep using
    `childAspectRatio`.
- When `heightMode` is not `null`, `childAspectRatio` is ignored.
- Raised the minimum supported version to Flutter `3.27.0`
  (`BreakifyNavbar` uses `Color.withValues`).

## Added

- `BreakifyPanelLayout.reverse` (default `false`): in horizontal mode, puts
  the secondary panels on the left and the main panel on the right without
  reversing the order of `secondaryPanels`.
- `BreakifyPanelLayout.secondaryDirection` (default `Axis.vertical`): with
  `Axis.horizontal`, the secondary panels are placed in a `Row` with equal
  shares of width in horizontal mode. `CrossAxisAlignment.stretch` is applied
  as `start` in that `Row` because its height is unbounded.
- Example screen for `reverse` and `secondaryDirection`, reachable from the
  BreakifyPanelLayout section of the example app.
- `BreakifyAdaptativeLayout.order`: optional `BreakifyLayoutOrder` with
  `layoutBelow` / `layoutAbove` distributions chosen from the configured
  `breakpoint`. Templates (`BreakifyLayoutTemplate`): `inRow`, `inColumn`,
  `twoRows`, `twoColumns` and `custom(left:, right:)`, which uses indices of
  the original `children` list. Two-group templates split children in order:
  the first `ceil(n / 2)` in the first group. Invalid `custom` indices
  (out of range, repeated, missing, empty groups) throw in debug mode. When
  `order` is `null` the behavior is unchanged. Known limitation: group
  heights are not equalized, so a child in a shorter group (e.g. an image)
  keeps its own height unless it sizes itself, optionally with
  `crossAxisAlignment: CrossAxisAlignment.stretch`.
- Example screen "Layout Order" for `BreakifyAdaptativeLayout`, and README
  (EN/ES) documentation for `order`.
- Added the opt-in `childScale` property to the experimental `BreakifySection`
  to visually scale its child without changing its layout size.
- `BreakifyNavbar.logoMaxHeight` (default 80): the logo is no longer
  constrained to the bar `height`, so taller images (up to 80 px) are shown
  at their size instead of being squeezed to 64.
- `BreakifyNavbar` (**experimental**, API may change): responsive navbar that
  shows its items inline from a breakpoint and a hamburger menu below it, with
  `BreakifyNavbarItem`, `BreakifyNavbarMenuType` (`dropdown`, `drawer`),
  `BreakifyNavbarScrollBehavior` (`static`, `fixed`, `hideOnScroll`) and
  `BreakifyNavbarDrawerSide`. See the class documentation for limitations.
- `BreakifyHeightMode.equal`: every item has exactly the same height, the
  tallest of the whole grid. `Spacer` and `Expanded` are supported.
- `BreakifyHeightMode.equalInRow`: every item in a row matches that row's
  tallest item; rows may differ. `Spacer` and `Expanded` are supported.
- `BreakifyHeightMode.natural`: every item keeps its natural height, aligned
  to the top of its row. `Spacer` and `Expanded` are not supported because the
  height is unbounded.
- Example screen "Raw Equal (experimental)" with unstyled, very uneven cards,
  a mode selector and a configurable number of cards.

## Performance

- `equalInRow` and `natural` build rows lazily.
- `equal` measures one row at a time and discards it, caches the shared
  height until the width, columns, spacing or children change, and keeps only
  the visible rows alive. In a local benchmark (3 columns, debug VM) with 2000
  cards it went from 130,044 to 655 live elements, and rebuilds at the same
  width from ~18.6 ms to ~0.6 ms. The first render improved (~1346 ms to
  ~825 ms), but a continuous width change costs more (~576 ms to ~754 ms)
  because every row is measured again.
- Each row now includes `mainSpacing` below it in `equal` mode, so the total
  scroll extent is one `mainSpacing` longer.

## Documentation

- Added a "Latest Important Updates" section to `README.md` and
  `README.es.md` describing `heightMode` and how to migrate.
- Grid documentation now refers to `heightMode` instead of `equalHeight`.
- Updated the equal-height example screens to show every mode.

# 0.2.2

- Fixed `equalHeight` row layout in `BreakifyGrid` and
  `BreakifyResponsiveGrid`: rows now use a dedicated render object that
  measures once and lays children out with a tight height, so `Spacer` and
  `Expanded` inside cards work. Children that cannot report intrinsic
  dimensions (such as `LayoutBuilder`) remain unsupported.
- Added an equal-height example with `Spacer`, `Expanded`, incomplete rows
  and a comparison with `equalHeight: false`.
- Split the `BreakifyResponsiveGrid` example into Basic and Equal Height
  screens, matching the `BreakifyGrid` example.
- Added the experimental `BreakifySection` widget for page and landing-page
  sections, with an optional background, alignment, responsive `padding` and
  `minHeight`, and `fullViewport`. Its API may change in future releases.
- Added a `BreakifySection` example to the example app.

# 0.2.1

- Fixed breakpoint resolution so each configured breakpoint is active at its
  exact minimum width, including custom configurations.
- Improved `BreakifyResponsiveGrid` documentation and coverage for automatic
  local-width column calculation, spacing, limits, and unbounded constraints.
- Added opt-in `equalHeight` support to `BreakifyResponsiveGrid`, reusing the
  existing equal-height row layout.
- Added the new Breakify logo and Brix mascot assets to the project identity.
- Updated `BreakifyDebugBanner` to resolve its breakpoint from local layout
  constraints, with a global-width fallback for unbounded layouts.
- Added new UI elements and improved the example application to provide a more
  complete demonstration of Breakify's features.


# 0.2.0

- Added `BreakifyPanelLayout` for responsive main-and-secondary panel layouts.
- Added `BreakifyResponsiveGrid` for automatic column calculation based on
  available width, including a finite fallback for unbounded width.
- Added local and global visibility modes to `BreakifyVisibility`.
- Expanded the example app and widget test coverage for the new functionality.
- Expanded the English and Spanish documentation with the new APIs, layout
  behavior, responsive modes, and configuration details.

## 0.1.1

- `BreakifyAdaptativeLayout`: added `stretchChildren`, which stretches
  children to share the same width when the layout is displayed as a
  `Column`. This mirrors the existing `distributeEvenly` behavior, which
  already did the equivalent for the `Row` layout.
- `BreakifyGrid`: added `equalHeight`, which makes every item in a row
  match the height of the tallest item in that row (and, as a side effect
  of the row layout, the same width as well). Intended for grids with
  items of varying intrinsic height. Currently only supported with
  `Axis.vertical`.
- `BreakifyGrid` and `BreakifyListView`: fixed horizontal scrolling
  (`scrollDirection: Axis.horizontal`). Both widgets now correctly detect
  unbounded constraints along the active scroll axis instead of always
  checking height, and `BreakifyGrid`'s `childAspectRatio` is now
  correctly resolved as width / height regardless of scroll direction.
- New README with explanatory images for each breakpoint, plus a Spanish
  translation (`README.es.md`).
- New, complete example app covering all widgets, including horizontal scrolling for BreakifyGrid and BreakifyListView.
- All existing functionality is preserved; the new options are opt-in
  and do not change the default behavior of existing widgets.

## 0.1.0

- Initial release.
- Responsive breakpoints.
- Responsive values.
- Fluid responsive values.
- Responsive container.
- Responsive layout.
- Responsive grid.
- Responsive list view.
- Responsive visibility.
- Debug banner.
