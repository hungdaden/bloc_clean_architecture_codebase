import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app.dart';

class StudentHorizontalSelector extends StatelessWidget {
  const StudentHorizontalSelector({
    super.key,
    required this.students,
    required this.selectedStudent,
    required this.onStudentSelected,
  });

  final List<Student> students;
  final Student? selectedStudent;
  final ValueChanged<Student> onStudentSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    return Container(
      height: 96.0.responsive(),
      margin: EdgeInsets.symmetric(vertical: 8.0.responsive()),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: students.length,
        padding: EdgeInsets.symmetric(horizontal: 16.0.responsive()),
        itemBuilder: (context, index) {
          final student = students[index];
          final isSelected = selectedStudent?.id == student.id;

          return GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              onStudentSelected(student);
            },
            child: Container(
              margin: EdgeInsets.only(right: 16.0.responsive()),
              width: 72.0.responsive(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 54.0.responsive(),
                    height: 54.0.responsive(),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? theme.primaryColor : Colors.transparent,
                        width: 3.5.responsive(),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: theme.primaryColor.withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : null,
                    ),
                    padding: isSelected ? EdgeInsets.all(2.0.responsive()) : EdgeInsets.zero,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(27.0.responsive()),
                      child: student.avatarUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: student.avatarUrl,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  _buildPlaceholder(colors),
                            )
                          : _buildPlaceholder(colors),
                    ),
                  ),
                  SizedBox(height: 6.0.responsive()),
                  Text(
                    student.firstName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.0.responsive(),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? theme.primaryColor : colors.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder(dynamic colors) {
    return Container(
      color: colors.secondaryTextColor.withValues(alpha: 0.1),
      child: Icon(
        Icons.person,
        color: colors.secondaryTextColor.withValues(alpha: 0.5),
        size: 24,
      ),
    );
  }
}
