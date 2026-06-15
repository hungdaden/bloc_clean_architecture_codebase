import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:domain/domain.dart';

import '../../../base/bloc/base_bloc_state.dart';

part 'student_list_state.freezed.dart';

@freezed
class StudentListState extends BaseBlocState with _$StudentListState {
  factory StudentListState({
    @Default(false) bool isShimmerLoading,
    @Default([]) List<Student> students,
    @Default('') String searchKeyword,
    @Default('search') String searchField,
  }) = _StudentListState;
}
