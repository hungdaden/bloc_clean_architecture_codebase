import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../base/bloc/base_bloc_state.dart';
import 'package:domain/domain.dart';

part 'meal_menu_state.freezed.dart';

@freezed
class MealMenuState extends BaseBlocState with _$MealMenuState {
  factory MealMenuState({
    @Default(false) bool isShimmerLoading,
    @Default([]) List<Meal> meals,
  }) = _MealMenuState;
}
