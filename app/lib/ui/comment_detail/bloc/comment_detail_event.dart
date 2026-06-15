import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:domain/domain.dart';

import '../../../base/bloc/base_bloc_event.dart';

part 'comment_detail_event.freezed.dart';

abstract class CommentDetailEvent extends BaseBlocEvent {
  const CommentDetailEvent();
}

@freezed
class CommentDetailPageInitiated extends CommentDetailEvent with _$CommentDetailPageInitiated {
  const factory CommentDetailPageInitiated({
    required Comment comment,
  }) = _CommentDetailPageInitiated;
}

@freezed
class CommentDetailTabChanged extends CommentDetailEvent with _$CommentDetailTabChanged {
  const factory CommentDetailTabChanged({
    required int tabIndex,
  }) = _CommentDetailTabChanged;
}
