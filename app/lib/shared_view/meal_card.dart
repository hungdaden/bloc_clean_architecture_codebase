import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import '../app.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.title,
    required this.type,
    required this.time,
    required this.mainDish,
    required this.sideDish,
    required this.calories,
    this.onEdit,
    this.onDelete,
  });

  final String title;
  final MealType type;
  final String time;
  final String mainDish;
  final String sideDish;
  final String calories;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  IconData _getIconForType(MealType type) {
    switch (type) {
      case MealType.breakfast:
        return Icons.bakery_dining;
      case MealType.lunch:
        return Icons.ramen_dining;
      case MealType.dinner:
        return Icons.restaurant;
      case MealType.snack:
        return Icons.local_cafe;
      default:
        return Icons.restaurant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final icon = _getIconForType(type);

    return Container(
      margin: EdgeInsets.only(bottom: Dimens.d16.responsive()),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: colors.primaryTextColor, size: 24),
              ),
              SizedBox(width: Dimens.d12.responsive()),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primaryTextColor,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  calories,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.primaryTextColor,
                  ),
                ),
              ),
              if (onEdit != null) ...[
                SizedBox(width: Dimens.d8.responsive()),
                InkWell(
                  onTap: onEdit,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.edit_outlined,
                        size: 20, color: Colors.blue[600]),
                  ),
                ),
              ],
              if (onDelete != null) ...[
                SizedBox(width: Dimens.d4.responsive()),
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.delete_outline,
                        size: 20, color: Colors.red[600]),
                  ),
                ),
              ],
            ],
          ),
          Divider(height: 24, thickness: 1, color: theme.dividerColor),
          FoodItemSection(label: 'Món chính', value: mainDish),
          FoodItemSection(label: 'Ăn kèm/Tráng miệng', value: sideDish),
        ],
      ),
    );
  }
}
