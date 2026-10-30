import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';

class BreakifyNavbarScreen extends StatefulWidget {
  const BreakifyNavbarScreen({super.key});

  @override
  State<BreakifyNavbarScreen> createState() => _BreakifyNavbarScreenState();
}

class _BreakifyNavbarScreenState extends State<BreakifyNavbarScreen> {
  BreakifyNavbarMenuType _menuType = BreakifyNavbarMenuType.dropdown;
  BreakifyNavbarScrollBehavior _scroll = BreakifyNavbarScrollBehavior.fixed;
  BreakifyNavbarDrawerSide _side = BreakifyNavbarDrawerSide.left;
  bool _customStyle = false;
  bool _disableLast = false;
  String _selected = 'Home';

  BreakifyNavbarItem _item(String label, IconData icon, {bool enabled = true}) {
    return BreakifyNavbarItem(
      label: label,
      icon: icon,
      enabled: enabled,
      onTap: () => setState(() => _selected = label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BreakifyNavbar(
        logo: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Back',
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.maybePop(context),
            ),
            const Text(
              'Breakify',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        items: [
          _item('Home', Icons.home),
          _item('Services', Icons.work),
          _item('Contact', Icons.contact_mail, enabled: !_disableLast),
        ],
        menuType: _menuType,
        drawerSide: _side,
        scrollBehavior: _scroll,
        menuIcon: _customStyle ? Icons.apps : Icons.menu,
        closeIcon: _customStyle ? Icons.cancel : Icons.close,
        backgroundColor: _customStyle ? Colors.indigo.shade900 : null,
        foregroundColor: _customStyle ? Colors.white : null,
        menuBackgroundColor: _customStyle ? Colors.indigo.shade700 : null,
        height: _customStyle ? 80 : 64,
        itemSpacing: _customStyle ? 24 : 8,
        padding: EdgeInsets.symmetric(horizontal: _customStyle ? 32 : 16),
        body: Builder(
          builder: (context) => ListView(
            padding:
                MediaQuery.paddingOf(context).add(const EdgeInsets.all(16)),
            children: [
              Card(
                child: ExpansionTile(
                  title: const Text('BreakifyNavbar (experimental)'),
                  subtitle: Text('Selected: $_selected'),
                  initiallyExpanded: true,
                  children: [
                    _Choice<BreakifyNavbarMenuType>(
                      label: 'Mobile menu',
                      values: BreakifyNavbarMenuType.values,
                      selected: _menuType,
                      onChanged: (v) => setState(() => _menuType = v),
                    ),
                    _Choice<BreakifyNavbarDrawerSide>(
                      label: 'Drawer side',
                      values: BreakifyNavbarDrawerSide.values,
                      selected: _side,
                      onChanged: (v) => setState(() => _side = v),
                    ),
                    _Choice<BreakifyNavbarScrollBehavior>(
                      label: 'Scroll behavior',
                      values: BreakifyNavbarScrollBehavior.values,
                      selected: _scroll,
                      onChanged: (v) => setState(() => _scroll = v),
                    ),
                    SwitchListTile(
                      title: const Text('Custom colors, icons and spacing'),
                      value: _customStyle,
                      onChanged: (v) => setState(() => _customStyle = v),
                    ),
                    SwitchListTile(
                      title: const Text('Disable "Contact"'),
                      value: _disableLast,
                      onChanged: (v) => setState(() => _disableLast = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Resize the window below the selected breakpoint to get the '
                'hamburger menu, then scroll to test the scroll behavior.',
              ),
              const SizedBox(height: 16),
              for (var i = 1; i <= 40; i++)
                Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('$i')),
                    title: Text('Content block $i'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Choice<T extends Enum> extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.values,
    required this.selected,
    required this.onChanged,
  });

  final String label;
  final List<T> values;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Wrap(
        spacing: 8,
        children: [
          for (final v in values)
            ChoiceChip(
              label: Text(v.name),
              selected: v == selected,
              onSelected: (_) => onChanged(v),
            ),
        ],
      ),
    );
  }
}
