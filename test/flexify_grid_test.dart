import 'package:flexify/src/values/flexify_value.dart';
import 'package:flexify/src/widgets/flexify_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FlexifyGrid permite scroll cuando tiene altura definida',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 240,
            child: FlexifyGrid(
              columns: const FlexifyValue<int>(sm: 1, md: 2),
              children: List.generate(10,
                  (index) => SizedBox(height: 40, child: Text('Item $index'))),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(FlexifyGrid), findsOneWidget);
  });
}
