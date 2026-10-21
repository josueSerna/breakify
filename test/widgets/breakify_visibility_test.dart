import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createApp(Widget child) {
    return BreakifyScope(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: child,
      ),
    );
  }

  Future<void> pumpWithSize(
    WidgetTester tester, {
    required Size size,
    required Widget child,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createApp(child));
  }

  group('BreakifyVisibility', () {
    testWidgets(
      'shows child when current breakpoint is within minBreakpoint',
      (tester) async {
        await pumpWithSize(
          tester,
          size: const Size(1024, 800),
          child: const BreakifyVisibility(
            minBreakpoint: BreakifyBreakpoint.lg,
            child: Text('Visible'),
          ),
        );

        expect(find.text('Visible'), findsOneWidget);
      },
    );

    testWidgets(
      'hides child below minBreakpoint',
      (tester) async {
        await pumpWithSize(
          tester,
          size: const Size(700, 800),
          child: const BreakifyVisibility(
            minBreakpoint: BreakifyBreakpoint.md,
            child: Text('Visible'),
          ),
        );

        expect(find.text('Visible'), findsNothing);
      },
    );

    testWidgets(
      'shows child below maxBreakpoint',
      (tester) async {
        await pumpWithSize(
          tester,
          size: const Size(700, 800),
          child: const BreakifyVisibility(
            maxBreakpoint: BreakifyBreakpoint.md,
            child: Text('Visible'),
          ),
        );

        expect(find.text('Visible'), findsOneWidget);
      },
    );

    testWidgets(
      'hides child above maxBreakpoint',
      (tester) async {
        await pumpWithSize(
          tester,
          size: const Size(1300, 800),
          child: const BreakifyVisibility(
            maxBreakpoint: BreakifyBreakpoint.md,
            child: Text('Visible'),
          ),
        );

        expect(find.text('Visible'), findsNothing);
      },
    );

    testWidgets(
      'shows replacement when hidden',
      (tester) async {
        await pumpWithSize(
          tester,
          size: const Size(700, 800),
          child: const BreakifyVisibility(
            minBreakpoint: BreakifyBreakpoint.lg,
            replacement: Text('Replacement'),
            child: Text('Visible'),
          ),
        );

        expect(find.text('Visible'), findsNothing);
        expect(find.text('Replacement'), findsOneWidget);
      },
    );

    testWidgets(
      'supports visibleIn constructor',
      (tester) async {
        await pumpWithSize(
          tester,
          size: const Size(1300, 800),
          child: BreakifyVisibility.only(
            visibleIn: const {
              BreakifyBreakpoint.xl,
            },
            child: const Text('Visible'),
          ),
        );

        expect(find.text('Visible'), findsOneWidget);
      },
    );

    testWidgets(
      'visibleIn hides child when breakpoint is not included',
      (tester) async {
        await pumpWithSize(
          tester,
          size: const Size(1024, 800),
          child: BreakifyVisibility.only(
            visibleIn: const {
              BreakifyBreakpoint.sm,
              BreakifyBreakpoint.xl,
            },
            child: const Text('Visible'),
          ),
        );

        expect(find.text('Visible'), findsNothing);
      },
    );

    testWidgets(
      'global mode uses the scope width',
      (tester) async {
        await pumpWithSize(
          tester,
          size: const Size(1400, 800),
          child: Align(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 700,
                maxWidth: 700,
              ),
              child: BreakifyVisibility(
                minBreakpoint: BreakifyBreakpoint.lg,
                mode: BreakifyVisibilityMode.global,
                child: Text('Global'),
              ),
            ),
          ),
        );

        expect(find.text('Global'), findsOneWidget);
      },
    );

    testWidgets(
      'local mode uses the available width',
      (tester) async {
        await pumpWithSize(
          tester,
          size: const Size(1400, 800),
          child: Align(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 700,
                maxWidth: 700,
              ),
              child: const BreakifyVisibility(
                minBreakpoint: BreakifyBreakpoint.lg,
                mode: BreakifyVisibilityMode.local,
                child: Text('Local'),
              ),
            ),
          ),
        );

        expect(find.text('Local'), findsNothing);
      },
    );

    testWidgets(
      'local mode falls back to the scope width when unbounded',
      (tester) async {
        await pumpWithSize(
          tester,
          size: const Size(1400, 800),
          child: const UnconstrainedBox(
            child: BreakifyVisibility(
              minBreakpoint: BreakifyBreakpoint.lg,
              mode: BreakifyVisibilityMode.local,
              child: Text('Fallback'),
            ),
          ),
        );

        expect(find.text('Fallback'), findsOneWidget);
      },
    );
  });
}
