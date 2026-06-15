import 'package:flutter/material.dart';
import '../app.dart';

class FoodItemSection extends StatelessWidget {
  const FoodItemSection({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final foodItems = value
        .split(RegExp(r'[,+&]|\n| và '))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Container(
      margin: EdgeInsets.only(bottom: Dimens.d12.responsive()),
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: colors.secondaryTextColor,
            ),
          ),
          SizedBox(height: Dimens.d12.responsive()),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: foodItems.map((item) => _FoodChip(name: item)).toList(),
          ),
        ],
      ),
    );
  }
}

class _FoodChip extends StatelessWidget {
  const _FoodChip({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.d16.responsive(),
        vertical: Dimens.d8.responsive(),
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 14,
          color: colors.primaryTextColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
