import 'package:flexify/src/breakpoints/flexify_breakpoints.dart';
import 'package:flexify/src/builders/flexify_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'FlexifyBuilder detecta sm en pantallas angostas',
    (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: FlexifyBuilder(
            builder: (context, breakpoint, constraints) {
              return Text(
                breakpoint.toString(),
                textDirection: TextDirection.ltr,
              );
            },
          ),
        ),
      );

      expect(
        find.text(FlexifyBreakpoint.sm.toString()),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'FlexifyBuilder detecta xxl en pantallas anchas',
    (tester) async {
      tester.view.physicalSize = const Size(1600, 900);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: FlexifyBuilder(
            builder: (context, breakpoint, constraints) {
              return Text(
                breakpoint.toString(),
                textDirection: TextDirection.ltr,
              );
            },
          ),
        ),
      );

      expect(
        find.text(FlexifyBreakpoint.xxl.toString()),
        findsOneWidget,
      );
    },
  );
}
