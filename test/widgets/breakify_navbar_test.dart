import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var tapped = '';

  Widget navbar({
    BreakifyNavbarMenuType menuType = BreakifyNavbarMenuType.dropdown,
    BreakifyNavbarScrollBehavior scroll = BreakifyNavbarScrollBehavior.fixed,
    BreakifyNavbarDrawerSide side = BreakifyNavbarDrawerSide.left,
  }) {
    return BreakifyScope(
      child: MaterialApp(
        home: Scaffold(
          body: BreakifyNavbar(
            logo: const Text('Logo'),
            menuType: menuType,
            scrollBehavior: scroll,
            drawerSide: side,
            items: [
              BreakifyNavbarItem(label: 'Home', onTap: () => tapped = 'Home'),
              BreakifyNavbarItem(
                label: 'Off',
                enabled: false,
                onTap: () => tapped = 'Off',
              ),
            ],
            body: ListView(
              children: [
                for (var i = 0; i < 60; i++)
                  SizedBox(height: 80, child: Text('Row $i')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> setSize(WidgetTester tester, double width) async {
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  double navbarTop(WidgetTester tester) =>
      tester.getTopLeft(find.text('Logo')).dy;

  setUp(() => tapped = '');

  testWidgets('logo can be taller than the bar up to logoMaxHeight',
      (tester) async {
    await setSize(tester, 1000);
    Widget app(double logoHeight) => BreakifyScope(
          child: MaterialApp(
            home: Scaffold(
              body: BreakifyNavbar(
                logo: SizedBox(
                    key: const ValueKey('logo'), width: 50, height: logoHeight),
                items: [BreakifyNavbarItem(label: 'Home', onTap: () {})],
                body: const SizedBox(),
              ),
            ),
          ),
        );

    await tester.pumpWidget(app(130));
    expect(tester.getSize(find.byKey(const ValueKey('logo'))).height, 80);

    await tester.pumpWidget(app(72));
    expect(tester.getSize(find.byKey(const ValueKey('logo'))).height, 72);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows items inline on desktop, hamburger on mobile',
      (tester) async {
    await setSize(tester, 1000);
    await tester.pumpWidget(navbar());
    expect(find.text('Home'), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsNothing);

    await setSize(tester, 500);
    await tester.pumpWidget(navbar());
    await tester.pump();
    expect(find.text('Home'), findsNothing);
    expect(find.byIcon(Icons.menu), findsOneWidget);
  });

  testWidgets('dropdown opens, selects and closes', (tester) async {
    await setSize(tester, 500);
    await tester.pumpWidget(navbar());

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(tapped, 'Home');
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('disabled items do not fire', (tester) async {
    await setSize(tester, 500);
    await tester.pumpWidget(navbar());
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Off'));
    await tester.pumpAndSettle();
    expect(tapped, '');
  });

  for (final side in BreakifyNavbarDrawerSide.values) {
    testWidgets('drawer opens from $side and closes on outside tap',
        (tester) async {
      await setSize(tester, 500);
      await tester.pumpWidget(
        navbar(menuType: BreakifyNavbarMenuType.drawer, side: side),
      );
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      final rect = tester.getRect(find.text('Home'));
      expect(
        side == BreakifyNavbarDrawerSide.left
            ? rect.left < 250
            : rect.left > 200,
        isTrue,
      );

      final outside = side == BreakifyNavbarDrawerSide.left
          ? const Offset(480, 400)
          : const Offset(20, 400);
      await tester.tapAt(outside);
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsNothing);
    });
  }

  testWidgets('drawer closes with close icon', (tester) async {
    await setSize(tester, 500);
    await tester.pumpWidget(
      navbar(menuType: BreakifyNavbarMenuType.drawer),
    );
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('menu state survives size changes within mobile', (tester) async {
    await setSize(tester, 500);
    await tester.pumpWidget(navbar());
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    await setSize(tester, 400);
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('fixed stays, static scrolls away, hideOnScroll toggles',
      (tester) async {
    await setSize(tester, 1000);

    await tester.pumpWidget(navbar());
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(navbarTop(tester), greaterThanOrEqualTo(0));

    await tester.pumpWidget(
      navbar(scroll: BreakifyNavbarScrollBehavior.static),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -100));
    await tester.pumpAndSettle();
    expect(find.text('Logo').hitTestable(), findsNothing);

    await tester.pumpWidget(
      navbar(scroll: BreakifyNavbarScrollBehavior.hideOnScroll),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(navbarTop(tester), lessThan(0));

    await tester.drag(find.byType(ListView), const Offset(0, 100));
    await tester.pumpAndSettle();
    expect(navbarTop(tester), greaterThanOrEqualTo(0));
  });

  testWidgets('fixed and hideOnScroll never cover the body', (tester) async {
    await setSize(tester, 1000);
    for (final b in [
      BreakifyNavbarScrollBehavior.fixed,
      BreakifyNavbarScrollBehavior.hideOnScroll,
    ]) {
      await tester.pumpWidget(navbar(scroll: b));
      await tester.pumpAndSettle();
      expect(
          tester.getTopLeft(find.text('Row 0')).dy, greaterThanOrEqualTo(64));
    }
  });
}
