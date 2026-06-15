import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';

@freezed
class Student with _$Student {
  const factory Student({
    required String firstName,
    required String fullName,
    required String avatarUrl,
    String? id,
    String? emoji,
    String? sex,
    String? cityName,
    String? birthdate,
    Map<String, dynamic>? rawJson,
  }) = _Student;
}
