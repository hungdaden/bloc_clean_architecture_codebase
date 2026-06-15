import 'package:flutter/material.dart';
import '../../../app.dart';

class DeleteStudentConfirmationDialog extends StatelessWidget {
  const DeleteStudentConfirmationDialog({
    super.key,
    required this.studentName,
    required this.onConfirm,
  });

  final String studentName;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0.responsive()),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      title: Text(
        'Xác nhận xoá',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: colors.primaryTextColor,
        ),
      ),
      content: Text(
        'Bạn có chắc chắn muốn xoá học sinh "$studentName"?',
        style: TextStyle(
          color: colors.primaryTextColor,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Huỷ',
            style: TextStyle(color: colors.secondaryTextColor),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0.responsive()),
            ),
          ),
          child: const Text('Xoá'),
        ),
      ],
    );
  }
}
