import 'package:breakify/breakify.dart';
import 'package:flutter/widgets.dart';
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
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: width,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  const secondaryPanels = [
    Text('Secondary 1'),
    Text('Secondary 2'),
  ];

  group('BreakifyPanelLayout', () {
    testWidgets('stacks the main and secondary panels below breakpoint',
        (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 700,
          child: const BreakifyPanelLayout(
            mainPanel: Text('Main'),
            secondaryPanels: secondaryPanels,
            breakpoint: BreakifyBreakpoint.lg,
            spacing: BreakifyValue(sm: 16),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNothing);
      expect(find.text('Main'), findsOneWidget);
      expect(find.text('Secondary 1'), findsOneWidget);
    });

    testWidgets('uses a row with a secondary column at breakpoint',
        (tester) async {
      await tester.binding.setSurfaceSize(const Size(1100, 800));
      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        createApp(
          width: 1100,
          child: const BreakifyPanelLayout(
            mainPanel: Text('Main'),
            secondaryPanels: secondaryPanels,
            breakpoint: BreakifyBreakpoint.lg,
            spacing: BreakifyValue(sm: 16),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('applies the configured flex values', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1100, 800));
      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        createApp(
          width: 1100,
          child: const BreakifyPanelLayout(
            mainPanel: Text('Main'),
            secondaryPanels: secondaryPanels,
            breakpoint: BreakifyBreakpoint.lg,
            spacing: BreakifyValue(sm: 16),
            mainFlex: 3,
            secondaryFlex: 2,
          ),
        ),
      );

      final expanded = tester.widgetList<Expanded>(find.byType(Expanded));

      expect(expanded.map((widget) => widget.flex), containsAll(<int>[3, 2]));
    });

    testWidgets('uses vertical spacing below breakpoint', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 700,
          child: const BreakifyPanelLayout(
            mainPanel: Text('Main'),
            secondaryPanels: secondaryPanels,
            breakpoint: BreakifyBreakpoint.lg,
            spacing: BreakifyValue(sm: 20),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.height == 20,
        ),
        findsNWidgets(2),
      );
    });

    testWidgets('keeps a column when there are no secondary panels',
        (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 1100,
          child: const BreakifyPanelLayout(
            mainPanel: Text('Main'),
            secondaryPanels: [],
            breakpoint: BreakifyBreakpoint.lg,
            spacing: BreakifyValue(sm: 16),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNothing);
    });
  });
}
