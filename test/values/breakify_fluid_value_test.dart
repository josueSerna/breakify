import 'package:breakify/breakify.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BreakifyFluidValue.resolve', () {
    const breakpoints = BreakifyBreakpoints.defaults;

    test('returns the first value before the first breakpoint', () {
      const value = BreakifyFluidValue(
        sm: 8,
        md: 16,
      );

      expect(
        value.resolve(BreakifyBreakpoint.sm, 300, breakpoints),
        8,
      );
    });

    test('returns the exact value at breakpoints', () {
      const value = BreakifyFluidValue(
        sm: 8,
        md: 16,
        lg: 24,
        xl: 32,
        xxl: 40,
      );

      expect(
        value.resolve(BreakifyBreakpoint.sm, 640, breakpoints),
        8,
      );

      expect(
        value.resolve(BreakifyBreakpoint.md, 768, breakpoints),
        16,
      );

      expect(
        value.resolve(BreakifyBreakpoint.lg, 1024, breakpoints),
        24,
      );

      expect(
        value.resolve(BreakifyBreakpoint.xl, 1280, breakpoints),
        32,
      );

      expect(
        value.resolve(BreakifyBreakpoint.xxl, 1536, breakpoints),
        40,
      );
    });

    test('interpolates between sm and md', () {
      const value = BreakifyFluidValue(
        sm: 8,
        md: 16,
      );

      final result = value.resolve(
        BreakifyBreakpoint.sm,
        704,
        breakpoints,
      );

      expect(result, closeTo(12, 0.001));
    });

    test('interpolates between md and lg', () {
      const value = BreakifyFluidValue(
        sm: 8,
        md: 16,
        lg: 24,
      );

      final result = value.resolve(
        BreakifyBreakpoint.md,
        896,
        breakpoints,
      );

      expect(result, closeTo(20, 0.001));
    });

    test('returns last value after last breakpoint', () {
      const value = BreakifyFluidValue(
        sm: 8,
        md: 16,
        lg: 24,
      );

      expect(
        value.resolve(BreakifyBreakpoint.xxl, 4000, breakpoints),
        24,
      );
    });

    test('skips undefined breakpoints', () {
      const value = BreakifyFluidValue(
        sm: 10,
        xl: 30,
      );

      final result = value.resolve(
        BreakifyBreakpoint.md,
        960,
        breakpoints,
      );

      expect(result, greaterThan(10));
      expect(result, lessThan(30));
    });
  });

  group('BreakifyFluidValue.resolveRounded', () {
    const breakpoints = BreakifyBreakpoints.defaults;

    test('rounds interpolated values', () {
      const value = BreakifyFluidValue(
        sm: 8,
        md: 15,
      );

      final rounded = value.resolveRounded(
        BreakifyBreakpoint.sm,
        704,
        breakpoints,
      );

      expect(rounded, 12);
    });
  });
}
