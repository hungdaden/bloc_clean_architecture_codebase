import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'update_meal_use_case.freezed.dart';

@Injectable()
class UpdateMealUseCase extends BaseFutureUseCase<UpdateMealInput, UpdateMealOutput> {
  const UpdateMealUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<UpdateMealOutput> buildUseCase(UpdateMealInput input) async {
    await _repository.updateMeal(input.meal);
    return const UpdateMealOutput();
  }
}

@freezed
class UpdateMealInput extends BaseInput with _$UpdateMealInput {
  const factory UpdateMealInput({required Meal meal}) = _UpdateMealInput;
}

@freezed
class UpdateMealOutput extends BaseOutput with _$UpdateMealOutput {
  const UpdateMealOutput._();
  const factory UpdateMealOutput() = _UpdateMealOutput;
}
