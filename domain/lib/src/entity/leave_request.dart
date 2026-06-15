import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_request.freezed.dart';

enum LeaveType {
  multipleDays('Nghỉ nhiều ngày'),
  singleDay('Nghỉ một ngày'),
  halfDay('Nghỉ nửa ngày');

  const LeaveType(this.label);
  final String label;
}

enum LeaveStatus {
  pending('Chờ duyệt'),
  approved('Đã duyệt'),
  rejected('Từ chối');

  const LeaveStatus(this.label);
  final String label;
}

@freezed
class LeaveRequest with _$LeaveRequest {
  const factory LeaveRequest({
    String? id,
    required LeaveType leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    required LeaveStatus status,
    required DateTime createdAt,
  }) = _LeaveRequest;
}
