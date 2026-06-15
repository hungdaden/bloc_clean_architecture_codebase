import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../base/bloc/base_bloc_event.dart';

part 'leave_list_event.freezed.dart';

abstract class LeaveListEvent extends BaseBlocEvent {
  const LeaveListEvent();
}

@freezed
class LeaveListPageInitiated extends LeaveListEvent with _$LeaveListPageInitiated {
  const factory LeaveListPageInitiated() = _LeaveListPageInitiated;
}

@freezed
class LeaveListRefreshRequested extends LeaveListEvent with _$LeaveListRefreshRequested {
  const factory LeaveListRefreshRequested() = _LeaveListRefreshRequested;
}

@freezed
class LeaveListTabChanged extends LeaveListEvent with _$LeaveListTabChanged {
  const factory LeaveListTabChanged({required int index}) = _LeaveListTabChanged;
}
