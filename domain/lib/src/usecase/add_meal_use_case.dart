import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'add_meal_use_case.freezed.dart';

@Injectable()
class AddMealUseCase extends BaseFutureUseCase<AddMealInput, AddMealOutput> {
  const AddMealUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<AddMealOutput> buildUseCase(AddMealInput input) async {
    await _repository.addMeal(input.meal);
    return const AddMealOutput();
  }
}

@freezed
class AddMealInput extends BaseInput with _$AddMealInput {
  const factory AddMealInput({required Meal meal}) = _AddMealInput;
}

@freezed
class AddMealOutput extends BaseOutput with _$AddMealOutput {
  const AddMealOutput._();
  const factory AddMealOutput() = _AddMealOutput;
}
