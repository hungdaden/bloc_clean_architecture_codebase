import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
@LazySingleton()
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: MealMenuRoute.page, initial: true),
        AutoRoute(page: AdminMealRoute.page),
        AutoRoute(page: CommentListRoute.page),
        AutoRoute(page: CommentDetailRoute.page),
        AutoRoute(page: StudentListRoute.page),
        AutoRoute(page: LeaveListRoute.page),
        AutoRoute(page: LeaveRegistrationRoute.page),
        AutoRoute(page: BreakfastTrackingRoute.page),
      ];
}

