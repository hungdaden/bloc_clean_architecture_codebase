import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

import '../../../app.dart';

class StudentProfileHeaderCard extends StatelessWidget {
  const StudentProfileHeaderCard({
    super.key,
    this.student,
    this.showBorder = true,
  });

  final Student? student;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    final fullName = student?.fullName ?? '';
    // Fallback or use student's cityName/id to simulate class details if not present
    final classDetails =
        student != null ? 'K12 - ${student!.id ?? '123456789'}' : '';
    final avatarUrl = student?.avatarUrl ?? '';

    return AppThemeCard(
      padding: EdgeInsets.all(16.0.responsive()),
      borderRadius: 16.0.responsive(),
      borderColor: theme.primaryColor,
      borderWidth: 4.0.responsive(),
      showBorder: showBorder,
      shadowColor: Colors.black.withValues(alpha: 0.04),
      shadowBlurRadius: 10,
      shadowOffset: const Offset(0, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: TextStyle(
                    fontSize: 18.0.responsive(),
                    fontWeight: FontWeight.bold,
                    color: colors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 4.0.responsive()),
                Text(
                  classDetails,
                  style: TextStyle(
                    fontSize: 13.0.responsive(),
                    color: colors.secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 52.0.responsive(),
            height: 52.0.responsive(),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.primaryColor.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26.0.responsive()),
              child: avatarUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: avatarUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: SizedBox(
                          width: 16.0.responsive(),
                          height: 16.0.responsive(),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          _buildPlaceholderIcon(colors),
                    )
                  : _buildPlaceholderIcon(colors),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderIcon(dynamic colors) {
    return Container(
      color: Colors.grey.withValues(alpha: 0.1),
      child: Icon(
        Icons.person,
        size: 32.0.responsive(),
        color: colors.secondaryTextColor,
      ),
    );
  }
}
