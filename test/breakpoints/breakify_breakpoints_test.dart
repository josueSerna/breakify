import 'package:breakify/breakify.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BreakifyBreakpoints.resolve', () {
    const breakpoints = BreakifyBreakpoints.defaults;

    test('returns sm for widths below md', () {
      expect(breakpoints.resolve(0), BreakifyBreakpoint.sm);
      expect(breakpoints.resolve(320), BreakifyBreakpoint.sm);
      expect(breakpoints.resolve(639), BreakifyBreakpoint.sm);
    });

    test('returns md at and above md width', () {
      expect(breakpoints.resolve(768), BreakifyBreakpoint.md);
      expect(breakpoints.resolve(900), BreakifyBreakpoint.md);
      expect(breakpoints.resolve(1023), BreakifyBreakpoint.md);
    });

    test('returns lg at and above lg width', () {
      expect(breakpoints.resolve(1024), BreakifyBreakpoint.lg);
      expect(breakpoints.resolve(1200), BreakifyBreakpoint.lg);
      expect(breakpoints.resolve(1279), BreakifyBreakpoint.lg);
    });

    test('returns xl at and above xl width', () {
      expect(breakpoints.resolve(1280), BreakifyBreakpoint.xl);
      expect(breakpoints.resolve(1400), BreakifyBreakpoint.xl);
      expect(breakpoints.resolve(1535), BreakifyBreakpoint.xl);
    });

    test('returns xxl at and above xxl width', () {
      expect(breakpoints.resolve(1536), BreakifyBreakpoint.xxl);
      expect(breakpoints.resolve(1800), BreakifyBreakpoint.xxl);
      expect(breakpoints.resolve(5000), BreakifyBreakpoint.xxl);
    });
  });

  group('BreakifyBreakpoints.valueOf', () {
    const breakpoints = BreakifyBreakpoints.defaults;

    test('returns the correct width for each breakpoint', () {
      expect(breakpoints.valueOf(BreakifyBreakpoint.sm), 640);
      expect(breakpoints.valueOf(BreakifyBreakpoint.md), 768);
      expect(breakpoints.valueOf(BreakifyBreakpoint.lg), 1024);
      expect(breakpoints.valueOf(BreakifyBreakpoint.xl), 1280);
      expect(breakpoints.valueOf(BreakifyBreakpoint.xxl), 1536);
    });
  });

  group('BreakifyBreakpoints.copyWith', () {
    test('copies values while replacing specified ones', () {
      const original = BreakifyBreakpoints.defaults;

      final updated = original.copyWith(
        md: 800,
        lg: 1100,
      );

      expect(updated.sm, 640);
      expect(updated.md, 800);
      expect(updated.lg, 1100);
      expect(updated.xl, 1280);
      expect(updated.xxl, 1536);
    });
  });

  group('BreakifyBreakpoints constructor', () {
    test('throws AssertionError when breakpoints are not ascending', () {
      expect(
        () => BreakifyBreakpoints(
          sm: 700,
          md: 600,
          lg: 1024,
          xl: 1280,
          xxl: 1536,
        ),
        throwsAssertionError,
      );
    });
  });
}
