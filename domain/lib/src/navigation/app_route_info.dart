import 'package:freezed_annotation/freezed_annotation.dart';
import '../entity/comment.dart';

part 'app_route_info.freezed.dart';

/// page
@freezed
class AppRouteInfo with _$AppRouteInfo {
  const factory AppRouteInfo.mealMenu() = _MealMenu;
  const factory AppRouteInfo.adminMealManagement() = _AdminMealManagement;
  const factory AppRouteInfo.commentList() = _CommentList;
  const factory AppRouteInfo.commentDetail({required Comment comment}) = _CommentDetail;
  const factory AppRouteInfo.studentList() = _StudentList;
  const factory AppRouteInfo.leaveList() = _LeaveList;
  const factory AppRouteInfo.leaveRegistration() = _LeaveRegistration;
  const factory AppRouteInfo.breakfastTracking() = _BreakfastTracking;
}

