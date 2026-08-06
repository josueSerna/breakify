import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createApp({
    required double width,
    required Widget child,
  }) {
    return MediaQuery(
      data: MediaQueryData(size: Size(width, 800)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: BreakifyScope(
          child: child,
        ),
      ),
    );
  }

  group('BreakifyContainer', () {
    testWidgets('renders its child', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 800,
          child: const BreakifyContainer(
            child: Text('Hello'),
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('applies responsive padding', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 800,
          child: const BreakifyContainer(
            padding: BreakifyValue(
              sm: EdgeInsets.all(16),
            ),
            child: Text('Padding'),
          ),
        ),
      );

      final padding = tester.widget<Padding>(find.byType(Padding).first);

      expect(
        padding.padding,
        const EdgeInsets.all(16),
      );
    });

    testWidgets('applies margin', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 800,
          child: const BreakifyContainer(
            margin: EdgeInsets.all(20),
            child: Text('Margin'),
          ),
        ),
      );

      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('uses Align internally', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 800,
          child: const BreakifyContainer(
            alignment: Alignment.bottomCenter,
            child: Text('Align'),
          ),
        ),
      );

      final align = tester.widget<Align>(
        find.byType(Align),
      );

      expect(
        align.alignment,
        Alignment.bottomCenter,
      );
    });

    testWidgets('creates constrained content', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 1400,
          child: const BreakifyContainer(
            maxWidth: BreakifyValue(sm: 900.0),
            child: Text('Width'),
          ),
        ),
      );

      expect(find.byType(ConstrainedBox), findsOneWidget);
    });

    testWidgets('supports custom breakpoints', (tester) async {
      const custom = BreakifyBreakpoints(
        sm: 400,
        md: 600,
        lg: 800,
        xl: 1000,
        xxl: 1200,
      );

      await tester.pumpWidget(
        createApp(
          width: 900,
          child: const BreakifyContainer(
            breakpoints: custom,
            maxWidth: BreakifyValue(
              sm: 500.0,
              lg: 800.0,
            ),
            child: Text('Custom'),
          ),
        ),
      );

      expect(find.text('Custom'), findsOneWidget);
    });
  });
}
