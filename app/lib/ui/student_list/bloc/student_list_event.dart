import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../base/bloc/base_bloc_event.dart';

part 'student_list_event.freezed.dart';

abstract class StudentListEvent extends BaseBlocEvent {
  const StudentListEvent();
}

@freezed
class StudentListPageInitiated extends StudentListEvent with _$StudentListPageInitiated {
  const factory StudentListPageInitiated() = _StudentListPageInitiated;
}

@freezed
class StudentListRefreshRequested extends StudentListEvent with _$StudentListRefreshRequested {
  const factory StudentListRefreshRequested() = _StudentListRefreshRequested;
}

@freezed
class StudentListAddPressed extends StudentListEvent with _$StudentListAddPressed {
  const factory StudentListAddPressed({required Student student}) = _StudentListAddPressed;
}

@freezed
class StudentListEditPressed extends StudentListEvent with _$StudentListEditPressed {
  const factory StudentListEditPressed({required Student student}) = _StudentListEditPressed;
}

@freezed
class StudentListDeletePressed extends StudentListEvent with _$StudentListDeletePressed {
  const factory StudentListDeletePressed({required String id}) = _StudentListDeletePressed;
}

@freezed
class StudentListSearchKeywordChanged extends StudentListEvent with _$StudentListSearchKeywordChanged {
  const factory StudentListSearchKeywordChanged({required String keyword}) = _StudentListSearchKeywordChanged;
}

@freezed
class StudentListSearchFieldChanged extends StudentListEvent with _$StudentListSearchFieldChanged {
  const factory StudentListSearchFieldChanged({required String field}) = _StudentListSearchFieldChanged;
}
