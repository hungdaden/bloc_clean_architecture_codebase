import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../app.dart';

@LazySingleton(as: BaseRouteInfoMapper)
class AppRouteInfoMapper extends BaseRouteInfoMapper {
  @override
  PageRouteInfo map(AppRouteInfo appRouteInfo) {
    return appRouteInfo.when(
      mealMenu: () => const MealMenuRoute(),
      adminMealManagement: () => const AdminMealRoute(),
      commentList: () => const CommentListRoute(),
      commentDetail: (comment) => CommentDetailRoute(comment: comment),
      studentList: () => const StudentListRoute(),
      leaveList: () => const LeaveListRoute(),
      leaveRegistration: () => const LeaveRegistrationRoute(),
    );
  }
}

