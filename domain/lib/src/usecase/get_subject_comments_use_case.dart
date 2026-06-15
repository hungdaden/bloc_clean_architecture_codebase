import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain.dart';

part 'get_subject_comments_use_case.freezed.dart';

@Injectable()
class GetSubjectCommentsUseCase extends BaseFutureUseCase<GetSubjectCommentsInput, GetSubjectCommentsOutput> {
  const GetSubjectCommentsUseCase(this._repository);
  final Repository _repository;

  @protected
  @override
  Future<GetSubjectCommentsOutput> buildUseCase(GetSubjectCommentsInput input) async {
    final subjectComments = await _repository.getSubjectComments(input.commentId);
    return GetSubjectCommentsOutput(subjectComments: subjectComments);
  }
}

@freezed
class GetSubjectCommentsInput extends BaseInput with _$GetSubjectCommentsInput {
  const factory GetSubjectCommentsInput({required String commentId}) = _GetSubjectCommentsInput;
}

@freezed
class GetSubjectCommentsOutput extends BaseOutput with _$GetSubjectCommentsOutput {
  const factory GetSubjectCommentsOutput({
    @Default([]) List<SubjectComment> subjectComments,
  }) = _GetSubjectCommentsOutput;
}
