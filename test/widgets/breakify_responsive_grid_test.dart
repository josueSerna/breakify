import 'package:breakify/breakify.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  int getColumnCount(WidgetTester tester) {
    final grid = tester.widget<GridView>(
      find.byType(GridView),
    );

    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

    return delegate.crossAxisCount;
  }

  Future<void> pumpGrid(
    WidgetTester tester, {
    required double width,
    double minItemWidth = 200,
    double spacing = 16,
    int? maxColumns,
    EdgeInsetsGeometry? padding,
  }) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: width,
            height: 600,
            child: BreakifyResponsiveGrid(
              minItemWidth: minItemWidth,
              spacing: spacing,
              maxColumns: maxColumns,
              padding: padding,
              children: List.generate(
                8,
                (index) => Text('Item $index'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('BreakifyResponsiveGrid', () {
    testWidgets(
      'uses a finite fallback width when available width is infinite',
      (tester) async {
        await tester.pumpWidget(
          const Directionality(
            textDirection: TextDirection.ltr,
            child: UnconstrainedBox(
              alignment: Alignment.topLeft,
              child: BreakifyResponsiveGrid(
                minItemWidth: 200,
                spacing: 16,
                shrinkWrap: true,
                children: [
                  Text('Item'),
                ],
              ),
            ),
          ),
        );

        expect(getColumnCount(tester), 1);
        expect(
          tester.getSize(find.byType(GridView)).width,
          200,
        );
      },
    );

    testWidgets(
      'uses one column when there is insufficient width',
      (tester) async {
        await pumpGrid(tester, width: 350);

        expect(getColumnCount(tester), 1);
      },
    );

    testWidgets(
      'calculates two columns from available width',
      (tester) async {
        await pumpGrid(tester, width: 500);

        expect(getColumnCount(tester), 2);
      },
    );

    testWidgets(
      'increases columns when more width is available',
      (tester) async {
        await pumpGrid(tester, width: 700);

        expect(getColumnCount(tester), 3);
      },
    );

    testWidgets(
      'respects maxColumns',
      (tester) async {
        await pumpGrid(
          tester,
          width: 1000,
          maxColumns: 3,
        );

        expect(getColumnCount(tester), 3);
      },
    );

    testWidgets(
      'accounts for horizontal padding',
      (tester) async {
        await pumpGrid(
          tester,
          width: 420,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        );

        expect(getColumnCount(tester), 1);
      },
    );
  });
}
