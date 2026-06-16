import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app.dart';

class BreakfastTermsDialog extends StatefulWidget {
  const BreakfastTermsDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  State<BreakfastTermsDialog> createState() => _BreakfastTermsDialogState();
}

class _BreakfastTermsDialogState extends State<BreakfastTermsDialog> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.0.responsive()),
          padding: EdgeInsets.all(20.0.responsive()),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(24.0.responsive()),
            border: Border(
              top: BorderSide(
                color: theme.primaryColor,
                width: 1.0.responsive(),
              ),
              left: BorderSide(
                color: theme.primaryColor,
                width: 1.0.responsive(),
              ),
              right: BorderSide(
                color: theme.primaryColor,
                width: 1.0.responsive(),
              ),
              bottom: BorderSide(
                color: theme.primaryColor,
                width: 4.0.responsive(),
              ),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, 8),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Điều khoản dịch vụ ăn sáng',
                style: TextStyle(
                  fontSize: 18.0.responsive(),
                  fontWeight: FontWeight.bold,
                  color: colors.primaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.0.responsive()),
              Container(
                height: 160.0.responsive(),
                decoration: BoxDecoration(
                  color: colors.secondaryTextColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12.0.responsive()),
                  border: Border.all(color: Colors.black12),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(12.0.responsive()),
                  child: Text(
                    '1. Dịch vụ ăn sáng được phục vụ từ thứ 2 đến thứ 6 hàng tuần, bắt đầu từ lúc 07:00 đến 07:45 tại căng tin nhà trường.\n\n'
                    '2. Học phí ăn sáng được tính theo số ngày học thực tế của học kỳ (30.000 đ/ngày x 88 ngày = 2.640.000 đ).\n\n'
                    '3. Phụ huynh có quyền hủy đăng ký dịch vụ ăn sáng khi có lý do chính đáng. Yêu cầu hủy dịch vụ phải được gửi trước ít nhất 3 ngày làm việc.\n\n'
                    '4. Học phí dịch vụ ăn sáng đã đóng sẽ không được hoàn trả nếu học sinh tự ý bỏ bữa không báo trước.',
                    style: TextStyle(
                      fontSize: 13.0.responsive(),
                      color: colors.secondaryTextColor,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.0.responsive()),
              Row(
                children: [
                  Checkbox(
                    value: _isAgreed,
                    onChanged: (val) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _isAgreed = val ?? false;
                      });
                    },
                    activeColor: theme.primaryColor,
                  ),
                  Expanded(
                    child: Text(
                      'Tôi đã đọc và đồng ý với các điều khoản của dịch vụ ăn sáng.',
                      style: TextStyle(
                        fontSize: 12.0.responsive(),
                        fontWeight: FontWeight.w500,
                        color: colors.primaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0.responsive()),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        widget.onCancel();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.secondaryTextColor,
                        side: BorderSide(color: theme.dividerColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0.responsive()),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.0.responsive()),
                      ),
                      child: const Text('Hủy'),
                    ),
                  ),
                  SizedBox(width: 12.0.responsive()),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isAgreed
                          ? () {
                              HapticFeedback.mediumImpact();
                              widget.onConfirm();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.grey.shade500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0.responsive()),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.0.responsive()),
                        elevation: 0,
                      ),
                      child: const Text('Xác nhận'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
