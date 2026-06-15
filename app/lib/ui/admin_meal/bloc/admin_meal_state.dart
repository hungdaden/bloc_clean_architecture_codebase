import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../base/bloc/base_bloc_state.dart';
import 'package:domain/domain.dart';

part 'admin_meal_state.freezed.dart';

@freezed
class AdminMealState extends BaseBlocState with _$AdminMealState {
  factory AdminMealState({
    @Default(false) bool isShimmerLoading,
    @Default([]) List<Meal> meals,
  }) = _AdminMealState;
}
