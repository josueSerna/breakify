import 'package:flutter/widgets.dart';

enum _BreakifyLayoutKind { inRow, inColumn, twoRows, twoColumns, custom }

/// A distribution of the children of a `BreakifyAdaptativeLayout`.
///
/// Children are always referenced by their position in the original
/// `children` list; they are never duplicated or reordered.
///
/// ## Predefined templates
///
/// | Template      | Result                                           |
/// |---------------|--------------------------------------------------|
/// | [inRow]       | All children in a single row.                    |
/// | [inColumn]    | All children in a single column.                 |
/// | [twoRows]     | Two rows, one below the other.                   |
/// | [twoColumns]  | Two columns, side by side.                       |
/// | [custom]      | Two columns with explicitly chosen children.     |
///
/// ## Assignment convention for two groups
///
/// For [twoRows] and [twoColumns] the children are split in order:
/// the first group receives the first `ceil(n / 2)` children and the
/// second group receives the rest. With 3 children, the first group holds
/// indices `0` and `1` and the second group holds index `2`. With a single
/// child only one group is rendered.
///
/// For [twoRows] the first group is the top row and the second is the
/// bottom row. For [twoColumns] and [custom] the first group is the left
/// column and the second is the right column.
///
/// Use [custom] to control the assignment explicitly:
///
/// ```dart
/// BreakifyLayoutTemplate.custom(
///   left: [0, 1],
///   right: [2],
/// )
/// ```
///
/// Both lists contain indices of the original `children` list. Every
/// index must appear exactly once, otherwise an error is thrown in
/// debug mode.
class BreakifyLayoutTemplate {
  /// All children in a single row.
  static const BreakifyLayoutTemplate inRow =
      BreakifyLayoutTemplate._(_BreakifyLayoutKind.inRow);

  /// All children in a single column.
  static const BreakifyLayoutTemplate inColumn =
      BreakifyLayoutTemplate._(_BreakifyLayoutKind.inColumn);

  /// Two horizontal groups, one below the other.
  ///
  /// The first `ceil(n / 2)` children go in the top row and
  /// the remaining children go in the bottom row.
  static const BreakifyLayoutTemplate twoRows =
      BreakifyLayoutTemplate._(_BreakifyLayoutKind.twoRows);

  /// Two vertical groups, side by side.
  ///
  /// The first `ceil(n / 2)` children go in the left column and
  /// the remaining children go in the right column.
  static const BreakifyLayoutTemplate twoColumns =
      BreakifyLayoutTemplate._(_BreakifyLayoutKind.twoColumns);

  final _BreakifyLayoutKind _kind;
  final List<int>? _left;
  final List<int>? _right;

  const BreakifyLayoutTemplate._(this._kind)
      : _left = null,
        _right = null;

  /// Two columns whose content is chosen with indices of the
  /// original `children` list.
  ///
  /// [left] is the first column and [right] is the second one.
  /// Children are displayed in the order the indices are listed.
  /// Every child must be listed exactly once and neither list may
  /// be empty.
  const BreakifyLayoutTemplate.custom({
    required List<int> left,
    required List<int> right,
  })  : _kind = _BreakifyLayoutKind.custom,
        _left = left,
        _right = right;

  /// Axis along which the groups returned by [resolveGroups] are placed.
  ///
  /// The children inside each group are laid out along the
  /// perpendicular axis.
  Axis get groupsAxis {
    switch (_kind) {
      case _BreakifyLayoutKind.inRow:
      case _BreakifyLayoutKind.twoRows:
        return Axis.vertical;
      case _BreakifyLayoutKind.inColumn:
      case _BreakifyLayoutKind.twoColumns:
      case _BreakifyLayoutKind.custom:
        return Axis.horizontal;
    }
  }

  /// Returns the groups of child indices for [childCount] children.
  ///
  /// Empty groups are omitted. For [custom], indices are validated
  /// (in debug mode) against [childCount].
  ///
  /// This is used internally by `BreakifyAdaptativeLayout`.
  List<List<int>> resolveGroups(int childCount) {
    final all = List<int>.generate(childCount, (i) => i);

    switch (_kind) {
      case _BreakifyLayoutKind.inRow:
      case _BreakifyLayoutKind.inColumn:
        return [if (all.isNotEmpty) all];
      case _BreakifyLayoutKind.twoRows:
      case _BreakifyLayoutKind.twoColumns:
        final split = (childCount + 1) ~/ 2;
        return [
          if (split > 0) all.sublist(0, split),
          if (split < childCount) all.sublist(split),
        ];
      case _BreakifyLayoutKind.custom:
        assert(() {
          _validateCustom(childCount);
          return true;
        }());
        return [_left!, _right!];
    }
  }

  void _validateCustom(int childCount) {
    if (_left!.isEmpty || _right!.isEmpty) {
      throw FlutterError(
        'BreakifyLayoutTemplate.custom: left and right cannot be empty.',
      );
    }
    final seen = <int>{};
    for (final index in [..._left!, ..._right!]) {
      if (index < 0 || index >= childCount) {
        throw FlutterError(
          'BreakifyLayoutTemplate.custom: index $index is out of range '
          'for $childCount children.',
        );
      }
      if (!seen.add(index)) {
        throw FlutterError(
          'BreakifyLayoutTemplate.custom: index $index is repeated.',
        );
      }
    }
    if (seen.length != childCount) {
      final missing = [
        for (var i = 0; i < childCount; i++)
          if (!seen.contains(i)) i,
      ];
      throw FlutterError(
        'BreakifyLayoutTemplate.custom: children $missing are not '
        'assigned to any group.',
      );
    }
  }
}
