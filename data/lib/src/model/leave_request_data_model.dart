import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_request_data_model.freezed.dart';
part 'leave_request_data_model.g.dart';

@freezed
class LeaveRequestDataModel with _$LeaveRequestDataModel {
  const factory LeaveRequestDataModel({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'leave_type') String? leaveType,
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'end_date') String? endDate,
    @JsonKey(name: 'reason') String? reason,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _LeaveRequestDataModel;

  factory LeaveRequestDataModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveRequestDataModelFromJson(json);
}
