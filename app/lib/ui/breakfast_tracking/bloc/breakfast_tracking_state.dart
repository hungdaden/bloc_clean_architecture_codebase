import 'package:domain/domain.dart';
import '../../../app.dart';

enum BreakfastStatus {
  active,
  pending,
  cancelled,
  notRegistered,
  approved,
}

enum BreakfastScreenStep {
  list,
  register,
  details,
  cancelDetails,
  cancelReason,
}

class BreakfastTrackingState extends BaseBlocState {
  const BreakfastTrackingState({
    required this.studentsStatus,
    required this.currentStep,
    this.selectedStudentForRegister,
    this.termsAgreed = false,
    this.cancelReason = '',
    this.isSubmitting = false,
  });

  final Map<Student, BreakfastStatus> studentsStatus;
  final BreakfastScreenStep currentStep;
  final Student? selectedStudentForRegister;
  final bool termsAgreed;
  final String cancelReason;
  final bool isSubmitting;

  BreakfastTrackingState copyWith({
    Map<Student, BreakfastStatus>? studentsStatus,
    BreakfastScreenStep? currentStep,
    Student? selectedStudentForRegister,
    bool? termsAgreed,
    String? cancelReason,
    bool? isSubmitting,
  }) {
    return BreakfastTrackingState(
      studentsStatus: studentsStatus ?? this.studentsStatus,
      currentStep: currentStep ?? this.currentStep,
      selectedStudentForRegister: selectedStudentForRegister ?? this.selectedStudentForRegister,
      termsAgreed: termsAgreed ?? this.termsAgreed,
      cancelReason: cancelReason ?? this.cancelReason,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
