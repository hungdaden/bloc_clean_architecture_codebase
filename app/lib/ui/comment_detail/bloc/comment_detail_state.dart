import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:domain/domain.dart';

import '../../../base/bloc/base_bloc_state.dart';

part 'comment_detail_state.freezed.dart';

@freezed
class CommentDetailState extends BaseBlocState with _$CommentDetailState {
  const factory CommentDetailState({
    @Default(false) bool isShimmerLoading,
    @Default([]) List<SubjectComment> subjectComments,
    @Default(0) int selectedTabIndex,
    Student? student,
    Comment? comment,
  }) = _CommentDetailState;
}
