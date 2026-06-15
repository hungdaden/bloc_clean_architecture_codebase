import 'package:flutter/material.dart';

import '../app.dart';

class AppThemeCard extends StatelessWidget {
  const AppThemeCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.shadowColor,
    this.shadowBlurRadius,
    this.shadowOffset,
    this.showBorder = true,
    this.duration = const Duration(milliseconds: 250),
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final Color? shadowColor;
  final double? shadowBlurRadius;
  final Offset? shadowOffset;
  final bool showBorder;
  final Duration duration;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final finalBorderRadius = borderRadius ?? 16.0.responsive();
    final finalBorderColor = borderColor ?? theme.primaryColor;
    final finalBorderWidth = borderWidth ?? 4.0.responsive();
    final finalBackgroundColor = backgroundColor ?? theme.cardColor;

    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeInOut,
      margin: margin,
      padding: padding ?? EdgeInsets.all(16.0.responsive()),
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: finalBackgroundColor,
        borderRadius: BorderRadius.circular(finalBorderRadius),
        border: Border(
          bottom: BorderSide(
            color: showBorder ? finalBorderColor : Colors.transparent,
            width: showBorder ? finalBorderWidth : 0.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? Colors.black.withValues(alpha: 0.02),
            blurRadius: shadowBlurRadius ?? 10.0,
            offset: shadowOffset ?? const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
