import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app.dart';
import '../bloc/breakfast_tracking_state.dart';

class BreakfastStatusCard extends StatelessWidget {
  const BreakfastStatusCard({
    super.key,
    required this.student,
    required this.status,
    required this.onCancelPendingPressed,
  });

  final Student student;
  final BreakfastStatus status;
  final VoidCallback onCancelPendingPressed;

  Widget _buildStatusChip(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    
    IconData iconData;
    String label;
    Color color;
    Color bgColor;

    switch (status) {
      case BreakfastStatus.active:
        iconData = Icons.check_circle;
        label = 'Đang sử dụng';
        color = const Color(0xFF2E7D32);
        bgColor = const Color(0xFFE8F5E9);
        break;
      case BreakfastStatus.pending:
        iconData = Icons.pending_rounded;
        label = 'Chờ duyệt';
        color = const Color(0xFFE65100);
        bgColor = const Color(0xFFFFF3E0);
        break;
      case BreakfastStatus.cancelled:
        iconData = Icons.cancel;
        label = 'Từ chối';
        color = const Color(0xFFC62828);
        bgColor = const Color(0xFFFFEBEE);
        break;
      case BreakfastStatus.notRegistered:
        iconData = Icons.info_outline;
        label = 'Chưa đăng ký';
        color = Colors.grey.shade600;
        bgColor = Colors.grey.shade100;
        break;
      case BreakfastStatus.approved:
        iconData = Icons.check_circle;
        label = 'Đã duyệt';
        color = const Color(0xFF2E7D32);
        bgColor = const Color(0xFFE8F5E9);
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0.responsive(),
        vertical: 4.0.responsive(),
      ),
      decoration: BoxDecoration(
        color: isDark ? color.withValues(alpha: 0.15) : bgColor,
        borderRadius: BorderRadius.circular(12.0.responsive()),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            size: 14.0.responsive(),
            color: color,
          ),
          SizedBox(width: 4.0.responsive()),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0.responsive(),
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = isDark ? Colors.white.withValues(alpha: 0.15) : Colors.grey.shade400;
    final shadowColor = isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.02);

    return GestureDetector(
      onTap: status == BreakfastStatus.cancelled
          ? null
          : () {
              HapticFeedback.mediumImpact();
              onCancelPendingPressed();
            },
      child: AppThemeCard(
        margin: EdgeInsets.only(bottom: Dimens.d16.responsive()),
        padding: EdgeInsets.all(16.0.responsive()),
        borderRadius: 20.0.responsive(),
        borderColor: borderColor,
        borderWidth: 4.0.responsive(),
        showBorder: true,
        shadowColor: shadowColor,
        shadowBlurRadius: 10,
        shadowOffset: const Offset(0, 4),
        backgroundColor: theme.cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row (Avatar, Name, Action button)
            Row(
              children: [
                Container(
                  width: 44.0.responsive(),
                  height: 44.0.responsive(),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors.secondaryTextColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22.0.responsive()),
                    child: student.avatarUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: student.avatarUrl,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                _buildPlaceholder(colors),
                          )
                        : _buildPlaceholder(colors),
                  ),
                ),
                SizedBox(width: 12.0.responsive()),
                Expanded(
                  child: Text(
                    student.fullName,
                    style: TextStyle(
                      fontSize: 16.0.responsive(),
                      fontWeight: FontWeight.bold,
                      color: colors.primaryTextColor,
                    ),
                  ),
                ),
                if (status == BreakfastStatus.active || status == BreakfastStatus.pending || status == BreakfastStatus.approved)
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      onCancelPendingPressed();
                    },
                    child: Container(
                      width: 28.0.responsive(),
                      height: 28.0.responsive(),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF2E7D32),
                        size: 14,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.0.responsive()),
            // Grid Fields (Row 1)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lớp học',
                        style: TextStyle(
                          fontSize: 12.0.responsive(),
                          color: colors.secondaryTextColor,
                        ),
                      ),
                      SizedBox(height: 4.0.responsive()),
                      Text(
                        '11D2', // Mocked to match screenshot
                        style: TextStyle(
                          fontSize: 14.0.responsive(),
                          fontWeight: FontWeight.bold,
                          color: colors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mã học sinh',
                        style: TextStyle(
                          fontSize: 12.0.responsive(),
                          color: colors.secondaryTextColor,
                        ),
                      ),
                      SizedBox(height: 4.0.responsive()),
                      Text(
                        student.id ?? 'PS01092007',
                        style: TextStyle(
                          fontSize: 14.0.responsive(),
                          fontWeight: FontWeight.bold,
                          color: colors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.0.responsive()),
            // Grid Fields (Row 2)
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Loại đăng ký',
                        style: TextStyle(
                          fontSize: 12.0.responsive(),
                          color: colors.secondaryTextColor,
                        ),
                      ),
                      SizedBox(height: 4.0.responsive()),
                      Text(
                        'Đăng ký cả năm', // Mocked to match screenshot
                        style: TextStyle(
                          fontSize: 14.0.responsive(),
                          fontWeight: FontWeight.bold,
                          color: colors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trạng thái',
                        style: TextStyle(
                          fontSize: 12.0.responsive(),
                          color: colors.secondaryTextColor,
                        ),
                      ),
                      SizedBox(height: 4.0.responsive()),
                      _buildStatusChip(theme),
                    ],
                  ),
                ),
              ],
            ),
            // Bữa đã dùng section (not shown for unregistered)
            if (status != BreakfastStatus.notRegistered) ...[
              SizedBox(height: 12.0.responsive()),
              Divider(color: colors.secondaryTextColor.withValues(alpha: 0.1)),
              SizedBox(height: 8.0.responsive()),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0.responsive(),
                    vertical: 10.0.responsive(),
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12.0.responsive()),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Bữa đã dùng',
                        style: TextStyle(
                          fontSize: 12.0.responsive(),
                          color: colors.secondaryTextColor,
                        ),
                      ),
                      SizedBox(height: 4.0.responsive()),
                      Text(
                        '12/30',
                        style: TextStyle(
                          fontSize: 16.0.responsive(),
                          fontWeight: FontWeight.bold,
                          color: colors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(dynamic colors) {
    return Container(
      color: colors.secondaryTextColor.withValues(alpha: 0.1),
      child: Icon(
        Icons.person,
        color: colors.secondaryTextColor.withValues(alpha: 0.5),
        size: 20,
      ),
    );
  }
}
