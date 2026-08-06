import 'package:flexify/flexify.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FlexifyValue usa el valor más cercano disponible en los breakpoints',
      () {
    const value = FlexifyValue<int>(
      sm: 1,
      md: 2,
      lg: 3,
      xxl: 5,
    );

    expect(value.resolve(FlexifyBreakpoint.sm, 1), equals(1));
    expect(value.resolve(FlexifyBreakpoint.md, 2), equals(2));
    expect(value.resolve(FlexifyBreakpoint.lg, 3), equals(3));
    expect(value.resolve(FlexifyBreakpoint.xl, 3), equals(3));
    expect(value.resolve(FlexifyBreakpoint.xxl, 5), equals(5));
  });
}
