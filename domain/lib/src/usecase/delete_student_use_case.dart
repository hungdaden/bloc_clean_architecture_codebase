import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'delete_student_use_case.freezed.dart';

@Injectable()
class DeleteStudentUseCase extends BaseFutureUseCase<DeleteStudentInput, DeleteStudentOutput> {
  const DeleteStudentUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<DeleteStudentOutput> buildUseCase(DeleteStudentInput input) async {
    await _repository.deleteStudent(input.id);
    return const DeleteStudentOutput();
  }
}

@freezed
class DeleteStudentInput extends BaseInput with _$DeleteStudentInput {
  const factory DeleteStudentInput({required String id}) = _DeleteStudentInput;
}

@freezed
class DeleteStudentOutput extends BaseOutput with _$DeleteStudentOutput {
  const factory DeleteStudentOutput() = _DeleteStudentOutput;
}
