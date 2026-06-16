import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app.dart';

class DeleteCancelConfirmationDialog extends StatelessWidget {
  const DeleteCancelConfirmationDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  /// Show the dialog as a bottom sheet with slide-up animation.
  static Future<void> show(
    BuildContext context, {
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      enableDrag: true,
      builder: (bottomSheetContext) {
        return DeleteCancelConfirmationDialog(
          onConfirm: () {
            Navigator.of(bottomSheetContext).pop();
            onConfirm();
          },
          onCancel: () {
            Navigator.of(bottomSheetContext).pop();
            onCancel();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final isDark = theme.brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.0.responsive()),
          topRight: Radius.circular(28.0.responsive()),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.0.responsive(),
            right: 24.0.responsive(),
            top: 16.0.responsive(),
            bottom: bottomPadding > 0 ? 8.0.responsive() : 20.0.responsive(),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40.0.responsive(),
                  height: 4.0.responsive(),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(2.0.responsive()),
                  ),
                ),
              ),
              SizedBox(height: 20.0.responsive()),

              // Title
              Text(
                'Xoá đơn huỷ dịch vụ ăn sáng?',
                style: TextStyle(
                  fontSize: 18.0.responsive(),
                  fontWeight: FontWeight.bold,
                  color: colors.primaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0.responsive()),

              // Description Text
              Text(
                'Học sinh vẫn tiếp tục sử dụng bữa sáng trong các tháng tiếp theo theo đơn đăng ký trước đó.',
                style: TextStyle(
                  fontSize: 14.0.responsive(),
                  color: colors.primaryTextColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.0.responsive()),

              // Confirm Button (styled red border/fill like the main action)
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  onConfirm();
                },
                child: Container(
                  height: 50.0.responsive(),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC62828), // Outer solid red border line
                    borderRadius: BorderRadius.circular(25.0.responsive()),
                  ),
                  padding: EdgeInsets.only(
                    top: 1.0.responsive(),
                    left: 1.0.responsive(),
                    right: 1.0.responsive(),
                    bottom: 4.0.responsive(), // Thick bottom border
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF3D1D1D) // Opaque dark red for dark mode
                          : const Color(0xFFFFECEC), // Opaque soft red for light mode
                      borderRadius: BorderRadius.circular(24.0.responsive()),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Xác nhận',
                      style: TextStyle(
                        color: const Color(0xFFC62828),
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0.responsive(),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.0.responsive()),

              // Close button
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  onCancel();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.responsive()),
                  child: Text(
                    'Đóng',
                    style: TextStyle(
                      fontSize: 15.0.responsive(),
                      fontWeight: FontWeight.bold,
                      color: colors.primaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
