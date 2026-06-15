import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app.dart';

class LeaveTypeSelector extends StatelessWidget {
  const LeaveTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  final LeaveType? selectedType;
  final ValueChanged<LeaveType> onTypeSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0.responsive()),
          child: Text(
            'Loại nghỉ phép',
            style: TextStyle(
              fontSize: 14.0.responsive(),
              fontWeight: FontWeight.bold,
              color: colors.primaryTextColor,
            ),
          ),
        ),

        ...LeaveType.values.map((type) {
          final isSelected = selectedType == type;
          return Padding(
            padding: EdgeInsets.only(bottom: 12.0.responsive()),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                onTypeSelected(type);
              },
              child: AppThemeCard(
                padding: EdgeInsets.all(16.0.responsive()),
                borderRadius: 16.0.responsive(),
                backgroundColor: isSelected
                    ? theme.primaryColor.withValues(alpha: 0.05)
                    : theme.cardColor,
                borderColor: isSelected
                    ? theme.primaryColor
                    : theme.dividerColor.withValues(alpha: 0.5),
                borderWidth: isSelected ? 4.0.responsive() : 2.0.responsive(),
                showBorder: true,
                shadowColor: isSelected
                    ? theme.primaryColor.withValues(alpha: 0.08)
                    : Colors.black.withValues(alpha: 0.02),
                shadowBlurRadius: isSelected ? 12 : 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type.label,
                      style: TextStyle(
                        fontSize: 14.0.responsive(),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: colors.primaryTextColor,
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22.0.responsive(),
                      height: 22.0.responsive(),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? theme.primaryColor : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? theme.primaryColor
                              : theme.dividerColor,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Center(
                              child: Icon(
                                Icons.check,
                                size: 14.0.responsive(),
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
