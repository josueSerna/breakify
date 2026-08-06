import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('la API pública expone los tipos principales del paquete', () {
    const breakpoints = FlexifyBreakpoints.defaults;
    final value = FlexifyValue<int>(
      sm: 1,
      md: 2,
      lg: 3,
      xl: 4,
      xxl: 5,
    );

    expect(breakpoints.resolve(500), FlexifyBreakpoint.sm);
    expect(value.resolve(FlexifyBreakpoint.md, 500), 2);
  });

  testWidgets(
      'FlexifyGrid y FlexifyContainer se pueden construir desde la API pública',
      (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FlexifyContainer(
            padding: const EdgeInsets.all(8),
            child: FlexifyGrid(
              columns: FlexifyValue<int>(sm: 1, md: 2),
              children: const [SizedBox(height: 40), SizedBox(height: 40)],
            ),
          ),
        ),
      ),
    );

    expect(find.byType(FlexifyGrid), findsOneWidget);
    expect(find.byType(FlexifyContainer), findsOneWidget);
  });
}
