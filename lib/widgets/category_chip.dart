import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../utils/categories.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final bool showIcon;

  const CategoryChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = selected ? c.onPrimary : c.textPrimary;
    return Material(
      color: selected ? c.primary : c.card,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showIcon) ...[
                Icon(
                  label == 'All'
                      ? Icons.apps_rounded
                      : Categories.iconFor(label),
                  size: 18,
                  color: fg,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: AppTextStyles.text.copyWith(
                  color: fg,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryChipRow extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onSelected;
  final bool includeAll;

  const CategoryChipRow({
    super.key,
    required this.selected,
    required this.onSelected,
    this.includeAll = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (includeAll) ...[
            CategoryChip(
              label: 'All',
              selected: selected == null,
              onTap: () => onSelected(null),
            ),
            const SizedBox(width: 8),
          ],
          for (final c in Categories.all) ...[
            CategoryChip(
              label: c,
              selected: selected == c,
              onTap: () => onSelected(c),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
