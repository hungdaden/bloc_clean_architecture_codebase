import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/domain.dart';

import '../../../app.dart';
import 'leave_registration.dart';

@Injectable()
class LeaveRegistrationBloc extends BaseBloc<LeaveRegistrationEvent, LeaveRegistrationState> {
  LeaveRegistrationBloc(
    this._addLeaveRequestUseCase,
    this._repository,
  ) : super(LeaveRegistrationState()) {
    on<LeaveRegistrationPageInitiated>(
      _onLeaveRegistrationPageInitiated,
      transformer: log(),
    );
    on<LeaveRegistrationStepChanged>(
      _onLeaveRegistrationStepChanged,
      transformer: log(),
    );
    on<LeaveRegistrationTypeSelected>(
      _onLeaveRegistrationTypeSelected,
      transformer: log(),
    );
    on<LeaveRegistrationDatesChanged>(
      _onLeaveRegistrationDatesChanged,
      transformer: log(),
    );
    on<LeaveRegistrationReasonChanged>(
      _onLeaveRegistrationReasonChanged,
      transformer: log(),
    );
    on<LeaveRegistrationSubmitPressed>(
      _onLeaveRegistrationSubmitPressed,
      transformer: log(),
    );
  }

  final AddLeaveRequestUseCase _addLeaveRequestUseCase;
  final Repository _repository;

  FutureOr<void> _onLeaveRegistrationPageInitiated(
      LeaveRegistrationPageInitiated event, Emitter<LeaveRegistrationState> emit) async {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        final student = await _repository.getStudentInfo();
        emit(state.copyWith(student: student));
      },
      doOnSubscribe: () async {
        emit(state.copyWith(isShimmerLoading: true));
      },
      doOnSuccessOrError: () async {
        emit(state.copyWith(isShimmerLoading: false));
      },
    );
  }

  FutureOr<void> _onLeaveRegistrationStepChanged(
      LeaveRegistrationStepChanged event, Emitter<LeaveRegistrationState> emit) {
    final newStep = event.isNext ? state.currentStep + 1 : state.currentStep - 1;
    if (newStep >= 0 && newStep <= 3) {
      emit(state.copyWith(currentStep: newStep));
    }
  }

  FutureOr<void> _onLeaveRegistrationTypeSelected(
      LeaveRegistrationTypeSelected event, Emitter<LeaveRegistrationState> emit) {
    emit(state.copyWith(
      leaveType: event.leaveType,
      startDate: null,
      endDate: null,
    ));
  }

  FutureOr<void> _onLeaveRegistrationDatesChanged(
      LeaveRegistrationDatesChanged event, Emitter<LeaveRegistrationState> emit) {
    emit(state.copyWith(
      startDate: event.startDate,
      endDate: event.endDate,
    ));
  }

  FutureOr<void> _onLeaveRegistrationReasonChanged(
      LeaveRegistrationReasonChanged event, Emitter<LeaveRegistrationState> emit) {
    emit(state.copyWith(reason: event.reason));
  }

  FutureOr<void> _onLeaveRegistrationSubmitPressed(
      LeaveRegistrationSubmitPressed event, Emitter<LeaveRegistrationState> emit) async {
    if (state.leaveType == null || state.startDate == null || state.endDate == null || state.reason.length < 6) {
      return;
    }

    return runBlocCatching(
      handleLoading: true,
      action: () async {
        final request = LeaveRequest(
          leaveType: state.leaveType!,
          startDate: state.startDate!,
          endDate: state.endDate!,
          reason: state.reason,
          status: LeaveStatus.pending,
          createdAt: DateTime.now(),
        );

        await _addLeaveRequestUseCase.execute(AddLeaveRequestInput(request: request));
        navigator.pop(result: true);
      },

    );
  }
}
