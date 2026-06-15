import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/domain.dart';

import '../../../app.dart';
import 'comment_list.dart';

@Injectable()
class CommentListBloc extends BaseBloc<CommentListEvent, CommentListState> {
  CommentListBloc(this._getCommentsUseCase) : super(CommentListState()) {
    on<CommentListPageInitiated>(
      _onCommentListPageInitiated,
      transformer: log(),
    );
  }

  final GetCommentsUseCase _getCommentsUseCase;

  FutureOr<void> _onCommentListPageInitiated(
      CommentListPageInitiated event, Emitter<CommentListState> emit) async {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        final output = await _getCommentsUseCase.execute(const GetCommentsInput());

        emit(state.copyWith(
          comments: output.comments,
          student: output.student,
        ));
      },
      doOnSubscribe: () async {
        emit(state.copyWith(isShimmerLoading: true));
      },
      doOnSuccessOrError: () async {
        emit(state.copyWith(isShimmerLoading: false));
      },
    );
  }
}
