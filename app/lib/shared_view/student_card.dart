import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import '../app.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    return AppThemeCard(
      margin: EdgeInsets.only(bottom: Dimens.d16.responsive()),
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      borderRadius: Dimens.d24.responsive(),
      borderColor: theme.primaryColor,
      borderWidth: 4.0.responsive(),
      shadowColor: Colors.black12,
      shadowBlurRadius: 8,
      shadowOffset: const Offset(0, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.fullName,
                  style: TextStyle(
                    fontSize: 22.0.responsive(),
                    fontWeight: FontWeight.bold,
                    color: colors.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: Dimens.d64.responsive(),
            height: Dimens.d64.responsive(),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.dividerColor, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.d32.responsive()),
              child: CachedNetworkImage(
                imageUrl: student.avatarUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(strokeWidth: 2),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
