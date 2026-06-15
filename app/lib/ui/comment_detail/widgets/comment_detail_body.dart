import 'package:flutter/material.dart';
import '../../../app.dart';
import '../bloc/comment_detail.dart';
import 'comment_detail_bottom_bar.dart';
import 'subject_detail_card.dart';
import 'subject_tabs_selector.dart';

class CommentDetailBody extends StatelessWidget {
  const CommentDetailBody({
    super.key,
    required this.state,
    required this.onTabChanged,
    required this.onBackPressed,
  });

  final CommentDetailState state;
  final ValueChanged<int> onTabChanged;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (state.subjectComments.isEmpty) {
      return Center(
        child: Text(
          'Không có nhận xét chi tiết nào',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      );
    }

    final currentComment = state.subjectComments[state.selectedTabIndex];
    final formattedDate =
        '${currentComment.date.day.toString().padLeft(2, '0')}/${currentComment.date.month.toString().padLeft(2, '0')}/${currentComment.date.year} ${currentComment.date.hour.toString().padLeft(2, '0')}:${currentComment.date.minute.toString().padLeft(2, '0')}';

    final headerHeight = 76.0.responsive();
    final bottomBarHeight = 82.0.responsive();

    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: Dimens.d16.responsive(),
              right: Dimens.d16.responsive(),
              top: headerHeight + Dimens.d8.responsive(),
              bottom: bottomBarHeight + MediaQuery.of(context).padding.bottom + Dimens.d16.responsive(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.student != null) StudentCard(student: state.student!),
                SubjectTabsSelector(
                  subjectComments: state.subjectComments,
                  selectedIndex: state.selectedTabIndex,
                  onTabChanged: onTabChanged,
                ),
                SizedBox(height: Dimens.d16.responsive()),
                SubjectDetailCard(
                  comment: currentComment,
                  formattedDate: formattedDate,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: CommentDetailBottomBar(
            teacherName: currentComment.teacherName,
            onBackPressed: onBackPressed,
          ),
        ),
      ],
    );
  }
}
