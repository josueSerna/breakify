import 'package:flexify/src/breakpoints/flexify_breakpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FlexifyBreakpoints.resolve', () {
    const bp = FlexifyBreakpoints.defaults;

    test('un ancho muy chico resuelve a sm', () {
      expect(bp.resolve(200), FlexifyBreakpoint.sm);
    });

    test('un ancho exactamente igual a md resuelve a md', () {
      expect(bp.resolve(bp.md), FlexifyBreakpoint.md);
    });

    test('un ancho gigante resuelve a xxl', () {
      expect(bp.resolve(5000), FlexifyBreakpoint.xxl);
    });
  });

  test('copyWith solo cambia lo que le pasas', () {
    final custom = FlexifyBreakpoints.defaults.copyWith(
      md: 900,
    );

    expect(custom.sm, FlexifyBreakpoints.defaults.sm);
    expect(custom.md, 900);
    expect(custom.lg, FlexifyBreakpoints.defaults.lg);
    expect(custom.xl, FlexifyBreakpoints.defaults.xl);
    expect(custom.xxl, FlexifyBreakpoints.defaults.xxl);
  });
}
