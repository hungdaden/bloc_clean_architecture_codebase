import 'package:flutter/material.dart';

import '../../../app.dart';

class LeaveReasonInput extends StatefulWidget {
  const LeaveReasonInput({
    super.key,
    required this.reason,
    required this.onReasonChanged,
  });

  final String reason;
  final ValueChanged<String> onReasonChanged;

  @override
  State<LeaveReasonInput> createState() => _LeaveReasonInputState();
}

class _LeaveReasonInputState extends State<LeaveReasonInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.reason);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final isTooShort = widget.reason.length < 6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0.responsive()),
          child: Text(
            'Lý do xin nghỉ',
            style: TextStyle(
              fontSize: 14.0.responsive(),
              fontWeight: FontWeight.bold,
              color: colors.primaryTextColor,
            ),
          ),
        ),

        AppThemeCard(
          padding: EdgeInsets.zero,
          borderRadius: 16.0.responsive(),
          borderColor: isTooShort
              ? Colors.redAccent.withValues(alpha: 0.5)
              : theme.primaryColor,
          borderWidth: 4.0.responsive(),
          showBorder: true,
          child: TextField(
            controller: _controller,
            maxLines: 6,
            onChanged: widget.onReasonChanged,
            style: TextStyle(
              fontSize: 14.0.responsive(),
              color: colors.primaryTextColor,
            ),
            decoration: InputDecoration(
              hintText: 'Nhập lý do xin nghỉ...',
              hintStyle: TextStyle(
                color: colors.secondaryTextColor.withValues(alpha: 0.6),
                fontSize: 14.0.responsive(),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.0.responsive()),
            ),
          ),
        ),
        SizedBox(height: 8.0.responsive()),
        AnimatedOpacity(
          opacity: isTooShort ? 1.0 : 0.4,
          duration: const Duration(milliseconds: 200),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14.0.responsive(),
                color: isTooShort ? Colors.redAccent : colors.secondaryTextColor,
              ),
              SizedBox(width: 4.0.responsive()),
              Expanded(
                child: Text(
                  'Lý do xin nghỉ không được ít hơn 6 ký tự.',
                  style: TextStyle(
                    fontSize: 12.0.responsive(),
                    color: isTooShort ? Colors.redAccent : colors.secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
