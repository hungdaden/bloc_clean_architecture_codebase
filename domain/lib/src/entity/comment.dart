import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';

@freezed
class Comment with _$Comment {
  const factory Comment({
    required String id,
    required DateTime date,
    required String title,
    required int numberOfSubjects,
    @Default(false) bool isNew,
    @Default('') String content,
  }) = _Comment;
}
