import 'package:breakify/breakify.dart';
import 'package:flutter/material.dart';

/// Experimental: `BreakifyHeightMode.equal` with raw, unstyled cards and
/// deliberately uneven content. Lets you tweak the amount of cards and how
/// different their content is.
class RawEqualGridScreen extends StatefulWidget {
  const RawEqualGridScreen({super.key});

  @override
  State<RawEqualGridScreen> createState() => _RawEqualGridScreenState();
}

class _RawEqualGridScreenState extends State<RawEqualGridScreen> {
  static const _lorem =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
      'eiusmod tempor incididunt ut labore et dolore magna aliqua. ';

  int _count = 40;
  BreakifyHeightMode? _mode = BreakifyHeightMode.equal;

  // Pseudo-random but stable: some cards are a single word, some very long.
  String _text(int i) {
    final repeats = (i * 37 + 11) % 9;
    if (repeats == 0) return 'x';
    return _lorem * repeats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Raw Equal (experimental)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                DropdownButton<BreakifyHeightMode?>(
                  value: _mode,
                  items: [
                    const DropdownMenuItem(value: null, child: Text('null')),
                    for (final m in BreakifyHeightMode.values)
                      DropdownMenuItem(value: m, child: Text('Mode: ')),
                  ],
                  onChanged: (m) => setState(() => _mode = m),
                ),
                Text('cards: $_count'),
                Slider(
                  value: _count.toDouble(),
                  min: 1,
                  max: 500,
                  divisions: 499,
                  onChanged: (v) => setState(() => _count = v.round()),
                ),
              ],
            ),
          ),
          Expanded(
            child: BreakifyGrid(
              columns: const BreakifyValue(sm: 1, md: 2, lg: 4),
              spacing: const BreakifyValue(sm: 4),
              heightMode: _mode,
              childAspectRatio: const BreakifyValue(sm: 1),
              children: [
                for (var i = 0; i < _count; i++)
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: Colors.grey.shade200,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('#$i'),
                        Text(_text(i)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
