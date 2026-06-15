import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'get_students_use_case.freezed.dart';

@Injectable()
class GetStudentsUseCase extends BaseFutureUseCase<GetStudentsInput, GetStudentsOutput> {
  const GetStudentsUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<GetStudentsOutput> buildUseCase(GetStudentsInput input) async {
    final students = await _repository.getStudents(
      search: input.search,
      name: input.name,
      fullName: input.fullName,
      cityName: input.cityName,
      sex: input.sex,
    );
    return GetStudentsOutput(students: students);
  }
}

@freezed
class GetStudentsInput extends BaseInput with _$GetStudentsInput {
  const factory GetStudentsInput({
    String? search,
    String? name,
    String? fullName,
    String? cityName,
    String? sex,
  }) = _GetStudentsInput;
}

@freezed
class GetStudentsOutput extends BaseOutput with _$GetStudentsOutput {
  const GetStudentsOutput._();

  const factory GetStudentsOutput({
    @Default([]) List<Student> students,
  }) = _GetStudentsOutput;
}
