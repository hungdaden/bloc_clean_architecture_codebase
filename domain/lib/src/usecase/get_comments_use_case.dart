import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'get_comments_use_case.freezed.dart';

@Injectable()
class GetCommentsUseCase extends BaseFutureUseCase<GetCommentsInput, GetCommentsOutput> {
  const GetCommentsUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<GetCommentsOutput> buildUseCase(GetCommentsInput input) async {
    final results = await Future.wait([
      _repository.getComments(),
      _repository.getStudentInfo(),
    ]);
    return GetCommentsOutput(
      comments: results[0] as List<Comment>,
      student: results[1] as Student,
    );
  }
}

@freezed
class GetCommentsInput extends BaseInput with _$GetCommentsInput {
  const factory GetCommentsInput() = _GetCommentsInput;
}

@freezed
class GetCommentsOutput extends BaseOutput with _$GetCommentsOutput {
  const GetCommentsOutput._();

  const factory GetCommentsOutput({
    @Default([]) List<Comment> comments,
    Student? student,
  }) = _GetCommentsOutput;
}
