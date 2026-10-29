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
