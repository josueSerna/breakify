import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlexifyExampleApp());
}

class FlexifyExampleApp extends StatelessWidget {
  const FlexifyExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BreakifyScope(
      breakpoints: BreakifyBreakpoints.defaults,
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
    return BreakifyDebugBanner(
      corner: BreakifyBannerCorner.topRight,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(title: const Text('Flexify — Example')),
        body: SingleChildScrollView(
          child: BreakifyContainer(
            maxWidth: BreakifyValue(sm: 1200),
            child: Column(
              spacing: context.resolve(const BreakifyValue(sm: 24, lg: 40)),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                // Header + NavBar responsive
                BreakifyAdaptativeLayout(
                  breakpoint: BreakifyBreakpoint.md,
                  spacing: BreakifyValue(sm: 16, md: 24),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  distributeEvenly: true,
                  children: [_HeaderSection(), _NavBarDemo()],
                ),
                _GridDemo(),
                _ListDemo(),
                _PaddingDemo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
      child: Column(
        spacing: context.resolve(const BreakifyValue(sm: 8)),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Breakpoint actual: ${context.breakpoint.name}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            'Ancho de pantalla: ${context.breakifyWidth.round()}px',
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

class _NavBarDemo extends StatelessWidget {
  const _NavBarDemo();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'FlexifyVisibility',
      child: Row(
        spacing: context.resolve(const BreakifyValue(sm: 12)),
        children: [
          BreakifyVisibility(
            maxBreakpoint: BreakifyBreakpoint.md,
            child: const Icon(Icons.menu),
          ),
          const Expanded(child: Text('Mi App')),
          BreakifyVisibility(
            minBreakpoint: BreakifyBreakpoint.md,
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

class _GridDemo extends StatelessWidget {
  const _GridDemo();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'FlexifyGrid',
      height: 500,
      child: const Expanded(
        child: BreakifyGrid(
          columns: BreakifyValue(sm: 2, md: 3, lg: 4),
          spacing: BreakifyValue(sm: 12),
          childAspectRatio: BreakifyValue(sm: 1.2),
          children: [
            _GridTile(index: 0),
            _GridTile(index: 1),
            _GridTile(index: 2),
            _GridTile(index: 3),
            _GridTile(index: 4),
            _GridTile(index: 5),
            _GridTile(index: 6),
            _GridTile(index: 7),
          ],
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

class _ListDemo extends StatelessWidget {
  const _ListDemo();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Responsive Team Members',
      height: 420,
      child: Expanded(
        child: BreakifyListView(
          spacing: const BreakifyValue(sm: 8, md: 12, lg: 20, xl: 28),
          padding: const EdgeInsets.all(16),
          itemCount: _members.length,
          itemBuilder: (context, index) {
            final member = _members[index];

            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: ListTile(
                leading: CircleAvatar(child: Text(member.initials)),
                title: Text(member.name),
                subtitle: Text(member.role),
                trailing: const Icon(Icons.chevron_right),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Member {
  final String name;
  final String role;

  const _Member(this.name, this.role);

  String get initials => name.split(' ').map((e) => e[0]).take(2).join();
}

const _members = [
  _Member('Emma Wilson', 'UI Designer'),
  _Member('Liam Johnson', 'Flutter Developer'),
  _Member('Sophia Brown', 'Backend Developer'),
  _Member('Noah Davis', 'QA Engineer'),
  _Member('Olivia Miller', 'Product Manager'),
  _Member('James Taylor', 'DevOps Engineer'),
  _Member('Isabella Anderson', 'Mobile Developer'),
  _Member('Benjamin Thomas', 'Frontend Developer'),
];

class _PaddingDemo extends StatelessWidget {
  const _PaddingDemo();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'FlexifyPadding (fluido)',
      child: Padding(
        padding: EdgeInsets.all(
          context.resolve(const BreakifyFluidValue(sm: 8, xxl: 40)),
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
  final double? height;

  const _Card({required this.title, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        spacing: context.resolve(const BreakifyValue(sm: 12)),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          child,
        ],
      ),
    );
  }
}
