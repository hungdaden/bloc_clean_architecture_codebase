import 'package:flutter/material.dart';

import '../../../app.dart';

class AttendanceStatusCard extends StatelessWidget {
  const AttendanceStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.responsive()),
          child: Text(
            'Điểm danh đầu giờ (1)',
            style: TextStyle(
              fontSize: 14.0.responsive(),
              fontWeight: FontWeight.bold,
              color: colors.primaryTextColor,
            ),
          ),
        ),

        AppThemeCard(
          padding: EdgeInsets.all(16.0.responsive()),
          borderRadius: 16.0.responsive(),
          borderColor: theme.primaryColor,
          borderWidth: 4.0.responsive(),
          shadowColor: Colors.black.withValues(alpha: 0.02),
          shadowBlurRadius: 10,
          shadowOffset: const Offset(0, 4),

          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vắng điểm danh đầu giờ',
                    style: TextStyle(
                      fontSize: 13.0.responsive(),
                      color: colors.secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0.responsive(), vertical: 4.0.responsive()),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.0.responsive()),
                    ),
                    child: Text(
                      'Không phép',
                      style: TextStyle(
                        fontSize: 11.0.responsive(),
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.responsive()),
                child: Divider(color: theme.dividerColor, height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GVCN điểm danh',
                    style: TextStyle(
                      fontSize: 13.0.responsive(),
                      color: colors.secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'T2, 21/12/2026-08:30',
                    style: TextStyle(
                      fontSize: 13.0.responsive(),
                      color: colors.primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
