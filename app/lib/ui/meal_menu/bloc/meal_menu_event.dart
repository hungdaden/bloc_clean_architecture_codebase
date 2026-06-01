import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../base/bloc/base_bloc_event.dart';

part 'meal_menu_event.freezed.dart';

abstract class MealMenuEvent extends BaseBlocEvent {
  const MealMenuEvent();
}

@freezed
class MealMenuPageInitiated extends MealMenuEvent with _$MealMenuPageInitiated {
  const factory MealMenuPageInitiated() = _MealMenuPageInitiated;
}
