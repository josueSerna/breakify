import 'package:flutter/material.dart';

/// Layout strategy used by [EqualHeightCard] to place its button.
enum EqualHeightCardLayout {
  /// Plain column; the button follows the content.
  plain,

  /// A [Spacer] pushes the button to the bottom.
  spacer,

  /// An [Expanded] description pushes the button to the bottom.
  expanded,
}

class EqualHeightCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final EqualHeightCardLayout layout;

  const EqualHeightCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.layout = EqualHeightCardLayout.plain,
  });

  @override
  Widget build(BuildContext context) {
    final descriptionText = Text(description);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (layout == EqualHeightCardLayout.expanded)
            Expanded(child: descriptionText)
          else
            descriptionText,
          if (layout == EqualHeightCardLayout.spacer) const Spacer(),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(onPressed: () {}, child: const Text('Open')),
          ),
        ],
      ),
    );
  }
}
