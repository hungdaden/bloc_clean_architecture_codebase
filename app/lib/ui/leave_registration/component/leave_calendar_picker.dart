import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../app.dart';

class LeaveCalendarPicker extends StatefulWidget {
  const LeaveCalendarPicker({
    super.key,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.onDatesChanged,
  });

  final LeaveType leaveType;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?, DateTime?) onDatesChanged;

  @override
  State<LeaveCalendarPicker> createState() => _LeaveCalendarPickerState();
}

class _LeaveCalendarPickerState extends State<LeaveCalendarPicker> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    // Default focus to startDate or current month
    _focusedMonth = widget.startDate ?? DateTime.now();
  }

  void _onDayTapped(DateTime date) {
    HapticFeedback.mediumImpact();
    if (widget.leaveType == LeaveType.singleDay ||
        widget.leaveType == LeaveType.halfDay) {
      widget.onDatesChanged(date, date);
    } else {
      // Range selection logic
      if (widget.startDate == null ||
          (widget.startDate != null && widget.endDate != null)) {
        widget.onDatesChanged(date, null);
      } else {
        if (date.isBefore(widget.startDate!)) {
          widget.onDatesChanged(date, null);
        } else {
          widget.onDatesChanged(widget.startDate, date);
        }
      }
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSelected(DateTime date) {
    if (widget.startDate == null) return false;
    if (widget.endDate == null) {
      return date.year == widget.startDate!.year &&
          date.month == widget.startDate!.month &&
          date.day == widget.startDate!.day;
    }
    // Check range inclusive
    final check = DateTime(date.year, date.month, date.day);
    final start = DateTime(
        widget.startDate!.year, widget.startDate!.month, widget.startDate!.day);
    final end = DateTime(
        widget.endDate!.year, widget.endDate!.month, widget.endDate!.day);
    return (check.isAfter(start) || check.isAtSameMomentAs(start)) &&
        (check.isBefore(end) || check.isAtSameMomentAs(end));
  }

  bool _isRangeEdge(DateTime date) {
    if (widget.startDate == null) return false;
    final check = DateTime(date.year, date.month, date.day);
    final start = DateTime(
        widget.startDate!.year, widget.startDate!.month, widget.startDate!.day);
    if (widget.endDate == null) {
      return check.isAtSameMomentAs(start);
    }
    final end = DateTime(
        widget.endDate!.year, widget.endDate!.month, widget.endDate!.day);
    return check.isAtSameMomentAs(start) || check.isAtSameMomentAs(end);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    // Calendar Calculations
    final firstDayOfMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    // Weekday offset (Monday as 1, Sunday as 7)
    // Convert so that Monday = 0, Sunday = 6
    final int weekdayOffset = (firstDayOfMonth.weekday - 1) % 7;

    // List of day cells to render
    final List<DateTime?> dayCells = [];
    for (int i = 0; i < weekdayOffset; i++) {
      dayCells.add(null); // Placeholders for previous month offset
    }
    for (int i = 1; i <= daysInMonth; i++) {
      dayCells.add(DateTime(_focusedMonth.year, _focusedMonth.month, i));
    }

    final totalGridCells = ((dayCells.length / 7).ceil()) * 7;
    while (dayCells.length < totalGridCells) {
      dayCells.add(null); // Placeholders for next month offset
    }

    final String monthHeader =
        'Tháng ${_focusedMonth.month} ${_focusedMonth.year}';

    return AppThemeCard(
      padding: EdgeInsets.all(12.0.responsive()),
      borderRadius: 24.0.responsive(),
      showBorder: true,
      borderColor: theme.primaryColor,
      borderWidth: 4.0.responsive(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  setState(() {
                    _focusedMonth = DateTime(
                        _focusedMonth.year, _focusedMonth.month - 1, 1);
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(6.0.responsive()),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColor.withValues(alpha: 0.12),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: theme.primaryColor,
                    size: 18.0.responsive(),
                  ),
                ),
              ),
              Text(
                monthHeader,
                style: TextStyle(
                  fontSize: 15.0.responsive(),
                  fontWeight: FontWeight.bold,
                  color: colors.primaryTextColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  setState(() {
                    _focusedMonth = DateTime(
                        _focusedMonth.year, _focusedMonth.month + 1, 1);
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(6.0.responsive()),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColor.withValues(alpha: 0.12),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: theme.primaryColor,
                    size: 18.0.responsive(),
                  ),
                ),
              ),
            ],
          ),
          Divider(color: theme.dividerColor),
          SizedBox(height: 6.0.responsive()),

          // Weekday Headers
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 7,
            physics: const NeverScrollableScrollPhysics(),
            children: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'].map((day) {
              return Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: 12.0.responsive(),
                    fontWeight: FontWeight.bold,
                    color: colors.secondaryTextColor,
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 6.0.responsive()),

          // day cell grids
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.34,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dayCells.length,
            itemBuilder: (context, index) {
              final date = dayCells[index];
              if (date == null) {
                return const SizedBox.shrink();
              }

              final isSelected = _isSelected(date);
              final isEdge = _isRangeEdge(date);
              final isToday = _isToday(date);
              final isOutOfMonth = date.month != _focusedMonth.month;
              final isWeekend = date.weekday == DateTime.saturday ||
                  date.weekday == DateTime.sunday;
              final isFaded = isOutOfMonth || isWeekend;

              return GestureDetector(
                onTap: () => _onDayTapped(date),
                child: Center(
                  child: Container(
                    margin: EdgeInsets.all(1.0.responsive()),
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? (isEdge
                              ? theme.primaryColor
                              : theme.primaryColor.withValues(alpha: 0.2))
                          : Colors.transparent,
                      border: isToday
                          ? Border.all(color: theme.primaryColor, width: 1.5)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 13.0.responsive(),
                        fontWeight: isSelected || isToday
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? (isEdge ? Colors.white : theme.primaryColor)
                            : (isFaded
                                ? colors.secondaryTextColor
                                    .withValues(alpha: 0.4)
                                : colors.primaryTextColor),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 6.0.responsive()),
          Divider(color: theme.dividerColor),
          SizedBox(height: 6.0.responsive()),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ngày nghỉ',
                      style: TextStyle(
                        fontSize: 12.0.responsive(),
                        color: colors.secondaryTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.0.responsive()),
                    Text(
                      _formatSelectedDates(),
                      style: TextStyle(
                        fontSize: 15.0.responsive(),
                        fontWeight: FontWeight.bold,
                        color: colors.primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0.responsive()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Số ngày nghỉ',
                        style: TextStyle(
                          fontSize: 12.0.responsive(),
                          color: colors.secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.0.responsive()),
                      Text(
                        _getLeaveDaysString(),
                        style: TextStyle(
                          fontSize: 15.0.responsive(),
                          fontWeight: FontWeight.bold,
                          color: colors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatSelectedDates() {
    if (widget.startDate == null) return '--';
    final formatter = DateFormat('dd/MM/yyyy');
    if (widget.endDate == null || widget.startDate == widget.endDate) {
      return formatter.format(widget.startDate!);
    }
    return '${formatter.format(widget.startDate!)} - ${formatter.format(widget.endDate!)}';
  }

  String _getLeaveDaysString() {
    if (widget.startDate == null) return '--';
    if (widget.endDate == null) return '1 ngày';
    final diff = widget.endDate!.difference(widget.startDate!).inDays + 1;
    return '$diff ngày';
  }
}
