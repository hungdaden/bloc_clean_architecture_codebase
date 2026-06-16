import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    required this.onBackPressed,
    this.onSettingsPressed,
    this.textColor,
    this.rightIcon,
    this.titleFontSize,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onBackPressed;
  final VoidCallback? onSettingsPressed;
  final Color? textColor;
  final IconData? rightIcon;
  final double? titleFontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.d16.responsive()),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 56.0.responsive(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      onBackPressed();
                    },
                    child: Container(
                      padding: EdgeInsets.all(Dimens.d10.responsive()),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: isDark ? Colors.white : Colors.black,
                        size: 16,
                      ),
                    ),
                  ),
                ),

                // Title
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48.0.responsive()),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: titleFontSize ?? 20.0.responsive(),
                        fontWeight: FontWeight.bold,
                        color: textColor ?? (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                  ),
                ),

                // Settings Button
                if (onSettingsPressed != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        onSettingsPressed!();
                      },
                      child: Container(
                        padding: EdgeInsets.all(Dimens.d10.responsive()),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          rightIcon ?? Icons.settings,
                          color: isDark ? Colors.white : Colors.black,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Subtitle section positioned below the action buttons
          if (subtitle != null) ...[
            SizedBox(height: 8.0.responsive()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.responsive()),
              child: Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.0.responsive(),
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                  color: (textColor ?? (isDark ? Colors.white : Colors.black87)).withValues(alpha: 0.85),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
