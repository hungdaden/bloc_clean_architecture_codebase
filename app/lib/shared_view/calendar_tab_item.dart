import 'package:flutter/material.dart';
import '../app.dart';

class CalendarTabItem extends StatelessWidget {
  const CalendarTabItem({
    super.key,
    required this.date,
    required this.index,
    required this.tabController,
  });

  final DateTime date;
  final int index;
  final TabController tabController;

  String _getWeekdayString(int weekday) {
    switch (weekday) {
      case 1:
        return 'T2';
      case 2:
        return 'T3';
      case 3:
        return 'T4';
      case 4:
        return 'T5';
      case 5:
        return 'T6';
      case 6:
        return 'T7';
      case 7:
        return 'CN';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    return AnimatedBuilder(
      animation: tabController.animation!,
      builder: (context, _) {
        final animationValue = tabController.animation!.value;
        final distance = (animationValue - index).abs();
        final t = (1 - distance).clamp(0.0, 1.0);

        final selectedBg = theme.primaryColor;
        final unselectedBg = theme.cardColor;

        final selectedBorder = theme.primaryColor;
        final unselectedBorder = theme.dividerColor;

        const selectedWeekdayColor = Colors.white70;
        final unselectedWeekdayColor = colors.secondaryTextColor;

        const selectedDateColor = Colors.white;
        final unselectedDateColor = colors.primaryTextColor;

        final bgColor = Color.lerp(unselectedBg, selectedBg, t)!;
        final borderColor = Color.lerp(unselectedBorder, selectedBorder, t)!;
        final weekdayColor =
            Color.lerp(unselectedWeekdayColor, selectedWeekdayColor, t)!;
        final dateColor = Color.lerp(unselectedDateColor, selectedDateColor, t)!;

        return Container(
          width: 65,
          margin: EdgeInsets.symmetric(horizontal: Dimens.d4.responsive()),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _getWeekdayString(date.weekday),
                style: TextStyle(
                  fontSize: 14,
                  color: weekdayColor,
                ),
              ),
              SizedBox(height: Dimens.d4.responsive()),
              Text(
                '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: dateColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
