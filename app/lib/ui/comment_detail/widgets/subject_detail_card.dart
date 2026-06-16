import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import '../../../app.dart';

class SubjectDetailCard extends StatelessWidget {
  const SubjectDetailCard({
    super.key,
    required this.comment,
    required this.formattedDate,
  });

  final SubjectComment comment;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? theme.cardColor.withValues(alpha: 0.85)
            : Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(Dimens.d24.responsive()),
        border: Border(
          bottom: BorderSide(
            color: theme.primaryColor,
            width: 4.0.responsive(),
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.9,
              child: isDark
                  ? ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.4), BlendMode.dstATop),
                      child: Image.asset(
                        'assets/images/review_bg.webp',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      'assets/images/review_bg.webp',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Dimens.d20.responsive()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Nhận xét môn ${comment.subjectName}',
                  style: TextStyle(
                    fontSize: 18.0.responsive(),
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: Dimens.d4.responsive()),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 14.0.responsive(),
                    color: isDark ? Colors.white60 : Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: Dimens.d16.responsive()),
                Text(
                  comment.content,
                  style: TextStyle(
                    fontSize: 15.0.responsive(),
                    color: isDark ? Colors.white70 : Colors.black87,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: Dimens.d20.responsive()),
                const Divider(color: Colors.black12),
                SizedBox(height: Dimens.d10.responsive()),
                Row(
                  children: [
                    Container(
                      width: Dimens.d48.responsive(),
                      height: Dimens.d48.responsive(),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Dimens.d24.responsive()),
                        child: CachedNetworkImage(
                          imageUrl: comment.teacherAvatarUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(strokeWidth: 2),
                          errorWidget: (context, url, error) => const Icon(Icons.person),
                        ),
                      ),
                    ),
                    SizedBox(width: Dimens.d12.responsive()),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.teacherName,
                            style: TextStyle(
                              fontSize: 16.0.responsive(),
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          SizedBox(height: Dimens.d2.responsive()),
                          Text(
                            comment.teacherTitle,
                            style: TextStyle(
                              fontSize: 14.0.responsive(),
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
