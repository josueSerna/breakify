import 'package:breakify/breakify.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BreakifyValue.resolve', () {
    const breakpoints = BreakifyBreakpoints.defaults;

    test('returns sm value', () {
      const value = BreakifyValue<int>(sm: 1);

      expect(
        value.resolve(BreakifyBreakpoint.sm, 640, breakpoints),
        1,
      );
    });

    test('returns md value when defined', () {
      const value = BreakifyValue<int>(
        sm: 1,
        md: 2,
      );

      expect(
        value.resolve(BreakifyBreakpoint.md, 768, breakpoints),
        2,
      );
    });

    test('returns lg value when defined', () {
      const value = BreakifyValue<int>(
        sm: 1,
        md: 2,
        lg: 3,
      );

      expect(
        value.resolve(BreakifyBreakpoint.lg, 1024, breakpoints),
        3,
      );
    });

    test('returns xl value when defined', () {
      const value = BreakifyValue<int>(
        sm: 1,
        md: 2,
        lg: 3,
        xl: 4,
      );

      expect(
        value.resolve(BreakifyBreakpoint.xl, 1280, breakpoints),
        4,
      );
    });

    test('returns xxl value when defined', () {
      const value = BreakifyValue<int>(
        sm: 1,
        md: 2,
        lg: 3,
        xl: 4,
        xxl: 5,
      );

      expect(
        value.resolve(BreakifyBreakpoint.xxl, 1536, breakpoints),
        5,
      );
    });

    test('falls back from md to sm', () {
      const value = BreakifyValue<int>(sm: 10);

      expect(
        value.resolve(BreakifyBreakpoint.md, 768, breakpoints),
        10,
      );
    });

    test('falls back from lg to md', () {
      const value = BreakifyValue<int>(
        sm: 10,
        md: 20,
      );

      expect(
        value.resolve(BreakifyBreakpoint.lg, 1024, breakpoints),
        20,
      );
    });

    test('falls back from xl to lg', () {
      const value = BreakifyValue<int>(
        sm: 10,
        md: 20,
        lg: 30,
      );

      expect(
        value.resolve(BreakifyBreakpoint.xl, 1280, breakpoints),
        30,
      );
    });

    test('falls back from xxl to xl', () {
      const value = BreakifyValue<int>(
        sm: 10,
        md: 20,
        lg: 30,
        xl: 40,
      );

      expect(
        value.resolve(BreakifyBreakpoint.xxl, 1536, breakpoints),
        40,
      );
    });

    test('supports String values', () {
      const value = BreakifyValue<String>(
        sm: 'mobile',
        lg: 'desktop',
      );

      expect(
        value.resolve(BreakifyBreakpoint.sm, 640, breakpoints),
        'mobile',
      );

      expect(
        value.resolve(BreakifyBreakpoint.md, 768, breakpoints),
        'mobile',
      );

      expect(
        value.resolve(BreakifyBreakpoint.lg, 1024, breakpoints),
        'desktop',
      );

      expect(
        value.resolve(BreakifyBreakpoint.xxl, 1600, breakpoints),
        'desktop',
      );
    });
  });
}
