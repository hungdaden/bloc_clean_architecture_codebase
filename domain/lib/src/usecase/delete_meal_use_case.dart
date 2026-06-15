import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'delete_meal_use_case.freezed.dart';

@Injectable()
class DeleteMealUseCase extends BaseFutureUseCase<DeleteMealInput, DeleteMealOutput> {
  const DeleteMealUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<DeleteMealOutput> buildUseCase(DeleteMealInput input) async {
    await _repository.deleteMeal(input.meal);
    return const DeleteMealOutput();
  }
}

@freezed
class DeleteMealInput extends BaseInput with _$DeleteMealInput {
  const factory DeleteMealInput({required Meal meal}) = _DeleteMealInput;
}

@freezed
class DeleteMealOutput extends BaseOutput with _$DeleteMealOutput {
  const DeleteMealOutput._();
  const factory DeleteMealOutput() = _DeleteMealOutput;
}
