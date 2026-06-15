import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../app.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.comment});

  final Comment comment;

  List<Color> _getGradientColors(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    if (primary.value == const Color(0xFF2E7D32).value) {
      return [const Color(0xFF4CAF50), const Color(0xFF2E7D32)];
    } else if (primary.value == const Color(0xFFD81B60).value) {
      return [const Color(0xFFEC407A), const Color(0xFFD81B60)];
    } else if (primary.value == const Color(0xFFE65100).value) {
      return [const Color(0xFFFF9800), const Color(0xFFE65100)];
    }
    return [primary.withValues(alpha: 0.7), primary];
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${comment.date.day.toString().padLeft(2, '0')}/${comment.date.month.toString().padLeft(2, '0')}/${comment.date.year} ${comment.date.hour.toString().padLeft(2, '0')}:${comment.date.minute.toString().padLeft(2, '0')}';

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (comment.isNew) {
      return Container(
        margin: EdgeInsets.only(bottom: Dimens.d16.responsive()),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.d24.responsive()),
          gradient: LinearGradient(
            colors: _getGradientColors(context),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                child: SvgPicture.asset(
                  'assets/images/review_bg.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Dimens.d16.responsive()),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Dimens.d44.responsive(),
                    height: Dimens.d44.responsive(),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_note,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  SizedBox(width: Dimens.d12.responsive()),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8.0.responsive(),
                              height: 8.0.responsive(),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: Dimens.d6.responsive()),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 14.0.responsive(),
                                color: Colors.white.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimens.d6.responsive()),
                        Text(
                          comment.title,
                          style: TextStyle(
                            fontSize: 16.0.responsive(),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: Dimens.d6.responsive()),
                        Row(
                          children: [
                            Container(
                              width: 6.0.responsive(),
                              height: 6.0.responsive(),
                              decoration: const BoxDecoration(
                                color: Colors.white60,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: Dimens.d6.responsive()),
                            Text(
                              '${comment.numberOfSubjects} môn học được nhận xét',
                              style: TextStyle(
                                fontSize: 14.0.responsive(),
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimens.d12.responsive()),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimens.d12.responsive(),
                            vertical: Dimens.d6.responsive(),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius:
                                BorderRadius.circular(Dimens.d20.responsive()),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.info,
                                color: Color(0xFF1E88E5),
                                size: 16,
                              ),
                              SizedBox(width: Dimens.d4.responsive()),
                              Text(
                                'Nhận xét mới',
                                style: TextStyle(
                                  fontSize: 12.0.responsive(),
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E88E5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Dimens.d8.responsive()),
                  Container(
                    width: Dimens.d32.responsive(),
                    height: Dimens.d32.responsive(),
                    decoration: const BoxDecoration(
                      color: Colors.white30,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return AppThemeCard(
        margin: EdgeInsets.only(bottom: Dimens.d16.responsive()),
        padding: EdgeInsets.zero,
        borderRadius: Dimens.d24.responsive(),
        backgroundColor: isDark ? theme.cardColor.withValues(alpha: 0.85) : Colors.white.withValues(alpha: 0.85),
        borderColor: theme.primaryColor,
        borderWidth: 4.0.responsive(),
        shadowColor: Colors.black12,
        shadowBlurRadius: 6,
        shadowOffset: const Offset(0, 3),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.9,
                child: SvgPicture.asset(
                  'assets/images/review_bg.svg',
                  fit: BoxFit.cover,
                  colorFilter: isDark
                      ? ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.4), BlendMode.dstATop)
                      : null,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(Dimens.d16.responsive()),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Dimens.d44.responsive(),
                    height: Dimens.d44.responsive(),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_note,
                      color: theme.primaryColor,
                      size: 26.0.responsive(),
                    ),
                  ),
                  SizedBox(width: Dimens.d12.responsive()),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8.0.responsive(),
                              height: 8.0.responsive(),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: Dimens.d6.responsive()),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 14.0.responsive(),
                                color: isDark ? Colors.white70 : Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimens.d6.responsive()),
                        Text(
                          comment.title,
                          style: TextStyle(
                            fontSize: 16.0.responsive(),
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        SizedBox(height: Dimens.d6.responsive()),
                        Row(
                          children: [
                            Container(
                              width: 6.0.responsive(),
                              height: 6.0.responsive(),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: Dimens.d6.responsive()),
                            Text(
                              '${comment.numberOfSubjects} môn học được nhận xét',
                              style: TextStyle(
                                fontSize: 14.0.responsive(),
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: Dimens.d8.responsive()),
                  Container(
                    width: Dimens.d32.responsive(),
                    height: Dimens.d32.responsive(),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: isDark ? Colors.white : Colors.black87,
                      size: 16.0.responsive(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
