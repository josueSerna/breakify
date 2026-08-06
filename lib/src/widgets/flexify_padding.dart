import 'package:flutter/widgets.dart';

import '../scope/flexify_scope.dart';
import '../values/flexify_resolvable.dart';

/// Applies responsive padding around its child.
///
/// The padding value can change based on the current breakpoint
/// by using [FlexifyValue].
///
/// ```dart
/// FlexifyPadding(
///   padding: const FlexifyValue(
///     sm: EdgeInsets.all(8),
///     lg: EdgeInsets.all(24),
///   ),
///   child: const Text('Hello'),
/// )
/// ```
///
/// Requires a [FlexifyScope] ancestor.
class FlexifyPadding extends StatelessWidget {
  /// Responsive padding applied around [child].
  final FlexifyResolvable<EdgeInsetsGeometry> padding;

  /// Widget displayed inside the padding.
  final Widget child;

  const FlexifyPadding({
    super.key,
    required this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.resolve(padding),
      child: child,
    );
  }
}
