import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../base/bloc/base_bloc_event.dart';

part 'comment_list_event.freezed.dart';

abstract class CommentListEvent extends BaseBlocEvent {
  const CommentListEvent();
}

@freezed
class CommentListPageInitiated extends CommentListEvent with _$CommentListPageInitiated {
  const factory CommentListPageInitiated() = _CommentListPageInitiated;
}
