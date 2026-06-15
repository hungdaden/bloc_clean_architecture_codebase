import 'package:freezed_annotation/freezed_annotation.dart';

part 'student_data_model.freezed.dart';
part 'student_data_model.g.dart';

@freezed
class StudentDataModel with _$StudentDataModel {
  const factory StudentDataModel({
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'emoji') String? emoji,
    @JsonKey(name: 'sex') String? sex,
    @JsonKey(name: 'city_name') String? cityName,
    @JsonKey(name: 'birthdate') String? birthdate,
    @JsonKey(includeFromJson: false, includeToJson: false)
    Map<String, dynamic>? rawJson,
  }) = _StudentDataModel;

  factory StudentDataModel.fromJson(Map<String, dynamic> json) =>
      _$StudentDataModelFromJson(json);
}
