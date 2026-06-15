import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import '../../../app.dart';

class SubjectTabsSelector extends StatelessWidget {
  const SubjectTabsSelector({
    super.key,
    required this.subjectComments,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  final List<SubjectComment> subjectComments;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0.responsive(),
      margin: EdgeInsets.symmetric(vertical: Dimens.d8.responsive()),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: subjectComments.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          final comment = subjectComments[index];
          final primaryColor = Theme.of(context).primaryColor;
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return Padding(
            padding: EdgeInsets.only(right: Dimens.d12.responsive()),
            child: GestureDetector(
              onTap: () => onTabChanged(index),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.d20.responsive(),
                  vertical: Dimens.d10.responsive(),
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor
                      : (isDark ? Colors.white10 : Colors.white),
                  borderRadius: BorderRadius.circular(Dimens.d24.responsive()),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark ? Colors.white24 : Colors.grey.shade300),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    comment.subjectName,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14.0.responsive(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
