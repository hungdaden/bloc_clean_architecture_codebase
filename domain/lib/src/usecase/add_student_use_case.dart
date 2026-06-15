import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'add_student_use_case.freezed.dart';

@Injectable()
class AddStudentUseCase extends BaseFutureUseCase<AddStudentInput, AddStudentOutput> {
  const AddStudentUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<AddStudentOutput> buildUseCase(AddStudentInput input) async {
    final student = await _repository.addStudent(input.student);
    return AddStudentOutput(student: student);
  }
}

@freezed
class AddStudentInput extends BaseInput with _$AddStudentInput {
  const factory AddStudentInput({required Student student}) = _AddStudentInput;
}

@freezed
class AddStudentOutput extends BaseOutput with _$AddStudentOutput {
  const factory AddStudentOutput({required Student student}) = _AddStudentOutput;
}
