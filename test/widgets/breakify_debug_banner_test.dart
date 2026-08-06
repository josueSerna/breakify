import 'package:breakify/breakify.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createApp({
    required double width,
    required Widget child,
  }) {
    return MediaQuery(
      data: MediaQueryData(
        size: Size(width, 800),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: BreakifyScope(
          child: SizedBox(
            width: width,
            height: 800,
            child: child,
          ),
        ),
      ),
    );
  }

  group('BreakifyDebugBanner', () {
    testWidgets('shows banner by default', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(1024, 800),
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        createApp(
          width: 1024,
          child: const BreakifyDebugBanner(
            child: Text('Content'),
          ),
        ),
      );

      expect(find.text('lg · 1024px'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('does not show banner when disabled', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(1024, 800),
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        createApp(
          width: 1024,
          child: const BreakifyDebugBanner(
            enabled: false,
            child: Text('Content'),
          ),
        ),
      );

      expect(find.text('lg · 1024px'), findsNothing);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('shows correct breakpoint for small width', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(500, 800),
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        createApp(
          width: 500,
          child: const BreakifyDebugBanner(
            child: Text('Content'),
          ),
        ),
      );

      expect(find.text('sm · 500px'), findsOneWidget);
    });

    testWidgets('shows correct breakpoint for xl', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(1400, 800),
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        createApp(
          width: 1400,
          child: const BreakifyDebugBanner(
            child: Text('Content'),
          ),
        ),
      );

      expect(find.text('xl · 1400px'), findsOneWidget);
    });

    testWidgets('supports topLeft corner', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(1024, 800),
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        createApp(
          width: 1024,
          child: const BreakifyDebugBanner(
            corner: BreakifyBannerCorner.topLeft,
            child: Text('Content'),
          ),
        ),
      );

      final positioned = tester.widget<Positioned>(
        find.byType(Positioned),
      );

      expect(positioned.top, 0);
      expect(positioned.left, 0);
      expect(positioned.bottom, null);
      expect(positioned.right, null);
    });

    testWidgets('supports bottomRight corner', (tester) async {
      await tester.binding.setSurfaceSize(
        const Size(1024, 800),
      );

      addTearDown(() {
        tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(
        createApp(
          width: 1024,
          child: const BreakifyDebugBanner(
            corner: BreakifyBannerCorner.bottomRight,
            child: Text('Content'),
          ),
        ),
      );

      final positioned = tester.widget<Positioned>(
        find.byType(Positioned),
      );

      expect(positioned.bottom, 0);
      expect(positioned.right, 0);
      expect(positioned.top, null);
      expect(positioned.left, null);
    });
  });
}
