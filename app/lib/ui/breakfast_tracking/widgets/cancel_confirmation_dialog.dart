import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app.dart';

class CancelConfirmationDialog extends StatefulWidget {
  const CancelConfirmationDialog({
    super.key,
    required this.studentName,
    required this.onConfirm,
    required this.onCancel,
  });

  final String studentName;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  /// Show the dialog as a bottom sheet with slide-up animation.
  static Future<void> show(
    BuildContext context, {
    required String studentName,
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
        return CancelConfirmationDialog(
          studentName: studentName,
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
  State<CancelConfirmationDialog> createState() =>
      _CancelConfirmationDialogState();
}

class _CancelConfirmationDialogState extends State<CancelConfirmationDialog> {
  final _reasonController = TextEditingController();
  bool _hasReason = false;

  @override
  void initState() {
    super.initState();
    _reasonController.addListener(() {
      final hasText = _reasonController.text.trim().isNotEmpty;
      if (hasText != _hasReason) {
        setState(() {
          _hasReason = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final isDark = theme.brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final primaryHSL = HSLColor.fromColor(theme.primaryColor);
    final darkerPrimary = primaryHSL
        .withLightness((primaryHSL.lightness - 0.15).clamp(0.0, 1.0))
        .toColor();

    // Confirm button colors
    final outerColor = _hasReason
        ? darkerPrimary
        : (isDark ? Colors.grey.shade700 : Colors.grey.shade300);

    final innerColor = _hasReason
        ? theme.primaryColor
        : (isDark
            ? Colors.grey.shade900.withValues(alpha: 0.4)
            : Colors.grey.shade100);

    final textColor = _hasReason
        ? Colors.white
        : (isDark ? Colors.grey.shade500 : Colors.grey.shade400);

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
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
                  'Xác nhận huỷ dịch vụ ăn sáng',
                  style: TextStyle(
                    fontSize: 18.0.responsive(),
                    fontWeight: FontWeight.bold,
                    color: colors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 16.0.responsive()),

                // Description points
                _buildNumberedPoint(
                  '1',
                  'Huỷ dịch vụ ăn sáng sẽ áp dụng từ tháng sau tháng hiện tại đến tháng kết thúc năm học.',
                  colors,
                ),
                SizedBox(height: 10.0.responsive()),
                _buildNumberedPoint(
                  '2',
                  'Học sinh vẫn tiếp tục sử dụng bữa sáng trong tháng hiện tại theo đơn đăng ký trước đó.',
                  colors,
                ),
                SizedBox(height: 20.0.responsive()),

                // Reason text field
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0.responsive()),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.15)
                          : Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                  child: TextField(
                    controller: _reasonController,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 14.0.responsive(),
                      color: colors.primaryTextColor,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Lý do huỷ dịch vụ',
                      labelStyle: TextStyle(
                        fontSize: 13.0.responsive(),
                        color: colors.secondaryTextColor,
                      ),
                      hintText: 'Nhập lý do',
                      hintStyle: TextStyle(
                        fontSize: 14.0.responsive(),
                        color: colors.secondaryTextColor.withValues(alpha: 0.5),
                      ),
                      filled: false,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16.0.responsive()),
                    ),
                  ),
                ),
                SizedBox(height: 20.0.responsive()),

                // Confirm button with animated color change
                GestureDetector(
                  onTap: _hasReason
                      ? () {
                          HapticFeedback.mediumImpact();
                          widget.onConfirm();
                        }
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: 50.0.responsive(),
                    decoration: BoxDecoration(
                      color: outerColor,
                      borderRadius: BorderRadius.circular(25.0.responsive()),
                      boxShadow: _hasReason
                          ? [
                              BoxShadow(
                                color: theme.primaryColor.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    padding: EdgeInsets.only(
                      top: 1.0.responsive(),
                      left: 1.0.responsive(),
                      right: 1.0.responsive(),
                      bottom: 4.0.responsive(), // Thick bottom border
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: innerColor,
                        borderRadius: BorderRadius.circular(24.0.responsive()),
                      ),
                      alignment: Alignment.center,
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: 15.0.responsive(),
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        child: const Text('Xác nhận'),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.0.responsive()),

                // Close button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    widget.onCancel();
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
      ),
    );
  }

  Widget _buildNumberedPoint(
      String number, String text, dynamic colors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number. ',
          style: TextStyle(
            fontSize: 14.0.responsive(),
            fontWeight: FontWeight.bold,
            color: colors.primaryTextColor,
            height: 1.5,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.0.responsive(),
              color: colors.primaryTextColor,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
