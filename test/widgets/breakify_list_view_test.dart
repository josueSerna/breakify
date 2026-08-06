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

  group('BreakifyListView', () {
    testWidgets('creates a ListView', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 900,
          child: BreakifyListView(
            itemCount: 5,
            itemBuilder: (_, index) => Text('Item $index'),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 4'), findsOneWidget);
    });

    testWidgets('passes padding', (tester) async {
      const padding = EdgeInsets.all(24);

      await tester.pumpWidget(
        createApp(
          width: 900,
          child: BreakifyListView(
            padding: padding,
            itemCount: 2,
            itemBuilder: (_, index) => Text('Item $index'),
          ),
        ),
      );

      final list = tester.widget<ListView>(
        find.byType(ListView),
      );

      expect(list.padding, padding);
    });

    testWidgets('passes shrinkWrap', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 900,
          child: BreakifyListView(
            shrinkWrap: true,
            itemCount: 2,
            itemBuilder: (_, index) => Text('Item $index'),
          ),
        ),
      );

      final list = tester.widget<ListView>(
        find.byType(ListView),
      );

      expect(list.shrinkWrap, isTrue);
    });

    testWidgets('passes scrollDirection', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 900,
          child: BreakifyListView(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            itemBuilder: (_, index) => Text('Item $index'),
          ),
        ),
      );

      final list = tester.widget<ListView>(
        find.byType(ListView),
      );

      expect(list.scrollDirection, Axis.horizontal);
    });

    testWidgets('uses custom separator', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 900,
          child: BreakifyListView(
            itemCount: 3,
            separator: const Divider(),
            itemBuilder: (_, index) => Text('Item $index'),
          ),
        ),
      );

      expect(find.byType(Divider), findsNWidgets(2));
    });

    testWidgets('uses spacing when separator is null', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 900,
          child: BreakifyListView(
            spacing: const BreakifyValue(sm: 20),
            itemCount: 3,
            itemBuilder: (_, index) => Text('Item $index'),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsNWidgets(2));

      final sizedBox = tester.widget<SizedBox>(
        find.byType(SizedBox).first,
      );

      expect(sizedBox.height, 20);
    });

    testWidgets('passes reverse', (tester) async {
      await tester.pumpWidget(
        createApp(
          width: 900,
          child: BreakifyListView(
            reverse: true,
            itemCount: 2,
            itemBuilder: (_, index) => Text('Item $index'),
          ),
        ),
      );

      final list = tester.widget<ListView>(
        find.byType(ListView),
      );

      expect(list.reverse, isTrue);
    });

    testWidgets('passes physics', (tester) async {
      const physics = NeverScrollableScrollPhysics();

      await tester.pumpWidget(
        createApp(
          width: 900,
          child: BreakifyListView(
            physics: physics,
            itemCount: 2,
            itemBuilder: (_, index) => Text('Item $index'),
          ),
        ),
      );

      final list = tester.widget<ListView>(
        find.byType(ListView),
      );

      expect(list.physics, physics);
    });
  });
}
