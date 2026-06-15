import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'update_student_use_case.freezed.dart';

@Injectable()
class UpdateStudentUseCase extends BaseFutureUseCase<UpdateStudentInput, UpdateStudentOutput> {
  const UpdateStudentUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<UpdateStudentOutput> buildUseCase(UpdateStudentInput input) async {
    final student = await _repository.updateStudent(input.student);
    return UpdateStudentOutput(student: student);
  }
}

@freezed
class UpdateStudentInput extends BaseInput with _$UpdateStudentInput {
  const factory UpdateStudentInput({required Student student}) = _UpdateStudentInput;
}

@freezed
class UpdateStudentOutput extends BaseOutput with _$UpdateStudentOutput {
  const factory UpdateStudentOutput({required Student student}) = _UpdateStudentOutput;
}
