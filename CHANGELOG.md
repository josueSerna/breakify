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
