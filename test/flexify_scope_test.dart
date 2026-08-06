import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('context.breakpoint resolves according to screen width',
      (tester) async {
    tester.view.physicalSize = const Size(1300, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    FlexifyBreakpoint? captured;

    await tester.pumpWidget(
      FlexifyScope(
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              captured = context.breakpoint;
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    // 1300px cae en 'lg' con los breakpoints por defecto (lg: 1024, xl: 1280)
    expect(captured, FlexifyBreakpoint.xl);
  });

  testWidgets('context.resolve resolves FlexifyValue correctly',
      (tester) async {
    tester.view.physicalSize = const Size(500, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    int? columns;

    await tester.pumpWidget(
      FlexifyScope(
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              columns = context.resolve(
                const FlexifyValue(sm: 1, md: 2, lg: 3),
              );
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(columns, 1); // 500px cae en 'sm'
  });

  testWidgets('throws assertion error without FlexifyScope', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            expect(() => context.breakpoint, throwsAssertionError);
            return const SizedBox();
          },
        ),
      ),
    );
  });
}
