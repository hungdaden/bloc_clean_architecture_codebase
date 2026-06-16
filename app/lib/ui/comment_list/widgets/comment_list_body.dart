import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import '../../../app.dart';
import '../bloc/comment_list.dart';

class CommentListBody extends StatelessWidget {
  const CommentListBody({
    super.key,
    required this.state,
    required this.onCommentTap,
  });

  final CommentListState state;
  final ValueChanged<Comment> onCommentTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (state.comments.isEmpty) {
      return Center(
        child: Text(
          'Không có nhận xét nào',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      );
    }

    final headerHeight = 104.0.responsive();

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: Dimens.d16.responsive(),
        right: Dimens.d16.responsive(),
        bottom: Dimens.d8.responsive(),
        top: headerHeight +
            MediaQuery.of(context).padding.top +
            Dimens.d8.responsive(),
      ),
      child: Column(
        children: [
          if (state.student != null) StudentCard(student: state.student!),
          ...state.comments.map(
            (comment) => GestureDetector(
              onTap: () => onCommentTap(comment),
              child: CommentCard(comment: comment),
            ),
          ),
        ],
      ),
    );
  }
}
