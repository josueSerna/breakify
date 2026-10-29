/// How the items of a grid get their height when it is content-driven.
///
/// When a grid's `heightMode` is null, items are sized from
/// `childAspectRatio` instead.
enum BreakifyHeightMode {
  /// Every item in the grid has exactly the same height: the tallest
  /// item's height across all rows.
  ///
  /// All rows are built eagerly, so avoid it for very large grids.
  equal,

  /// Every item keeps its own natural height.
  ///
  /// Items are aligned to the top of their row and the row is as tall as its
  /// tallest item. `Spacer` and `Expanded` inside a `Column` need a bounded
  /// height, so they are not supported in this mode.
  natural,

  /// Every item in a row has the same height: the tallest item of that row.
  ///
  /// Different rows may have different heights.
  equalInRow,
}
