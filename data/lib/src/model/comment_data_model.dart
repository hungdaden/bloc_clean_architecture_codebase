import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_data_model.freezed.dart';
part 'comment_data_model.g.dart';

@freezed
class CommentDataModel with _$CommentDataModel {
  const factory CommentDataModel({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'date') DateTime? date,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'numberOfSubjects') int? numberOfSubjects,
    @JsonKey(name: 'isNew') bool? isNew,
    @JsonKey(name: 'content') String? content,
  }) = _CommentDataModel;

  factory CommentDataModel.fromJson(Map<String, dynamic> json) =>
      _$CommentDataModelFromJson(json);
}
