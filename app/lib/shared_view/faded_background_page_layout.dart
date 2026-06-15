import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../app.dart';

class FadedBackgroundPageLayout extends StatefulWidget {
  const FadedBackgroundPageLayout({
    super.key,
    required this.title,
    this.subtitle,
    required this.onBackPressed,
    this.onSettingsPressed,
    required this.child,
    this.floatingActionButton,
    this.useSolidThemeBackground = false,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onBackPressed;
  final VoidCallback? onSettingsPressed;
  final Widget child;
  final Widget? floatingActionButton;
  final bool useSolidThemeBackground;

  @override
  State<FadedBackgroundPageLayout> createState() =>
      _FadedBackgroundPageLayoutState();
}

class _FadedBackgroundPageLayoutState extends State<FadedBackgroundPageLayout> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final topColor = theme.primaryColor.withValues(alpha: isDark ? 0.15 : 0.25);
    final bottomColor = theme.scaffoldBackgroundColor;
    final headerHeight =
        widget.subtitle != null ? 152.0.responsive() : 104.0.responsive();

    return CommonScaffold(
      backgroundColor: bottomColor,
      floatingActionButton: widget.floatingActionButton,
      body: SafeArea(
        child: Stack(
          children: [
            // Base background
            _FadingBackground(
              svgAssetPath: 'assets/images/review_bg.svg',
              topColor: topColor,
              bottomColor: bottomColor,
              height: MediaQuery.of(context).size.height * 0.33,
            ),

            // Animated Solid Theme background (Liquid paint pouring/sliding down from top)
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
                    Colors.black.withValues(alpha: 0.45), theme.primaryColor),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: MediaQuery.of(context).size.height * 0.33,
                      child: Opacity(
                        opacity: 0.08,
                        child: SvgPicture.asset(
                          'assets/images/review_bg.svg',
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

            // App Bar Header (Standard dynamic display with synchronized layout)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: headerHeight,
              child: widget.useSolidThemeBackground
                  ? Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(
                          top: 12.0.responsive(), bottom: 28.0.responsive()),
                      alignment: Alignment.topCenter,
                      child: ScreenHeader(
                        title: widget.title,
                        subtitle: widget.subtitle,
                        onBackPressed: widget.onBackPressed,
                        onSettingsPressed: widget.onSettingsPressed,
                        textColor: Colors.white,
                      ),
                    )
                  : ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
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
                            color: Color.alphaBlend(
                              theme.primaryColor
                                  .withValues(alpha: isDark ? 0.25 : 0.2),
                              bottomColor,
                            ).withValues(alpha: isDark ? 0.95 : 0.9),
                            padding: EdgeInsets.only(
                                top: 12.0.responsive(),
                                bottom: 28.0.responsive()),
                            alignment: Alignment.topCenter,
                            child: ScreenHeader(
                              title: widget.title,
                              subtitle: widget.subtitle,
                              onBackPressed: widget.onBackPressed,
                              onSettingsPressed: widget.onSettingsPressed,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FadingBackground extends StatelessWidget {
  const _FadingBackground({
    required this.svgAssetPath,
    required this.topColor,
    required this.bottomColor,
    required this.height,
  });

  final String svgAssetPath;
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
              child: SvgPicture.asset(
                svgAssetPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
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
