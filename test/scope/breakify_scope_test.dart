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

  group('BreakifyScope', () {
    testWidgets(
      'provides the current breakpoint',
      (tester) async {
        await pumpWithSize(
          tester,
          size: const Size(1024, 800),
          child: Builder(
            builder: (context) {
              expect(context.breakpoint, BreakifyBreakpoint.lg);
              return const SizedBox();
            },
          ),
        );
      },
    );

    testWidgets(
      'provides the current screen width',
      (tester) async {
        await pumpWithSize(
          tester,
          size: const Size(900, 800),
          child: Builder(
            builder: (context) {
              expect(context.breakifyWidth, 900);
              return const SizedBox();
            },
          ),
        );
      },
    );

    testWidgets(
      'provides the active breakpoint configuration',
      (tester) async {
        const customBreakpoints = BreakifyBreakpoints(
          sm: 500,
          md: 700,
          lg: 900,
          xl: 1100,
          xxl: 1400,
        );

        tester.view.physicalSize = const Size(950, 800);
        tester.view.devicePixelRatio = 1;

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          BreakifyScope(
            breakpoints: customBreakpoints,
            child: Builder(
              builder: (context) {
                expect(
                  context.breakifyBreakpoints,
                  customBreakpoints,
                );
                expect(context.breakpoint, BreakifyBreakpoint.lg);
                return const SizedBox();
              },
            ),
          ),
        );
      },
    );

    testWidgets(
      'context.resolve resolves BreakifyValue',
      (tester) async {
        await pumpWithSize(
          tester,
          size: const Size(1024, 800),
          child: Builder(
            builder: (context) {
              final value = context.resolve(
                const BreakifyValue<int>(
                  sm: 1,
                  md: 2,
                  lg: 3,
                ),
              );

              expect(value, 3);
              return const SizedBox();
            },
          ),
        );
      },
    );

    testWidgets(
      'context.resolve resolves BreakifyFluidValue',
      (tester) async {
        await pumpWithSize(
          tester,
          size: const Size(768, 800),
          child: Builder(
            builder: (context) {
              final value = context.resolve(
                const BreakifyFluidValue(
                  sm: 10,
                  md: 20,
                ),
              );

              expect(value, 20);
              return const SizedBox();
            },
          ),
        );
      },
    );
  });
}
