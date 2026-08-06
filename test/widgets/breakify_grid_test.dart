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

  List<Widget> createChildren(int count) {
    return List.generate(
      count,
      (index) => Container(
        key: ValueKey(index),
        child: Text('Item $index'),
      ),
    );
  }

  group('BreakifyGrid', () {
    testWidgets('creates a GridView', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 900,
          child: BreakifyGrid(
            columns: const BreakifyValue(sm: 2),
            children: createChildren(6),
          ),
        ),
      );

      expect(find.byType(GridView), findsOneWidget);

      final grid = tester.widget<GridView>(
        find.byType(GridView),
      );

      expect(grid.semanticChildCount, 6);
    });

    testWidgets('uses responsive column count', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        createApp(
          width: 1200,
          child: BreakifyGrid(
            columns: const BreakifyValue(
              sm: 2,
              lg: 4,
            ),
            children: createChildren(4),
          ),
        ),
      );

      await tester.pump();

      final grid = tester.widget<GridView>(
        find.byType(GridView),
      );

      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

      expect(delegate.crossAxisCount, 4);
    });
    testWidgets('uses spacing for both axes', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 900,
          child: BreakifyGrid(
            columns: const BreakifyValue(sm: 2),
            spacing: const BreakifyValue(sm: 20),
            children: createChildren(2),
          ),
        ),
      );

      final delegate = (tester
          .widget<GridView>(find.byType(GridView))
          .gridDelegate as SliverGridDelegateWithFixedCrossAxisCount);

      expect(delegate.crossAxisSpacing, 20);
      expect(delegate.mainAxisSpacing, 20);
    });

    testWidgets('crossAxisSpacing overrides spacing', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 900,
          child: BreakifyGrid(
            columns: const BreakifyValue(sm: 2),
            spacing: const BreakifyValue(sm: 10),
            crossAxisSpacing: const BreakifyValue(sm: 40),
            children: createChildren(2),
          ),
        ),
      );

      final delegate = (tester
          .widget<GridView>(find.byType(GridView))
          .gridDelegate as SliverGridDelegateWithFixedCrossAxisCount);

      expect(delegate.crossAxisSpacing, 40);
      expect(delegate.mainAxisSpacing, 10);
    });

    testWidgets('mainAxisSpacing overrides spacing', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 900,
          child: BreakifyGrid(
            columns: const BreakifyValue(sm: 2),
            spacing: const BreakifyValue(sm: 10),
            mainAxisSpacing: const BreakifyValue(sm: 32),
            children: createChildren(2),
          ),
        ),
      );

      final delegate = (tester
          .widget<GridView>(find.byType(GridView))
          .gridDelegate as SliverGridDelegateWithFixedCrossAxisCount);

      expect(delegate.crossAxisSpacing, 10);
      expect(delegate.mainAxisSpacing, 32);
    });

    testWidgets('uses childAspectRatio', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 900,
          child: BreakifyGrid(
            columns: const BreakifyValue(sm: 2),
            childAspectRatio: const BreakifyValue(sm: 1.5),
            children: createChildren(2),
          ),
        ),
      );

      final delegate = (tester
          .widget<GridView>(find.byType(GridView))
          .gridDelegate as SliverGridDelegateWithFixedCrossAxisCount);

      expect(delegate.childAspectRatio, 1.5);
    });

    testWidgets('passes shrinkWrap', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 900,
          child: BreakifyGrid(
            shrinkWrap: true,
            columns: const BreakifyValue(sm: 2),
            children: createChildren(2),
          ),
        ),
      );

      final grid = tester.widget<GridView>(
        find.byType(GridView),
      );

      expect(grid.shrinkWrap, isTrue);
    });

    testWidgets('passes scrollDirection', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 900,
          child: BreakifyGrid(
            scrollDirection: Axis.horizontal,
            columns: const BreakifyValue(sm: 2),
            children: createChildren(2),
          ),
        ),
      );

      final grid = tester.widget<GridView>(
        find.byType(GridView),
      );

      expect(grid.scrollDirection, Axis.horizontal);
    });

    testWidgets('passes padding', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 900,
          child: BreakifyGrid(
            padding: const EdgeInsets.all(24),
            columns: const BreakifyValue(sm: 2),
            children: createChildren(2),
          ),
        ),
      );

      final grid = tester.widget<GridView>(
        find.byType(GridView),
      );

      expect(grid.padding, const EdgeInsets.all(24));
    });
  });
}
