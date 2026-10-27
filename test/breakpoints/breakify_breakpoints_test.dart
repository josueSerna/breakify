import 'package:breakify/breakify.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BreakifyBreakpoints.resolve', () {
    const breakpoints = BreakifyBreakpoints(
      sm: 640,
      md: 768,
      lg: 1024,
      xl: 1400,
      xxl: 1600,
    );

    test('resolves just below, at, and just above every threshold', () {
      final cases = <(double, BreakifyBreakpoint)>[
        (639.999, BreakifyBreakpoint.sm),
        (640, BreakifyBreakpoint.sm),
        (640.001, BreakifyBreakpoint.sm),
        (767.999, BreakifyBreakpoint.sm),
        (768, BreakifyBreakpoint.md),
        (768.001, BreakifyBreakpoint.md),
        (1023.999, BreakifyBreakpoint.md),
        (1024, BreakifyBreakpoint.lg),
        (1024.001, BreakifyBreakpoint.lg),
        (1399.999, BreakifyBreakpoint.lg),
        (1400, BreakifyBreakpoint.xl),
        (1400.001, BreakifyBreakpoint.xl),
        (1599.999, BreakifyBreakpoint.xl),
        (1600, BreakifyBreakpoint.xxl),
        (1600.001, BreakifyBreakpoint.xxl),
      ];

      for (final (width, expected) in cases) {
        expect(breakpoints.resolve(width), expected, reason: '$width');
      }
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
