import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/domain.dart';

import '../../../app.dart';
import 'comment_detail.dart';

@Injectable()
class CommentDetailBloc extends BaseBloc<CommentDetailEvent, CommentDetailState> {
  CommentDetailBloc(
    this._getSubjectCommentsUseCase,
    this._repository,
  ) : super(const CommentDetailState()) {
    on<CommentDetailPageInitiated>(
      _onCommentDetailPageInitiated,
      transformer: log(),
    );

    on<CommentDetailTabChanged>(
      _onCommentDetailTabChanged,
      transformer: log(),
    );
  }

  final GetSubjectCommentsUseCase _getSubjectCommentsUseCase;
  final Repository _repository;

  Future<void> _onCommentDetailPageInitiated(
    CommentDetailPageInitiated event,
    Emitter<CommentDetailState> emit,
  ) async {
    emit(state.copyWith(
      isShimmerLoading: true,
      comment: event.comment,
    ));

    await runBlocCatching(
      action: () async {
        final student = await _repository.getStudentInfo();
        final output = await _getSubjectCommentsUseCase.execute(
          GetSubjectCommentsInput(commentId: event.comment.id),
        );

        emit(state.copyWith(
          isShimmerLoading: false,
          student: student,
          subjectComments: output.subjectComments,
          selectedTabIndex: 0,
        ));
      },
      handleError: false,
    );
  }

  void _onCommentDetailTabChanged(
    CommentDetailTabChanged event,
    Emitter<CommentDetailState> emit,
  ) {
    emit(state.copyWith(selectedTabIndex: event.tabIndex));
  }
}
