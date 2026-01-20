import 'package:flutter/material.dart';
import 'package:harmonymusic/ui/theme.dart';

class SettingsGroup extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final List<Widget> children;

  const SettingsGroup({
    super.key,
    this.title,
    this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 8, top: 15),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon,
                      size: 18, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                ],
                Text(
                  title!.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                ),
              ],
            ),
          ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              children: children.asMap().entries.map((entry) {
                final idx = entry.key;
                final widget = entry.value;
                return Column(
                  children: [
                    widget,
                    if (idx < children.length - 1)
                      Divider(
                        height: 1,
                        thickness: 0.5,
                        indent: 15,
                        endIndent: 15,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
