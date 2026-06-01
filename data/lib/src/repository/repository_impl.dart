import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../data.dart';

@LazySingleton(as: Repository)
class RepositoryImpl implements Repository {
  RepositoryImpl(
    this._appApiService,
    this._appPreferences,
    this._languageCodeDataMapper,
    this._mealDataMapper,
  );

  final AppApiService _appApiService;
  final AppPreferences _appPreferences;
  final LanguageCodeDataMapper _languageCodeDataMapper;
  final MealDataMapper _mealDataMapper;

  @override
  bool get isFirstLaunchApp => _appPreferences.isFirstLaunchApp;

  @override
  Stream<bool> get onConnectivityChanged =>
      Connectivity().onConnectivityChanged.map((event) => event != ConnectivityResult.none);

  @override
  bool get isDarkMode => _appPreferences.isDarkMode;

  @override
  LanguageCode get languageCode =>
      _languageCodeDataMapper.mapToEntity(_appPreferences.languageCode);

  @override
  Future<bool> saveIsFirstLaunchApp(bool isFirstLaunchApp) {
    return _appPreferences.saveIsFirsLaunchApp(isFirstLaunchApp);
  }

  @override
  Future<bool> saveLanguageCode(LanguageCode languageCode) {
    return _appPreferences.saveLanguageCode(_languageCodeDataMapper.mapToData(languageCode));
  }

  @override
  Future<bool> saveIsDarkMode(bool isDarkMode) => _appPreferences.saveIsDarkMode(isDarkMode);

  @override
  Future<List<Meal>> getMeals() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    
    final List<MealDataModel> mockMeals = [];

    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(now.year, now.month, i);
      
      mockMeals.add(MealDataModel(
        date: date,
        title: 'Bữa sáng',
        type: 0,
        time: '07:00 - 07:30',
        mainDish: i % 2 == 0 ? 'Phở bò' : 'Bánh mì ốp la, xúc xích',
        sideDish: i % 2 == 0 ? 'Trà đá' : 'Sữa tươi',
        calories: i % 2 == 0 ? '500 kcal' : '450 kcal',
      ));
      
      mockMeals.add(MealDataModel(
        date: date,
        title: 'Bữa trưa',
        type: 1,
        time: '11:00 - 12:00',
        mainDish: i % 3 == 0 ? 'Cơm rang dưa bò' : (i % 2 == 0 ? 'Cơm gà' : 'Cơm trắng, Thịt kho tiêu, Canh rau ngót'),
        sideDish: i % 3 == 0 ? 'Canh cải' : (i % 2 == 0 ? 'Salad' : 'Chuối tráng miệng'),
        calories: '650 kcal',
      ));
      
      if (i % 4 != 0) {
        mockMeals.add(MealDataModel(
          date: date,
          title: 'Bữa chiều',
          type: 2,
          time: '14:30 - 15:00',
          mainDish: 'Sữa chua',
          sideDish: 'Bánh quy',
          calories: '200 kcal',
        ));
      } else {
        mockMeals.add(MealDataModel(
          date: date,
          title: 'Bữa tối',
          type: 3,
          time: '18:00 - 19:00',
          mainDish: 'Thịt bò bít tết',
          sideDish: 'Khoai tây chiên',
          calories: '800 kcal',
        ));
      }
    }

    return _mealDataMapper.mapToListEntity(mockMeals);
  }
}
