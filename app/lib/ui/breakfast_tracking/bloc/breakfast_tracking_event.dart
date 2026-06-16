import 'package:domain/domain.dart';
import '../../../app.dart';

abstract class BreakfastTrackingEvent extends BaseBlocEvent {
  const BreakfastTrackingEvent();
}

class BreakfastTrackingInitiated extends BreakfastTrackingEvent {
  const BreakfastTrackingInitiated();
}

class RegisterButtonPressed extends BreakfastTrackingEvent {
  const RegisterButtonPressed();
}

class CancelButtonPressed extends BreakfastTrackingEvent {
  const CancelButtonPressed();
}

class StudentSelected extends BreakfastTrackingEvent {
  const StudentSelected(this.student);
  final Student student;
}

class TermsAgreedChanged extends BreakfastTrackingEvent {
  const TermsAgreedChanged(this.agreed);
  final bool agreed;
}

class RegisterSubmitPressed extends BreakfastTrackingEvent {
  const RegisterSubmitPressed();
}

class CancelPendingRequestPressed extends BreakfastTrackingEvent {
  const CancelPendingRequestPressed(this.student);
  final Student student;
}

class CancelReasonChanged extends BreakfastTrackingEvent {
  const CancelReasonChanged(this.reason);
  final String reason;
}

class CancelRegistrationSubmit extends BreakfastTrackingEvent {
  const CancelRegistrationSubmit();
}

class ConfirmCancellation extends BreakfastTrackingEvent {
  const ConfirmCancellation(this.student);
  final Student student;
}

class StudentCardPressed extends BreakfastTrackingEvent {
  const StudentCardPressed(this.student);
  final Student student;
}

class CancelServicePressed extends BreakfastTrackingEvent {
  const CancelServicePressed();
}

class WithdrawCancellation extends BreakfastTrackingEvent {
  const WithdrawCancellation(this.student);
  final Student student;
}

