import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import 'bloc/meal_menu.dart';

@RoutePage()
class MealMenuPage extends StatefulWidget {
  const MealMenuPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MealMenuPageState();
  }
}

class _MealMenuPageState extends BasePageState<MealMenuPage, MealMenuBloc>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _todayIndex = 0;
  List<DateTime> _monthDates = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    _todayIndex = now.day - 1;
    _monthDates = List.generate(
        daysInMonth, (index) => DateTime(now.year, now.month, index + 1));

    _tabController = TabController(
        length: daysInMonth, vsync: this, initialIndex: _todayIndex);

    bloc.add(const MealMenuPageInitiated());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    return CommonScaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: theme.scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  _buildDateSelector(),
                  Expanded(
                    child: BlocBuilder<MealMenuBloc, MealMenuState>(
                      builder: (context, state) {
                        if (state.isShimmerLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (state.meals.isEmpty) {
                          return const Center(child: Text('Không có thực đơn'));
                        }

                        return TabBarView(
                          controller: _tabController,
                          children: List.generate(_monthDates.length, (index) {
                            final date = _monthDates[index];
                            final mealsForDate = state.meals
                                .where((meal) =>
                                    meal.date != null &&
                                    meal.date!.year == date.year &&
                                    meal.date!.month == date.month &&
                                    meal.date!.day == date.day)
                                .toList();

                            if (mealsForDate.isEmpty) {
                              return const Center(
                                  child: Text('Không có thực đơn'));
                            }

                            return SingleChildScrollView(
                              padding: EdgeInsets.all(Dimens.d16.responsive()),
                              child: Column(
                                children: mealsForDate.map((meal) {
                                  return _buildMealCard(
                                    title: meal.title,
                                    type: meal.type,
                                    time: meal.time,
                                    mainDish: meal.mainDish,
                                    sideDish: meal.sideDish,
                                    calories: meal.calories,
                                  );
                                }).toList(),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _tabController,
              builder: (context, _) {
                if (_tabController.index == _todayIndex) {
                  return const SizedBox.shrink();
                }
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: Dimens.d24.responsive()),
                    child: ElevatedButton(
                      onPressed: () {
                        _tabController.animateTo(_todayIndex);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.cardColor,
                        foregroundColor: colors.primaryTextColor,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimens.d24.responsive(),
                          vertical: Dimens.d12.responsive(),
                        ),
                      ),
                      child: const Text(
                        'Hôm nay',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    final colors = theme.colors;

    return Padding(
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thực đơn',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryTextColor,
                  ),
                ),
                SizedBox(height: Dimens.d4.responsive()),
                Text(
                  'Tiểu học',
                  style: TextStyle(
                    fontSize: 16,
                    color: colors.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              await navigator.push(const AppRouteInfo.studentList());
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Icon(Icons.people, color: colors.primaryTextColor, size: 24),
            ),
          ),
          InkWell(
            onTap: () async {
              await navigator.push(const AppRouteInfo.commentList());
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Icon(Icons.comment, color: colors.primaryTextColor, size: 24),
            ),
          ),
          SizedBox(width: Dimens.d8.responsive()),
          InkWell(
            onTap: () async {
              await navigator.push(const AppRouteInfo.leaveList());
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Icon(Icons.calendar_month, color: colors.primaryTextColor, size: 24),
            ),
          ),
          SizedBox(width: Dimens.d8.responsive()),
          InkWell(
            onTap: () async {
              await navigator.push(const AppRouteInfo.adminMealManagement());
              bloc.add(const MealMenuPageInitiated());
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Icon(Icons.settings, color: colors.primaryTextColor, size: 24),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDateSelector() {
    return Container(
      height: 80,
      margin: EdgeInsets.symmetric(vertical: Dimens.d8.responsive()),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        dividerColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        labelPadding: EdgeInsets.zero,
        tabAlignment: TabAlignment.start,
        padding: EdgeInsets.symmetric(horizontal: Dimens.d12.responsive()),
        tabs: List.generate(_monthDates.length, (index) {
          final date = _monthDates[index];
          return Tab(
            height: 70,
            child: CalendarTabItem(
              date: date,
              index: index,
              tabController: _tabController,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMealCard({
    required String title,
    required MealType type,
    required String time,
    required String mainDish,
    required String sideDish,
    required String calories,
  }) {
    return MealCard(
      title: title,
      type: type,
      time: time,
      mainDish: mainDish,
      sideDish: sideDish,
      calories: calories,
    );
  }
}
