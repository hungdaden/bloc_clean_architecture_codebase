import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../app.dart';
import 'bloc/admin_meal.dart';

@RoutePage()
class AdminMealPage extends StatefulWidget {
  const AdminMealPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminMealPageState();
  }
}

class _AdminMealPageState extends BasePageState<AdminMealPage, AdminMealBloc>
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

    bloc.add(const AdminMealPageInitiated());
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
                    child: BlocBuilder<AdminMealBloc, AdminMealState>(
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
                              return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Không có thực đơn'),
                                      SizedBox(height: Dimens.d16.responsive()),
                                      _buildAddButton(date),
                                    ],
                                  ),
                                );
                            }

                            return SingleChildScrollView(
                              padding: EdgeInsets.all(Dimens.d16.responsive()),
                              child: Column(
                                children: [
                                  ...mealsForDate.map((meal) {
                                    return _buildMealCard(meal: meal);
                                  }),
                                  SizedBox(height: Dimens.d8.responsive()),
                                  _buildAddButton(date),
                                  SizedBox(height: Dimens.d80.responsive()),
                                ],
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
          InkWell(
            onTap: () => navigator.pop(),
            child: Icon(Icons.arrow_back, color: colors.primaryTextColor),
          ),
          SizedBox(width: Dimens.d12.responsive()),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quản lý thực đơn',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryTextColor,
                  ),
                ),
                SizedBox(height: Dimens.d4.responsive()),
                Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: 16,
                    color: colors.secondaryTextColor,
                  ),
                ),
              ],
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

  Widget _buildAddButton(DateTime date) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showMealDialog(date: date),
        icon: Icon(Icons.add, color: colors.primaryTextColor),
        label: Text(
          'Thêm bữa ăn',
          style: TextStyle(color: colors.primaryTextColor, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.dividerColor, width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: EdgeInsets.symmetric(vertical: Dimens.d12.responsive()),
        ),
      ),
    );
  }

  Widget _buildMealCard({required Meal meal}) {
    return MealCard(
      title: meal.title,
      type: meal.type,
      time: meal.time,
      mainDish: meal.mainDish,
      sideDish: meal.sideDish,
      calories: meal.calories,
      onEdit: () => _showMealDialog(date: meal.date!, meal: meal),
      onDelete: () => _showDeleteConfirmation(meal),
    );
  }

  // ─── Dialog ──────────────────────────────────────────────────

  void _showMealDialog({required DateTime date, Meal? meal}) {
    final theme = Theme.of(context);
    final isEdit = meal != null;
    final titleCtrl = TextEditingController(text: meal?.title ?? '');
    final timeCtrl = TextEditingController(text: meal?.time ?? '');
    final mainDishCtrl = TextEditingController(text: meal?.mainDish ?? '');
    final sideDishCtrl = TextEditingController(text: meal?.sideDish ?? '');
    final caloriesCtrl = TextEditingController(text: meal?.calories ?? '');
    MealType selectedType = meal?.type ?? MealType.breakfast;
    DateTime selectedDate = meal?.date ?? date;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(
                isEdit ? 'Sửa bữa ăn' : 'Thêm bữa ăn mới',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Date picker
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate: selectedDate,
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setDialogState(() => selectedDate = picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Ngày',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(selectedDate),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Meal type dropdown
                    DropdownButtonFormField<MealType>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Loại bữa',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: MealType.breakfast, child: Text('Bữa sáng')),
                        DropdownMenuItem(
                            value: MealType.lunch, child: Text('Bữa trưa')),
                        DropdownMenuItem(
                            value: MealType.snack, child: Text('Bữa chiều')),
                        DropdownMenuItem(
                            value: MealType.dinner, child: Text('Bữa tối')),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() {
                            selectedType = v;
                            switch (v) {
                              case MealType.breakfast:
                                titleCtrl.text = 'Bữa sáng';
                                break;
                              case MealType.lunch:
                                titleCtrl.text = 'Bữa trưa';
                                break;
                              case MealType.snack:
                                titleCtrl.text = 'Bữa chiều';
                                break;
                              case MealType.dinner:
                                titleCtrl.text = 'Bữa tối';
                                break;
                              default:
                                break;
                            }
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Tên bữa',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: timeCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Giờ (vd: 07:00 - 07:30)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: mainDishCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Món chính',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: sideDishCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Ăn kèm / Tráng miệng',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: caloriesCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Calories (vd: 500 kcal)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('Huỷ',
                      style: TextStyle(color: theme.colors.secondaryTextColor)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newMeal = Meal(
                      date: selectedDate,
                      title: titleCtrl.text,
                      type: selectedType,
                      time: timeCtrl.text,
                      mainDish: mainDishCtrl.text,
                      sideDish: sideDishCtrl.text,
                      calories: caloriesCtrl.text,
                    );

                    if (isEdit) {
                      bloc.add(AdminMealUpdated(
                          oldMeal: meal, newMeal: newMeal));
                    } else {
                      bloc.add(AdminMealAdded(meal: newMeal));
                    }

                    Navigator.of(ctx).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(isEdit ? 'Cập nhật' : 'Thêm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(Meal meal) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Xác nhận xoá',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
              'Bạn có chắc chắn muốn xoá "${meal.title}" ngày ${meal.date != null ? DateFormat('dd/MM/yyyy').format(meal.date!) : ''}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Huỷ', style: TextStyle(color: theme.colors.secondaryTextColor)),
            ),
            ElevatedButton(
              onPressed: () {
                bloc.add(AdminMealDeleted(meal: meal));
                Navigator.of(ctx).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Xoá'),
            ),
          ],
        );
      },
    );
  }
}
