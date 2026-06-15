import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app.dart';

class StudentInfoCard extends StatelessWidget {
  const StudentInfoCard({
    super.key,
    required this.student,
    this.onDelete,
    this.onEdit,
  });

  final Student student;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final isDark = theme.brightness == Brightness.dark;

    final rawJson = student.rawJson ?? {};
    final ignoredKeys = {'avatar_url', 'avatarurl', 'first_name', 'firstname', 'emoji', 'name'};

    final infoRows = rawJson.entries
        .where((entry) => !ignoredKeys.contains(entry.key.toLowerCase()) && entry.value != null && entry.value.toString().isNotEmpty)
        .map((entry) {
          final key = entry.key;
          final label = _formatKeyLabel(key);
          final value = _formatValue(key, entry.value);
          final icon = _getIconForKey(key);
          final iconColor = _getIconColorForKey(key);
          
          return Padding(
            padding: EdgeInsets.only(bottom: Dimens.d4.responsive()),
            child: _InfoRow(
              icon: icon,
              iconColor: iconColor,
              label: label,
              value: value,
            ),
          );
        })
        .toList();

    return Container(
      margin: EdgeInsets.only(bottom: Dimens.d16.responsive()),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [theme.cardColor, theme.cardColor.withValues(alpha: 0.8)]
              : [Colors.white, theme.cardColor.withValues(alpha: 0.5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Dimens.d24.responsive()),
        border: Border.all(
          color: theme.primaryColor.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Emoji floating background badge
          if (student.emoji != null)
            Positioned(
              right: -10.0.responsive(),
              top: -10.0.responsive(),
              child: Opacity(
                opacity: 0.08,
                child: Text(
                  student.emoji!,
                  style: TextStyle(fontSize: 80.0.responsive()),
                ),
              ),
            ),
          
          Padding(
            padding: EdgeInsets.all(Dimens.d16.responsive()),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar representation
                Container(
                  width: 80.0.responsive(),
                  height: 80.0.responsive(),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        theme.primaryColor.withValues(alpha: 0.4),
                        theme.primaryColor.withValues(alpha: 0.1),
                      ],
                    ),
                    border: Border.all(
                      color: theme.primaryColor.withValues(alpha: 0.3),
                      width: 2.0.responsive(),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.0.responsive()),
                    child: CachedNetworkImage(
                      imageUrl: student.avatarUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          width: 24.0.responsive(),
                          height: 24.0.responsive(),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.person,
                        size: 40.0.responsive(),
                        color: colors.secondaryTextColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Dimens.d16.responsive()),
                
                // Content representation
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full name and Emoji
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              student.firstName,
                              style: TextStyle(
                                fontSize: 18.0.responsive(),
                                fontWeight: FontWeight.bold,
                                color: colors.primaryTextColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (student.emoji != null) ...[
                            SizedBox(width: Dimens.d4.responsive()),
                            Text(
                              student.emoji!,
                              style: TextStyle(fontSize: 18.0.responsive()),
                            ),
                          ],
                          if (onEdit != null) ...[
                            SizedBox(width: Dimens.d8.responsive()),
                            GestureDetector(
                              onTap: onEdit,
                              child: Icon(
                                Icons.edit_outlined,
                                color: colors.secondaryTextColor,
                                size: 20.0.responsive(),
                              ),
                            ),
                          ],
                          if (onDelete != null) ...[
                            SizedBox(width: Dimens.d8.responsive()),
                            GestureDetector(
                              onTap: onDelete,
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                                size: 20.0.responsive(),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: Dimens.d8.responsive()),
                      
                      // Details list (dynamic map rows)
                      if (infoRows.isEmpty)
                        Text(
                          'Không có chi tiết thông tin',
                          style: TextStyle(
                            fontSize: 13.0.responsive(),
                            color: colors.secondaryTextColor,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      else
                        ...infoRows,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatKeyLabel(String key) {
    switch (key.toLowerCase()) {
      case 'first_name':
        return 'Tên';
      case 'full_name':
        return 'Họ và tên';
      case 'sex':
        return 'Giới tính';
      case 'city_name':
        return 'Thành phố';
      case 'birthdate':
        return 'Ngày sinh';
      case 'id':
        return 'Mã số';
      default:
        // Format e.g. "gpa_score" -> "Gpa Score"
        return key
            .split('_')
            .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
            .join(' ');
    }
  }

  String _formatValue(String key, dynamic value) {
    if (value == null) return 'N/A';
    final valStr = value.toString();
    
    if (key.toLowerCase() == 'sex') {
      return valStr.toLowerCase() == 'female' ? 'Nữ' : 'Nam';
    }
    
    if (key.toLowerCase() == 'birthdate') {
      final dateTime = DateTime.tryParse(valStr);
      if (dateTime != null) {
        return DateFormat('dd/MM/yyyy').format(dateTime);
      }
    }
    
    return valStr;
  }

  IconData _getIconForKey(String key) {
    switch (key.toLowerCase()) {
      case 'first_name':
        return Icons.person_outline;
      case 'full_name':
        return Icons.badge_outlined;
      case 'sex':
        return Icons.wc_outlined;
      case 'city_name':
        return Icons.location_on_outlined;
      case 'birthdate':
        return Icons.calendar_month_outlined;
      case 'id':
        return Icons.badge_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color? _getIconColorForKey(String key) {
    if (key.toLowerCase() == 'sex') {
      final isFemale = student.sex?.toLowerCase() == 'female';
      return isFemale ? Colors.pinkAccent : Colors.blueAccent;
    }
    return null;
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color? iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    
    return Row(
      children: [
        Icon(
          icon,
          size: 16.0.responsive(),
          color: iconColor ?? colors.secondaryTextColor,
        ),
        SizedBox(width: Dimens.d8.responsive()),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 13.0.responsive(),
            color: colors.secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: Dimens.d4.responsive()),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.0.responsive(),
              color: colors.primaryTextColor,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
