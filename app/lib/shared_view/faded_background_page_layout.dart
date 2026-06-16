import 'package:flutter/material.dart';
import '../app.dart';

class FadedBackgroundPageLayout extends StatefulWidget {
  const FadedBackgroundPageLayout({
    super.key,
    required this.title,
    this.subtitle,
    required this.onBackPressed,
    this.onSettingsPressed,
    this.rightIcon,
    required this.child,
    this.floatingActionButton,
    this.useSolidThemeBackground = false,
    this.titleFontSize,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onBackPressed;
  final VoidCallback? onSettingsPressed;
  final IconData? rightIcon;
  final Widget child;
  final Widget? floatingActionButton;
  final bool useSolidThemeBackground;
  final double? titleFontSize;

  @override
  State<FadedBackgroundPageLayout> createState() =>
      _FadedBackgroundPageLayoutState();
}

class _FadedBackgroundPageLayoutState extends State<FadedBackgroundPageLayout> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final topColor = theme.primaryColor.withValues(alpha: isDark ? 0.15 : 0.4);
    final bottomColor = theme.scaffoldBackgroundColor;
    final headerBgColor = Color.alphaBlend(
      theme.primaryColor.withValues(alpha: isDark ? 0.25 : 0.4),
      bottomColor,
    ).withValues(alpha: isDark ? 0.95 : 0.97);
    final headerHeight =
        widget.subtitle != null ? 152.0.responsive() : 104.0.responsive();

    return CommonScaffold(
      backgroundColor: bottomColor,
      floatingActionButton: widget.floatingActionButton,
      body: Stack(
        children: [
          _FadingBackground(
            imageAssetPath: 'assets/images/review_bg.webp',
            topColor: topColor,
            bottomColor: bottomColor,
            height: MediaQuery.of(context).size.height * 0.33,
          ),

          AnimatedPositioned(
            duration: widget.useSolidThemeBackground
                ? const Duration(milliseconds: 800)
                : Duration.zero,
            curve: Curves.fastOutSlowIn,
            top: widget.useSolidThemeBackground
                ? 0.0
                : -MediaQuery.of(context).size.height,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height,
            child: Container(
              color: Color.alphaBlend(
                  Colors.white.withValues(alpha: 0.45), theme.primaryColor),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: MediaQuery.of(context).size.height * 0.33,
                    child: Opacity(
                      opacity: 0.08,
                      child: Image.asset(
                        'assets/images/review_bg.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content (static viewport)
          Positioned.fill(
            child: widget.child,
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerHeight + MediaQuery.of(context).padding.top,
            child: widget.useSolidThemeBackground
                ? Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(
                        top: 12.0.responsive(), bottom: 28.0.responsive()),
                    alignment: Alignment.topCenter,
                    child: SafeArea(
                      child: ScreenHeader(
                        title: widget.title,
                        subtitle: widget.subtitle,
                        onBackPressed: widget.onBackPressed,
                        onSettingsPressed: widget.onSettingsPressed,
                        textColor: Colors.white,
                        rightIcon: widget.rightIcon,
                        titleFontSize: widget.titleFontSize,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          headerBgColor,
                          headerBgColor,
                          headerBgColor.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                    padding: EdgeInsets.only(
                        top: 12.0.responsive(), bottom: 28.0.responsive()),
                    alignment: Alignment.topCenter,
                    child: SafeArea(
                      child: ScreenHeader(
                        title: widget.title,
                        subtitle: widget.subtitle,
                        onBackPressed: widget.onBackPressed,
                        onSettingsPressed: widget.onSettingsPressed,
                        rightIcon: widget.rightIcon,
                        titleFontSize: widget.titleFontSize,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FadingBackground extends StatelessWidget {
  const _FadingBackground({
    required this.imageAssetPath,
    required this.topColor,
    required this.bottomColor,
    required this.height,
  });

  final String imageAssetPath;
  final Color topColor;
  final Color bottomColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: height,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: topColor,
              child: Image.asset(
                imageAssetPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    bottomColor.withValues(alpha: 0.0),
                    bottomColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
