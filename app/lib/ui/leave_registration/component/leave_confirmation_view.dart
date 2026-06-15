import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app.dart';

class LeaveConfirmationView extends StatelessWidget {
  const LeaveConfirmationView({
    super.key,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
  });

  final LeaveType leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    String dateRangeStr = '';
    try {
      final startStr = DateFormat('dd/MM/yyyy').format(startDate);
      final endStr = DateFormat('dd/MM/yyyy').format(endDate);
      final dayName = _getDayOfWeekName(startDate);

      if (startDate == endDate) {
        dateRangeStr = '$dayName, $startStr';
      } else {
        dateRangeStr = '$startStr - $endStr';
      }
    } catch (_) {
      dateRangeStr = DateFormat('dd/MM/yyyy').format(startDate);
    }

    final diff = endDate.difference(startDate).inDays + 1;
    final totalDaysStr = '$diff ngày';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppThemeCard(
          padding: EdgeInsets.all(20.0.responsive()),
          borderRadius: 24.0.responsive(),
          borderColor: theme.primaryColor,
          borderWidth: 4.0.responsive(),
          shadowColor: Colors.black.withValues(alpha: 0.03),
          shadowBlurRadius: 10,
          shadowOffset: const Offset(0, 4),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header inside the card
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0.responsive()),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withValues(alpha: 0.12),
                    ),
                    child: Icon(
                      Icons.article_rounded,
                      color: Colors.green.shade700,
                      size: 18.0.responsive(),
                    ),
                  ),
                  SizedBox(width: 10.0.responsive()),
                  Text(
                    'Thông tin xin nghỉ',
                    style: TextStyle(
                      fontSize: 15.0.responsive(),
                      fontWeight: FontWeight.bold,
                      color: colors.primaryTextColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 18.0.responsive()),

              // Row 1: Type & Date
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildGridItem('Loại nghỉ', leaveType.label, colors),
                  ),
                  SizedBox(width: 16.0.responsive()),
                  Expanded(
                    child: _buildGridItem('Ngày nghỉ', dateRangeStr, colors),
                  ),
                ],
              ),
              SizedBox(height: 16.0.responsive()),

              // Row 2: Duration & Reason
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildGridItem('Số ngày nghỉ', totalDaysStr, colors),
                  ),
                  SizedBox(width: 16.0.responsive()),
                  Expanded(
                    child: _buildGridItem('Lý do xin nghỉ', reason, colors),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16.0.responsive()),

        // Refund/meal warning card
        Container(
          padding: EdgeInsets.all(16.0.responsive()),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.indigo.withValues(alpha: 0.15),
                Colors.blueAccent.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16.0.responsive()),
            border: Border.all(
              color: Colors.indigo.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Text(
            'Suất ăn bữa sáng và bữa trưa, xế sẽ được hệ thống tự động hủy theo số ngày nghỉ của học sinh. Phụ huynh được hoàn tiền bữa ăn theo quy định nghỉ phép của nhà trường.',
            style: TextStyle(
              fontSize: 12.0.responsive(),
              color: colors.primaryTextColor,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridItem(String label, String value, dynamic colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0.responsive(),
            color: colors.secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4.0.responsive()),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.0.responsive(),
            fontWeight: FontWeight.bold,
            color: colors.primaryTextColor,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  String _getDayOfWeekName(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'T2';
      case DateTime.tuesday:
        return 'T3';
      case DateTime.wednesday:
        return 'T4';
      case DateTime.thursday:
        return 'T5';
      case DateTime.friday:
        return 'T6';
      case DateTime.saturday:
        return 'T7';
      case DateTime.sunday:
        return 'CN';
      default:
        return '';
    }
  }
}
