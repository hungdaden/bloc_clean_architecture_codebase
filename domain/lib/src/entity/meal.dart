import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain.dart';

part 'meal.freezed.dart';

@freezed
class Meal with _$Meal {
  const factory Meal({
    DateTime? date,
    @Default('') String title,
    @Default(MealType.defaultValue) MealType type,
    @Default('') String time,
    @Default('') String mainDish,
    @Default('') String sideDish,
    @Default('') String calories,
  }) = _Meal;
}
