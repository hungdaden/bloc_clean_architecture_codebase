import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal_data_model.freezed.dart';
part 'meal_data_model.g.dart';

@freezed
class MealDataModel with _$MealDataModel {
  const factory MealDataModel({
    @JsonKey(name: 'date') DateTime? date,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'type') int? type,
    @JsonKey(name: 'time') String? time,
    @JsonKey(name: 'mainDish') String? mainDish,
    @JsonKey(name: 'sideDish') String? sideDish,
    @JsonKey(name: 'calories') String? calories,
  }) = _MealDataModel;

  factory MealDataModel.fromJson(Map<String, dynamic> json) =>
      _$MealDataModelFromJson(json);
}
