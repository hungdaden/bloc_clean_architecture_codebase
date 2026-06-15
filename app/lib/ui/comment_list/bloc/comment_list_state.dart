import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:domain/domain.dart';

import '../../../base/bloc/base_bloc_state.dart';

part 'comment_list_state.freezed.dart';

@freezed
class CommentListState extends BaseBlocState with _$CommentListState {
  factory CommentListState({
    @Default(false) bool isShimmerLoading,
    @Default([]) List<Comment> comments,
    Student? student,
  }) = _CommentListState;
}
