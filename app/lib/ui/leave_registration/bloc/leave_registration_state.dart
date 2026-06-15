import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:domain/domain.dart';

import '../../../base/bloc/base_bloc_state.dart';

part 'leave_registration_state.freezed.dart';

@freezed
class LeaveRegistrationState extends BaseBlocState with _$LeaveRegistrationState {
  factory LeaveRegistrationState({
    @Default(false) bool isShimmerLoading,
    @Default(false) bool isSubmitting,
    @Default(0) int currentStep, // 0: select type, 1: select date, 2: input reason, 3: confirm
    Student? student,
    LeaveType? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    @Default('') String reason,
  }) = _LeaveRegistrationState;
}
