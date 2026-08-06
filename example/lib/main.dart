// example/lib/main.dart
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlexifyExampleApp());
}

class FlexifyExampleApp extends StatelessWidget {
  const FlexifyExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlexifyScope(
      // Breakpoints por defecto (estilo Tailwind).
      // Cambialos acá para probar cómo reacciona todo el ejemplo.
      breakpoints: FlexifyBreakpoints.defaults,
      child: MaterialApp(
        title: 'Flexify Example',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: const FlexifyExampleHome(),
      ),
    );
  }
}

class FlexifyExampleHome extends StatelessWidget {
  const FlexifyExampleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return FlexifyDebugBanner(
      corner: FlexifyBannerCorner.topRight,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(title: const Text('Flexify — Example')),
        body: SingleChildScrollView(
          child: FlexifyContainer(
            maxWidth: const FlexifyValue(sm: 1100),
            padding: const FlexifyValue(
              sm: EdgeInsets.all(16),
              lg: EdgeInsets.all(32),
            ),
            child: FlexifyColumn(
              spacing: const FlexifyValue(sm: 24, lg: 40),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                _HeaderSection(),
                _NavBarDemo(),
                _GridDemo(),
                _PaddingDemo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Muestra el breakpoint actual con texto grande, usando context.breakpoint
/// directo (sin ningún widget de Flexify, solo la extension).
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: FlexifyColumn(
        spacing: const FlexifyValue(sm: 8),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Breakpoint actual: ${context.breakpoint.name}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            'Ancho de pantalla: ${context.flexifyWidth.round()}px',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Text(
            'Redimensioná la ventana (o el navegador) para ver todo '
            'este ejemplo reaccionar en tiempo real.',
          ),
        ],
      ),
    );
  }
}

/// Demuestra FlexifyVisibility: menú hamburguesa en mobile,
/// links completos en desktop.
class _NavBarDemo extends StatelessWidget {
  const _NavBarDemo();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'FlexifyVisibility',
      child: FlexifyRow(
        spacing: const FlexifyValue(sm: 12),
        children: [
          FlexifyVisibility(
            maxBreakpoint: FlexifyBreakpoint.md,
            child: const Icon(Icons.menu),
          ),
          const Expanded(child: Text('Mi App')),
          FlexifyVisibility(
            minBreakpoint: FlexifyBreakpoint.lg,
            replacement: const Icon(Icons.person),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person),
              label: const Text('Mi cuenta'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Demuestra FlexifyGrid: columnas que crecen según el breakpoint.
class _GridDemo extends StatelessWidget {
  const _GridDemo();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'FlexifyGrid',
      heigth: 500,
      child: Expanded(
        child: FlexifyGrid(
          columns: const FlexifyValue(sm: 2, md: 3, lg: 4),
          spacing: const FlexifyValue(sm: 12),
          childAspectRatio: const FlexifyValue(sm: 1.2),
          shrinkWrap: true,
          children: List.generate(8, (i) => _GridTile(index: i)),
        ),
      ),
    );
  }
}

class _GridTile extends StatelessWidget {
  final int index;

  const _GridTile({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text('${index + 1}'),
    );
  }
}

/// Demuestra FlexifyPadding con un valor fluido (interpolado).
class _PaddingDemo extends StatelessWidget {
  const _PaddingDemo();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'FlexifyPadding (fluido)',
      child: FlexifyPadding(
        padding: FlexifyValue(
          sm: EdgeInsets.all(
            context.resolve(const FlexifyFluidValue(sm: 8, xxl: 40)),
          ),
        ),
        child: Container(
          color: Colors.indigo.shade200,
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'El padding de este bloque interpola '
                'suavemente entre 8px y 40px según el ancho.',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  final double? heigth;

  const _Card({required this.title, required this.child, this.heigth});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: heigth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: FlexifyColumn(
        spacing: const FlexifyValue(sm: 12),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          child,
        ],
      ),
    );
  }
}
