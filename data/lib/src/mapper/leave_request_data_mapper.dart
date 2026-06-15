import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../data.dart';

@Injectable()
class LeaveRequestDataMapper extends BaseDataMapper<LeaveRequestDataModel, LeaveRequest> with DataMapperMixin {
  @override
  LeaveRequest mapToEntity(LeaveRequestDataModel? data) {
    return LeaveRequest(
      id: data?.id,
      leaveType: _parseLeaveType(data?.leaveType),
      startDate: DateTime.tryParse(data?.startDate ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(data?.endDate ?? '') ?? DateTime.now(),
      reason: data?.reason ?? '',
      status: _parseLeaveStatus(data?.status),
      createdAt: DateTime.tryParse(data?.createdAt ?? '') ?? DateTime.now(),
    );
  }

  @override
  LeaveRequestDataModel mapToData(LeaveRequest entity) {
    return LeaveRequestDataModel(
      id: entity.id,
      leaveType: entity.leaveType.name,
      startDate: entity.startDate.toIso8601String(),
      endDate: entity.endDate.toIso8601String(),
      reason: entity.reason,
      status: entity.status.name,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }

  LeaveType _parseLeaveType(String? val) {
    if (val == null) return LeaveType.singleDay;
    switch (val) {
      case 'multipleDays':
      case 'Nghỉ nhiều ngày':
        return LeaveType.multipleDays;
      case 'halfDay':
      case 'Nghỉ nửa ngày':
        return LeaveType.halfDay;
      case 'singleDay':
      case 'Nghỉ một ngày':
      default:
        return LeaveType.singleDay;
    }
  }

  LeaveStatus _parseLeaveStatus(String? val) {
    if (val == null) return LeaveStatus.pending;
    switch (val) {
      case 'approved':
      case 'Đã duyệt':
        return LeaveStatus.approved;
      case 'rejected':
      case 'Từ chối':
        return LeaveStatus.rejected;
      case 'pending':
      case 'Chờ duyệt':
      default:
        return LeaveStatus.pending;
    }
  }
}
