import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain.dart';

part 'add_leave_request_use_case.freezed.dart';

@Injectable()
class AddLeaveRequestUseCase extends BaseFutureUseCase<AddLeaveRequestInput, AddLeaveRequestOutput> {
  const AddLeaveRequestUseCase(this._repository);

  final Repository _repository;

  @protected
  @override
  Future<AddLeaveRequestOutput> buildUseCase(AddLeaveRequestInput input) async {
    await _repository.addLeaveRequest(input.request);
    return const AddLeaveRequestOutput();
  }
}

@freezed
class AddLeaveRequestInput extends BaseInput with _$AddLeaveRequestInput {
  const factory AddLeaveRequestInput({required LeaveRequest request}) = _AddLeaveRequestInput;
}

@freezed
class AddLeaveRequestOutput extends BaseOutput with _$AddLeaveRequestOutput {
  const factory AddLeaveRequestOutput() = _AddLeaveRequestOutput;
}
