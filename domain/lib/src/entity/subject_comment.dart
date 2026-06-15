import 'package:freezed_annotation/freezed_annotation.dart';

part 'subject_comment.freezed.dart';

@freezed
class SubjectComment with _$SubjectComment {
  const factory SubjectComment({
    required String subjectName,
    required DateTime date,
    required String content,
    required String teacherName,
    required String teacherAvatarUrl,
    required String teacherTitle,
  }) = _SubjectComment;
}
