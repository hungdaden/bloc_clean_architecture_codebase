import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:domain/domain.dart';

import '../../../base/bloc/base_bloc_event.dart';

part 'leave_registration_event.freezed.dart';

abstract class LeaveRegistrationEvent extends BaseBlocEvent {
  const LeaveRegistrationEvent();
}

@freezed
class LeaveRegistrationPageInitiated extends LeaveRegistrationEvent with _$LeaveRegistrationPageInitiated {
  const factory LeaveRegistrationPageInitiated() = _LeaveRegistrationPageInitiated;
}

@freezed
class LeaveRegistrationStepChanged extends LeaveRegistrationEvent with _$LeaveRegistrationStepChanged {
  const factory LeaveRegistrationStepChanged({required bool isNext}) = _LeaveRegistrationStepChanged;
}

@freezed
class LeaveRegistrationTypeSelected extends LeaveRegistrationEvent with _$LeaveRegistrationTypeSelected {
  const factory LeaveRegistrationTypeSelected({required LeaveType leaveType}) = _LeaveRegistrationTypeSelected;
}

@freezed
class LeaveRegistrationDatesChanged extends LeaveRegistrationEvent with _$LeaveRegistrationDatesChanged {
  const factory LeaveRegistrationDatesChanged({
    DateTime? startDate,
    DateTime? endDate,
  }) = _LeaveRegistrationDatesChanged;
}

@freezed
class LeaveRegistrationReasonChanged extends LeaveRegistrationEvent with _$LeaveRegistrationReasonChanged {
  const factory LeaveRegistrationReasonChanged({required String reason}) = _LeaveRegistrationReasonChanged;
}

@freezed
class LeaveRegistrationSubmitPressed extends LeaveRegistrationEvent with _$LeaveRegistrationSubmitPressed {
  const factory LeaveRegistrationSubmitPressed() = _LeaveRegistrationSubmitPressed;
}
