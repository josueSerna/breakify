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
          child: SizedBox(
            width: width,
            child: child,
          ),
        ),
      ),
    );
  }

  List<Widget> children() {
    return const [
      Text('One'),
      Text('Two'),
    ];
  }

  group('BreakifyAdaptativeLayout', () {
    testWidgets('uses Column below breakpoint', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(700, 800),
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        createApp(
          width: 700,
          child: BreakifyAdaptativeLayout(
            breakpoint: BreakifyBreakpoint.lg,
            spacing: const BreakifyValue(sm: 20),
            children: children(),
          ),
        ),
      );

      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Row), findsNothing);
    });

    testWidgets('uses Row at breakpoint and above', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(1100, 800),
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        createApp(
          width: 1100,
          child: BreakifyAdaptativeLayout(
            breakpoint: BreakifyBreakpoint.lg,
            spacing: const BreakifyValue(sm: 20),
            children: children(),
          ),
        ),
      );

      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Column), findsNothing);
    });

    testWidgets('applies vertical spacing in Column mode', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(700, 800),
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        createApp(
          width: 700,
          child: BreakifyAdaptativeLayout(
            breakpoint: BreakifyBreakpoint.lg,
            spacing: const BreakifyValue(sm: 16),
            children: children(),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.height == 16,
        ),
        findsOneWidget,
      );
    });

    testWidgets('applies horizontal spacing in Row mode', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(1200, 800),
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        createApp(
          width: 1200,
          child: BreakifyAdaptativeLayout(
            breakpoint: BreakifyBreakpoint.lg,
            spacing: const BreakifyValue(sm: 24),
            children: children(),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == 24,
        ),
        findsOneWidget,
      );
    });

    testWidgets('uses Flexible when distributeEvenly is false', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(1200, 800),
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        createApp(
          width: 1200,
          child: BreakifyAdaptativeLayout(
            breakpoint: BreakifyBreakpoint.md,
            spacing: const BreakifyValue(sm: 10),
            distributeEvenly: false,
            children: children(),
          ),
        ),
      );

      expect(find.byType(Flexible), findsNWidgets(2));
      expect(find.byType(Expanded), findsNothing);
    });

    testWidgets('uses Expanded when distributeEvenly is true', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(1200, 800),
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        createApp(
          width: 1200,
          child: BreakifyAdaptativeLayout(
            breakpoint: BreakifyBreakpoint.md,
            spacing: const BreakifyValue(sm: 10),
            distributeEvenly: true,
            children: children(),
          ),
        ),
      );

      expect(find.byType(Expanded), findsNWidgets(2));
      expect(find.byType(Flexible), findsNothing);
    });

    testWidgets('passes alignments', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(1200, 800),
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        createApp(
          width: 1200,
          child: BreakifyAdaptativeLayout(
            breakpoint: BreakifyBreakpoint.md,
            spacing: const BreakifyValue(sm: 10),
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: children(),
          ),
        ),
      );

      final row = tester.widget<Row>(
        find.byType(Row),
      );

      expect(
        row.mainAxisAlignment,
        MainAxisAlignment.center,
      );

      expect(
        row.crossAxisAlignment,
        CrossAxisAlignment.end,
      );
    });
  });
}
