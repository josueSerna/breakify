import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createApp(Widget child) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: child,
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

  group('BreakifyBuilder', () {
    testWidgets(
      'resolves the correct breakpoint',
      (tester) async {
        await pumpWithSize(
          tester,
          size: const Size(1024, 800),
          child: BreakifyBuilder(
            builder: (_, breakpoint, constraints) {
              expect(constraints.maxWidth, 1024);
              expect(breakpoint, BreakifyBreakpoint.lg);
              return const SizedBox();
            },
          ),
        );
      },
    );

    testWidgets(
      'provides layout constraints',
      (tester) async {
        await pumpWithSize(
          tester,
          size: const Size(900, 800),
          child: BreakifyBuilder(
            builder: (_, __, constraints) {
              expect(constraints.maxWidth, 900);
              return const SizedBox();
            },
          ),
        );
      },
    );

    testWidgets(
      'uses custom breakpoints',
      (tester) async {
        const custom = BreakifyBreakpoints(
          sm: 400,
          md: 600,
          lg: 800,
          xl: 1000,
          xxl: 1200,
        );

        await pumpWithSize(
          tester,
          size: const Size(850, 800),
          child: BreakifyBuilder(
            breakpoints: custom,
            builder: (_, breakpoint, constraints) {
              expect(constraints.maxWidth, 850);
              expect(breakpoint, BreakifyBreakpoint.lg);
              return const SizedBox();
            },
          ),
        );
      },
    );

    testWidgets(
      'rebuilds with a different breakpoint after resizing',
      (tester) async {
        Future<void> pump(double width) async {
          tester.view.physicalSize = Size(width, 800);
          tester.view.devicePixelRatio = 1.0;

          await tester.pumpWidget(
            createApp(
              BreakifyBuilder(
                builder: (_, breakpoint, __) {
                  return Text(breakpoint.name);
                },
              ),
            ),
          );
        }

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await pump(700);
        expect(find.text('sm'), findsOneWidget);

        await pump(1024);
        expect(find.text('lg'), findsOneWidget);
      },
    );
  });
}
