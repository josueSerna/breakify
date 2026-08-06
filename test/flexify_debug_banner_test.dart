import 'package:flexify/src/widgets/flexify_debug_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'FlexifyDebugBanner usa el ancho del contenedor padre y no se queda en xxl',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                child: FlexifyDebugBanner(
                  enabled: true,
                  child: Container(
                    height: 120,
                    color: Colors.blue.shade100,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(FlexifyDebugBanner), findsOneWidget);
      expect(find.textContaining('·'), findsOneWidget);
    },
  );
}
