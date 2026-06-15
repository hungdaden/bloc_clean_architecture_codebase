import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:domain/domain.dart';

import '../../../base/bloc/base_bloc_event.dart';

part 'admin_meal_event.freezed.dart';

abstract class AdminMealEvent extends BaseBlocEvent {
  const AdminMealEvent();
}

@freezed
class AdminMealPageInitiated extends AdminMealEvent with _$AdminMealPageInitiated {
  const factory AdminMealPageInitiated() = _AdminMealPageInitiated;
}

@freezed
class AdminMealAdded extends AdminMealEvent with _$AdminMealAdded {
  const factory AdminMealAdded({required Meal meal}) = _AdminMealAdded;
}

@freezed
class AdminMealUpdated extends AdminMealEvent with _$AdminMealUpdated {
  const factory AdminMealUpdated({
    required Meal oldMeal,
    required Meal newMeal,
  }) = _AdminMealUpdated;
}

@freezed
class AdminMealDeleted extends AdminMealEvent with _$AdminMealDeleted {
  const factory AdminMealDeleted({required Meal meal}) = _AdminMealDeleted;
}
