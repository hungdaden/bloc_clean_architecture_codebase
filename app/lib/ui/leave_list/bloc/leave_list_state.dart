import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:domain/domain.dart';

import '../../../base/bloc/base_bloc_state.dart';

part 'leave_list_state.freezed.dart';

@freezed
class LeaveListState extends BaseBlocState with _$LeaveListState {
  factory LeaveListState({
    @Default(false) bool isShimmerLoading,
    @Default([]) List<LeaveRequest> requests,
    @Default(0) int selectedTabIndex,
    Student? student,
  }) = _LeaveListState;
}
