import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../app.dart';

class CommentDetailBottomBar extends StatelessWidget {
  const CommentDetailBottomBar({
    super.key,
    required this.teacherName,
    required this.onBackPressed,
  });

  final String teacherName;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomColor = theme.scaffoldBackgroundColor;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned.fill(
          child: ShaderMask(
            shaderCallback: (rect) {
              return const LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black,
                  Colors.transparent,
                ],
                stops: [0.65, 1.0],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstIn,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.alphaBlend(
                      theme.primaryColor.withValues(alpha: isDark ? 0.25 : 0.2),
                      bottomColor,
                    ).withValues(alpha: isDark ? 0.95 : 0.9),
                    border: Border(
                      top: BorderSide(
                        color: theme.dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(Dimens.d16.responsive()),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onBackPressed,
                  child: Container(
                    width: 50.0.responsive(),
                    height: 50.0.responsive(),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.dividerColor,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: theme.colors.primaryTextColor,
                      size: 18.0.responsive(),
                    ),
                  ),
                ),
                SizedBox(width: Dimens.d16.responsive()),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final theme = Theme.of(context);
                      final isDark = theme.brightness == Brightness.dark;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          content: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Color.alphaBlend(
                                    theme.primaryColor.withValues(alpha: isDark ? 0.25 : 0.2),
                                    theme.cardColor,
                                  ).withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.dividerColor,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  'Đang kết nối chat với GVBM $teacherName...',
                                  style: TextStyle(
                                    color: theme.colors.primaryTextColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 50.0.responsive(),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius:
                            BorderRadius.circular(Dimens.d24.responsive()),
                        border: Border.all(
                          color: theme.dividerColor,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: theme.colors.primaryTextColor,
                            size: 20.0.responsive(),
                          ),
                          SizedBox(width: Dimens.d8.responsive()),
                          Text(
                            'Chat với GVBM',
                            style: TextStyle(
                              color: theme.colors.primaryTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0.responsive(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
