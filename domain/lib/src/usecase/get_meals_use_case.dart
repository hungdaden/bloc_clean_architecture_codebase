import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'get_meals_use_case.freezed.dart';

@Injectable()
class GetMealsUseCase extends BaseFutureUseCase<GetMealsInput, GetMealsOutput> {
  const GetMealsUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<GetMealsOutput> buildUseCase(GetMealsInput input) async {
    final meals = await _repository.getMeals();
    return GetMealsOutput(meals: meals);
  }
}

@freezed
class GetMealsInput extends BaseInput with _$GetMealsInput {
  const factory GetMealsInput() = _GetMealsInput;
}

@freezed
class GetMealsOutput extends BaseOutput with _$GetMealsOutput {
  const GetMealsOutput._();

  const factory GetMealsOutput({
    @Default([]) List<Meal> meals,
  }) = _GetMealsOutput;
}

