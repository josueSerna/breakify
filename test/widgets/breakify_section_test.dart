import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createApp({
    required Widget child,
    double width = 800,
    double height = 600,
  }) {
    return MediaQuery(
      data: MediaQueryData(size: Size(width, height)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: BreakifyScope(
          child: SingleChildScrollView(child: child),
        ),
      ),
    );
  }

  const childKey = ValueKey('child');
  const child = SizedBox(key: childKey, width: 100, height: 50);
  final sectionFinder = find.byType(BreakifySection);

  group('BreakifySection', () {
    testWidgets('spans the width and has no background by default',
        (tester) async {
      await tester
          .pumpWidget(createApp(child: const BreakifySection(child: child)));

      expect(tester.getSize(sectionFinder).width, 800);
      expect(tester.getSize(sectionFinder).height, 50);
      final box = tester.widget<ColoredBox>(find.byType(ColoredBox).first);
      expect(box.color, const Color(0x00000000));
    });

    testWidgets('paints the background color', (tester) async {
      await tester.pumpWidget(createApp(
        child: const BreakifySection(backgroundColor: Colors.red, child: child),
      ));

      final box = tester.widget<ColoredBox>(
        find.descendant(of: sectionFinder, matching: find.byType(ColoredBox)),
      );
      expect(box.color, Colors.red);
    });

    testWidgets('centers by default and respects alignment', (tester) async {
      await tester.pumpWidget(createApp(
        child: const BreakifySection(
            minHeight: BreakifyValue(sm: 300), child: child),
      ));
      expect(tester.getCenter(find.byKey(childKey)), const Offset(400, 150));

      await tester.pumpWidget(createApp(
        child: const BreakifySection(
          minHeight: BreakifyValue(sm: 300),
          alignment: Alignment.bottomRight,
          child: child,
        ),
      ));
      final rect = tester.getRect(find.byKey(childKey));
      expect(rect.right, 800);
      expect(rect.bottom, 300);
    });

    testWidgets('applies padding only when provided', (tester) async {
      await tester.pumpWidget(createApp(
        child: const BreakifySection(
          padding: BreakifyValue<EdgeInsetsGeometry>(sm: EdgeInsets.all(20)),
          child: child,
        ),
      ));

      expect(tester.getSize(sectionFinder).height, 90);
      expect(tester.getTopLeft(find.byKey(childKey)).dy, 20);
    });

    testWidgets('minHeight is applied and never clips taller content',
        (tester) async {
      await tester.pumpWidget(createApp(
        child: const BreakifySection(
            minHeight: BreakifyValue(sm: 200), child: child),
      ));
      expect(tester.getSize(sectionFinder).height, 200);

      await tester.pumpWidget(createApp(
        child: const BreakifySection(
          minHeight: BreakifyValue(sm: 20),
          child: SizedBox(key: childKey, height: 300),
        ),
      ));
      expect(tester.getSize(sectionFinder).height, 300);
      expect(tester.takeException(), isNull);
    });

    testWidgets('childScale enlarges the child without changing layout size',
        (tester) async {
      await tester.pumpWidget(createApp(
        child: const BreakifySection(
          minHeight: BreakifyValue(sm: 130),
          childScale: 2,
          child: SizedBox(key: childKey, width: 80, height: 64),
        ),
      ));

      expect(tester.getSize(sectionFinder).height, 130);
      expect(tester.getRect(find.byKey(childKey)).height, 128);
      expect(tester.takeException(), isNull);
    });

    testWidgets('childScale defaults to the unscaled child size',
        (tester) async {
      await tester.pumpWidget(
        createApp(child: const BreakifySection(child: child)),
      );

      expect(tester.getRect(find.byKey(childKey)).height, 50);
      expect(find.byType(Transform), findsNothing);
    });

    testWidgets('fullViewport uses the viewport height', (tester) async {
      await tester.pumpWidget(createApp(
        height: 700,
        child: const BreakifySection(fullViewport: true, child: child),
      ));
      expect(tester.getSize(sectionFinder).height, 700);
    });

    testWidgets('fullViewport grows with taller content', (tester) async {
      await tester.pumpWidget(createApp(
        height: 500,
        child: const BreakifySection(
          fullViewport: true,
          child: SizedBox(key: childKey, height: 1500),
        ),
      ));
      expect(tester.getSize(sectionFinder).height, 1500);
      expect(tester.takeException(), isNull);
    });

    testWidgets('fullViewport and minHeight use the larger value',
        (tester) async {
      await tester.pumpWidget(createApp(
        height: 500,
        child: const BreakifySection(
          fullViewport: true,
          minHeight: BreakifyValue(sm: 800),
          child: child,
        ),
      ));
      expect(tester.getSize(sectionFinder).height, 800);
    });

    testWidgets('resolves padding and minHeight when the width changes',
        (tester) async {
      Widget app(double width) => createApp(
            width: width,
            child: const BreakifySection(
              padding: BreakifyValue<EdgeInsetsGeometry>(
                sm: EdgeInsets.all(10),
                lg: EdgeInsets.all(40),
              ),
              minHeight: BreakifyValue(sm: 100, lg: 400),
              child: child,
            ),
          );

      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      tester.view.physicalSize = const Size(400, 600);
      await tester.pumpWidget(app(400));
      expect(tester.getSize(sectionFinder).height, 100);
      expect(
          tester.getTopLeft(find.byKey(childKey)).dy, greaterThanOrEqualTo(10));

      tester.view.physicalSize = const Size(1400, 600);
      await tester.pumpWidget(app(1400));
      expect(tester.getSize(sectionFinder).height, 400);
      expect(tester.takeException(), isNull);
    });

    testWidgets('works with full-width content', (tester) async {
      await tester.pumpWidget(createApp(
        child: const BreakifySection(
          child: SizedBox(key: childKey, width: double.infinity, height: 40),
        ),
      ));
      expect(tester.getSize(find.byKey(childKey)).width, 800);
    });
  });
}
