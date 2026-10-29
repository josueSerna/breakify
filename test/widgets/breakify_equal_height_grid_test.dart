import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget card(
    int index,
    String body, {
    bool spacer = false,
    bool expanded = false,
  }) {
    return Card(
      key: ValueKey('card$index'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.star),
            Text('Title $index', style: const TextStyle(fontSize: 20)),
            if (expanded) Expanded(child: Text(body)) else Text(body),
            if (spacer) const Spacer(),
            ElevatedButton(onPressed: () {}, child: const Text('Action')),
          ],
        ),
      ),
    );
  }

  Future<void> pump(
    WidgetTester tester, {
    required double width,
    required List<Widget> children,
    BreakifyValue<int> columns = const BreakifyValue(sm: 1, md: 2, lg: 3),
    double spacing = 10,
    EdgeInsets? padding,
    BreakifyHeightMode mode = BreakifyHeightMode.equalInRow,
  }) async {
    tester.view.physicalSize = Size(width, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      BreakifyScope(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: MediaQueryData(size: Size(width, 1600)),
            child: Material(
              child: BreakifyGrid(
                columns: columns,
                spacing: BreakifyValue(sm: spacing),
                padding: padding,
                heightMode: mode,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Size sizeOf(WidgetTester tester, int i) =>
      tester.getSize(find.byKey(ValueKey('card$i')));

  List<Widget> mixed() => [
        card(0, 'Short'),
        card(1, 'A much longer description that wraps. ' * 6),
        card(2, 'Spacer card', spacer: true),
        card(3, 'Expanded card ' * 4, expanded: true),
        card(4, 'Last'),
      ];

  for (final width in [400.0, 800.0, 1300.0]) {
    testWidgets('mixed cards, no layout errors at width $width',
        (tester) async {
      await pump(tester, width: width, children: mixed());
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('cards in a row share height and fit the tallest content',
      (tester) async {
    await pump(tester, width: 800, children: mixed());

    expect(sizeOf(tester, 0).height, sizeOf(tester, 1).height);
    expect(sizeOf(tester, 2).height, sizeOf(tester, 3).height);
    expect(sizeOf(tester, 0).height, greaterThan(sizeOf(tester, 4).height));

    // Row 0 is determined by the long card, which is taller than a short one
    // laid out alone.
    final short = tester.getSize(find.byKey(const ValueKey('card4')));
    expect(sizeOf(tester, 1).height, greaterThan(short.height));
  });

  testWidgets('equal makes every card the same height across rows',
      (tester) async {
    await pump(
      tester,
      width: 800,
      mode: BreakifyHeightMode.equal,
      children: [
        card(0, 'Short'),
        card(1, 'A much longer description that wraps. ' * 6),
        card(2, 'Short'),
        card(3, 'Short'),
      ],
    );

    expect(tester.takeException(), isNull);
    final h = sizeOf(tester, 1).height;
    for (var i = 0; i < 4; i++) {
      expect(sizeOf(tester, i).height, h);
    }
  });

  testWidgets('equal supports Spacer and Expanded', (tester) async {
    await pump(
      tester,
      width: 800,
      mode: BreakifyHeightMode.equal,
      children: [
        card(0, 'Short', spacer: true),
        card(1, 'A much longer description that wraps. ' * 6),
        card(2, 'Expanded', expanded: true),
        card(3, 'Short', spacer: true),
      ],
    );

    expect(tester.takeException(), isNull);
    final h = sizeOf(tester, 1).height;
    for (var i = 0; i < 4; i++) {
      expect(sizeOf(tester, i).height, h);
    }
    final button = tester.getRect(find.descendant(
        of: find.byKey(const ValueKey('card0')),
        matching: find.byType(ElevatedButton)));
    final cardRect = tester.getRect(find.byKey(const ValueKey('card0')));
    expect(cardRect.bottom - button.bottom, lessThanOrEqualTo(20));
  });

  testWidgets('equalInRow lets rows differ in height', (tester) async {
    await pump(
      tester,
      width: 800,
      children: [
        card(0, 'Short'),
        card(1, 'A much longer description that wraps. ' * 6),
        card(2, 'Short'),
        card(3, 'Short'),
      ],
    );

    expect(sizeOf(tester, 0).height, sizeOf(tester, 1).height);
    expect(sizeOf(tester, 2).height, sizeOf(tester, 3).height);
    expect(sizeOf(tester, 2).height, lessThan(sizeOf(tester, 0).height));
  });

  testWidgets('natural keeps each card its own height', (tester) async {
    await pump(
      tester,
      width: 800,
      mode: BreakifyHeightMode.natural,
      children: [
        card(0, 'Short'),
        card(1, 'A much longer description that wraps. ' * 6),
        card(2, 'Short'),
        card(3, 'Short'),
      ],
    );

    expect(tester.takeException(), isNull);
    expect(sizeOf(tester, 0).height, lessThan(sizeOf(tester, 1).height));
    expect(sizeOf(tester, 2).height, sizeOf(tester, 0).height);
    final r0 = tester.getRect(find.byKey(const ValueKey('card0')));
    final r2 = tester.getRect(find.byKey(const ValueKey('card2')));
    expect(r2.top - r0.top, sizeOf(tester, 1).height + 10);
  });

  testWidgets('respects columns, spacing and padding', (tester) async {
    await pump(
      tester,
      width: 1300,
      spacing: 20,
      padding: const EdgeInsets.all(30),
      children: mixed(),
    );

    final c0 = tester.getRect(find.byKey(const ValueKey('card0')));
    final c1 = tester.getRect(find.byKey(const ValueKey('card1')));
    final c2 = tester.getRect(find.byKey(const ValueKey('card2')));
    final c3 = tester.getRect(find.byKey(const ValueKey('card3')));
    final c4 = tester.getRect(find.byKey(const ValueKey('card4')));

    expect(c0.left, 30);
    expect(c1.left - c0.right, 20);
    expect(c2.left - c1.right, 20);
    expect(c0.width, closeTo((1300 - 60 - 40) / 3, 0.01));
    expect(c3.top - c0.bottom, 20);
    expect(c3.left, 30);
    // Incomplete last row keeps the column width.
    expect(c4.width, c0.width);
    expect(c4.left, c1.left);
  });

  testWidgets('Spacer pushes the button to the bottom of the row',
      (tester) async {
    await pump(tester, width: 800, children: mixed());

    final spacerCard = tester.getRect(find.byKey(const ValueKey('card2')));
    final button = tester.getRect(
      find.descendant(
        of: find.byKey(const ValueKey('card2')),
        matching: find.byType(ElevatedButton),
      ),
    );
    // The card padding is 16 plus the Card margin; button sits at the bottom.
    expect(spacerCard.bottom - button.bottom, lessThan(30));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Expanded receives bounded height', (tester) async {
    await pump(tester, width: 800, children: mixed());

    final expanded = tester.getSize(
      find.descendant(
        of: find.byKey(const ValueKey('card3')),
        matching: find.byType(Expanded),
      ),
    );
    expect(expanded.height, greaterThan(0));
    expect(tester.takeException(), isNull);
  });

  testWidgets('recomputes when width and column count change', (tester) async {
    await pump(tester, width: 1300, children: mixed());
    final wide = sizeOf(tester, 1);

    await pump(tester, width: 400, children: mixed());
    final narrow = sizeOf(tester, 1);

    expect(narrow.width, lessThan(wide.width));
    expect(narrow.height, greaterThanOrEqualTo(wide.height));
    expect(tester.takeException(), isNull);
  });

  testWidgets('single column stacks cards with spacing', (tester) async {
    await pump(tester, width: 400, spacing: 12, children: mixed());

    final c0 = tester.getRect(find.byKey(const ValueKey('card0')));
    final c1 = tester.getRect(find.byKey(const ValueKey('card1')));
    expect(c1.top - c0.bottom, 12);
  });
}
