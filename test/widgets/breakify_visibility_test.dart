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
  });
}
