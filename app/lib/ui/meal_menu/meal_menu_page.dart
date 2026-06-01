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
    return CommonScaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: const Color(0xFFF5F5F5),
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
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
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
    return Padding(
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thực đơn',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: Dimens.d4.responsive()),
          Text(
            'Tiểu học',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: Dimens.d2.responsive()),
          Divider(color: Colors.grey[300], thickness: 3),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    String getWeekdayString(int weekday) {
      switch (weekday) {
        case 1:
          return 'T2';
        case 2:
          return 'T3';
        case 3:
          return 'T4';
        case 4:
          return 'T5';
        case 5:
          return 'T6';
        case 6:
          return 'T7';
        case 7:
          return 'CN';
        default:
          return '';
      }
    }

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
            child: AnimatedBuilder(
              animation: _tabController.animation!,
              builder: (context, _) {
                final animationValue = _tabController.animation!.value;
                final distance = (animationValue - index).abs();
                final t = (1 - distance).clamp(0.0, 1.0);

                final bgColor = Color.lerp(Colors.white, Colors.black87, t)!;
                final borderColor =
                    Color.lerp(Colors.grey[300], Colors.black87, t)!;
                final weekdayColor =
                    Color.lerp(Colors.grey[600], Colors.white70, t)!;
                final dateColor = Color.lerp(Colors.black87, Colors.white, t)!;

                return Container(
                  width: 65,
                  margin:
                      EdgeInsets.symmetric(horizontal: Dimens.d4.responsive()),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: borderColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getWeekdayString(date.weekday),
                        style: TextStyle(
                          fontSize: 14,
                          color: weekdayColor,
                        ),
                      ),
                      SizedBox(height: Dimens.d4.responsive()),
                      Text(
                        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: dateColor,
                        ),
                      ),
                    ],
                  ),
                );
              },
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
    IconData getIconForType(MealType type) {
      switch (type) {
        case MealType.breakfast:
          return Icons.bakery_dining;
        case MealType.lunch:
          return Icons.ramen_dining;
        case MealType.dinner:
          return Icons.restaurant;
        case MealType.snack:
          return Icons.local_cafe;
        default:
          return Icons.restaurant;
      }
    }

    final icon = getIconForType(type);
    return Container(
      margin: EdgeInsets.only(bottom: Dimens.d16.responsive()),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.black87, size: 24),
              ),
              SizedBox(width: Dimens.d12.responsive()),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  calories,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1),
          _buildFoodItem('Món chính', mainDish),
          _buildFoodItem('Ăn kèm/Tráng miệng', sideDish),
        ],
      ),
    );
  }

  Widget _buildFoodItem(String label, String value) {
    final foodItems = value
        .split(RegExp(r'[,+&]|\n| và '))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Container(
      margin: EdgeInsets.only(bottom: Dimens.d12.responsive()),
      padding: EdgeInsets.all(Dimens.d16.responsive()),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: Dimens.d12.responsive()),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: foodItems.map((item) => _buildFoodChip(item)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodChip(String name) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.d16.responsive(),
        vertical: Dimens.d8.responsive(),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
