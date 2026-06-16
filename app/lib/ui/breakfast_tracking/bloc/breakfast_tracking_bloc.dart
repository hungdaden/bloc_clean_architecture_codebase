import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../app.dart';
import 'breakfast_tracking_event.dart';
import 'breakfast_tracking_state.dart';

@injectable
class BreakfastTrackingBloc extends BaseBloc<BreakfastTrackingEvent, BreakfastTrackingState> {
  BreakfastTrackingBloc()
      : super(const BreakfastTrackingState(
          studentsStatus: {},
          currentStep: BreakfastScreenStep.list,
        )) {
    on<BreakfastTrackingInitiated>(_onInitiated);
    on<RegisterButtonPressed>(_onRegisterButtonPressed);
    on<CancelButtonPressed>(_onCancelButtonPressed);
    on<StudentSelected>(_onStudentSelected);
    on<TermsAgreedChanged>(_onTermsAgreedChanged);
    on<RegisterSubmitPressed>(_onRegisterSubmitPressed);
    on<CancelPendingRequestPressed>(_onCancelPendingRequestPressed);
    on<CancelReasonChanged>(_onCancelReasonChanged);
    on<ConfirmCancellation>(_onConfirmCancellation);
    on<StudentCardPressed>(_onStudentCardPressed);
    on<CancelServicePressed>(_onCancelServicePressed);
    on<WithdrawCancellation>(_onWithdrawCancellation);
  }

  FutureOr<void> _onInitiated(
      BreakfastTrackingInitiated event, Emitter<BreakfastTrackingState> emit) {
    // Populate mock students and initial statuses
    const studentA = Student(
      firstName: 'Nam',
      fullName: 'Nguyễn Văn Nam',
      avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=120',
      id: '20261101',
    );
    const studentB = Student(
      firstName: 'Hồng',
      fullName: 'Trần Thị Hồng',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=120',
      id: '20261102',
    );
    const studentC = Student(
      firstName: 'Tuấn',
      fullName: 'Lê Minh Tuấn',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=120',
      id: '20261103',
    );
    const studentD = Student(
      firstName: 'Yến',
      fullName: 'Phạm Hải Yến',
      avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=120',
      id: '20261104',
    );

    final mockData = {
      studentA: BreakfastStatus.active,
      studentB: BreakfastStatus.notRegistered,
      studentC: BreakfastStatus.pending,
      studentD: BreakfastStatus.cancelled,
    };

    emit(BreakfastTrackingState(
      studentsStatus: mockData,
      currentStep: BreakfastScreenStep.list,
      selectedStudentForRegister: studentB, // default selector in step 2
    ));
  }

  FutureOr<void> _onRegisterButtonPressed(
      RegisterButtonPressed event, Emitter<BreakfastTrackingState> emit) {
    emit(state.copyWith(
      currentStep: BreakfastScreenStep.register,
      termsAgreed: false,
    ));
  }

  FutureOr<void> _onCancelButtonPressed(
      CancelButtonPressed event, Emitter<BreakfastTrackingState> emit) {
    if (state.currentStep == BreakfastScreenStep.cancelReason) {
      emit(state.copyWith(
        currentStep: BreakfastScreenStep.details,
      ));
    } else if (state.currentStep == BreakfastScreenStep.cancelDetails) {
      emit(state.copyWith(
        currentStep: BreakfastScreenStep.list,
      ));
    } else {
      emit(state.copyWith(
        currentStep: BreakfastScreenStep.list,
      ));
    }
  }

  FutureOr<void> _onStudentSelected(
      StudentSelected event, Emitter<BreakfastTrackingState> emit) {
    emit(state.copyWith(
      selectedStudentForRegister: event.student,
    ));
  }

  FutureOr<void> _onTermsAgreedChanged(
      TermsAgreedChanged event, Emitter<BreakfastTrackingState> emit) {
    emit(state.copyWith(
      termsAgreed: event.agreed,
    ));
  }

  FutureOr<void> _onRegisterSubmitPressed(
      RegisterSubmitPressed event, Emitter<BreakfastTrackingState> emit) async {
    if (state.selectedStudentForRegister == null) return;
    
    emit(state.copyWith(isSubmitting: true));
    
    // Simulate brief API call delay
    await Future.delayed(const Duration(milliseconds: 300));

    final updatedMap = Map<Student, BreakfastStatus>.from(state.studentsStatus);
    updatedMap[state.selectedStudentForRegister!] = BreakfastStatus.pending;

    emit(state.copyWith(
      studentsStatus: updatedMap,
      currentStep: BreakfastScreenStep.list,
      isSubmitting: false,
    ));
  }

  FutureOr<void> _onCancelPendingRequestPressed(
      CancelPendingRequestPressed event, Emitter<BreakfastTrackingState> emit) {
    emit(state.copyWith(
      selectedStudentForRegister: event.student,
      currentStep: BreakfastScreenStep.cancelReason,
      cancelReason: '',
    ));
  }

  FutureOr<void> _onCancelReasonChanged(
      CancelReasonChanged event, Emitter<BreakfastTrackingState> emit) {
    emit(state.copyWith(
      cancelReason: event.reason,
    ));
  }

  FutureOr<void> _onConfirmCancellation(
      ConfirmCancellation event, Emitter<BreakfastTrackingState> emit) async {
    emit(state.copyWith(isSubmitting: true));
    
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    final updatedMap = Map<Student, BreakfastStatus>.from(state.studentsStatus);
    updatedMap[event.student] = BreakfastStatus.approved;

    emit(state.copyWith(
      studentsStatus: updatedMap,
      currentStep: BreakfastScreenStep.list,
      isSubmitting: false,
    ));
  }

  FutureOr<void> _onStudentCardPressed(
      StudentCardPressed event, Emitter<BreakfastTrackingState> emit) {
    final status = state.studentsStatus[event.student];
    if (status != BreakfastStatus.cancelled) {
      if (status == BreakfastStatus.notRegistered) {
        emit(state.copyWith(
          selectedStudentForRegister: event.student,
          currentStep: BreakfastScreenStep.register,
          termsAgreed: false,
        ));
      } else if (status == BreakfastStatus.pending || status == BreakfastStatus.approved) {
        emit(state.copyWith(
          selectedStudentForRegister: event.student,
          currentStep: BreakfastScreenStep.cancelDetails,
        ));
      } else {
        emit(state.copyWith(
          selectedStudentForRegister: event.student,
          currentStep: BreakfastScreenStep.details,
        ));
      }
    }
  }

  FutureOr<void> _onCancelServicePressed(
      CancelServicePressed event, Emitter<BreakfastTrackingState> emit) {
    emit(state.copyWith(
      currentStep: BreakfastScreenStep.cancelReason,
      cancelReason: '',
    ));
  }

  FutureOr<void> _onWithdrawCancellation(
      WithdrawCancellation event, Emitter<BreakfastTrackingState> emit) async {
    emit(state.copyWith(isSubmitting: true));

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    final updatedMap = Map<Student, BreakfastStatus>.from(state.studentsStatus);
    updatedMap.remove(event.student);

    emit(state.copyWith(
      studentsStatus: updatedMap,
      currentStep: BreakfastScreenStep.list,
      isSubmitting: false,
    ));
  }
}
