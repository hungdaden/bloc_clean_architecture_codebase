import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app.dart';

class LeaveStatusCard extends StatelessWidget {
  const LeaveStatusCard({
    super.key,
    required this.request,
  });

  final LeaveRequest request;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    final startStr = DateFormat('dd/MM/yyyy').format(request.startDate);
    final endStr = DateFormat('dd/MM/yyyy').format(request.endDate);
    final periodStr = request.startDate == request.endDate ? startStr : '$startStr - $endStr';
    final diff = request.endDate.difference(request.startDate).inDays + 1;
    final totalDaysStr = '$diff ngày';

    return AppThemeCard(
      margin: EdgeInsets.only(bottom: 12.0.responsive()),
      padding: EdgeInsets.all(16.0.responsive()),
      borderRadius: 16.0.responsive(),
      borderColor: theme.primaryColor,
      borderWidth: 4.0.responsive(),
      shadowColor: Colors.black.withValues(alpha: 0.02),
      shadowBlurRadius: 10,
      shadowOffset: const Offset(0, 4),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  request.reason,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0.responsive(),
                    fontWeight: FontWeight.bold,
                    color: colors.primaryTextColor,
                  ),
                ),
              ),
              SizedBox(width: 8.0.responsive()),
              _buildStatusTag(request.status),
            ],
          ),
          SizedBox(height: 12.0.responsive()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.leaveType.label,
                    style: TextStyle(
                      fontSize: 12.0.responsive(),
                      color: colors.secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.0.responsive()),
                  Text(
                    periodStr,
                    style: TextStyle(
                      fontSize: 13.0.responsive(),
                      color: colors.primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0.responsive(), vertical: 4.0.responsive()),
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(12.0.responsive()),
                ),
                child: Text(
                  totalDaysStr,
                  style: TextStyle(
                    fontSize: 12.0.responsive(),
                    color: colors.primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(LeaveStatus status) {
    Color textColor;
    Color bgColor;

    switch (status) {
      case LeaveStatus.approved:
        textColor = Colors.green;
        bgColor = Colors.green.withValues(alpha: 0.1);
        break;
      case LeaveStatus.rejected:
        textColor = Colors.red;
        bgColor = Colors.red.withValues(alpha: 0.1);
        break;
      case LeaveStatus.pending:
      default:
        textColor = Colors.orange;
        bgColor = Colors.orange.withValues(alpha: 0.1);
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0.responsive(), vertical: 4.0.responsive()),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.0.responsive()),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 11.0.responsive(),
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
