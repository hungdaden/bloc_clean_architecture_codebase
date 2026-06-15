import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

import '../../data.dart';

@LazySingleton(as: Repository)
class RepositoryImpl implements Repository {
  RepositoryImpl(
    this._appApiService,
    this._appPreferences,
    this._languageCodeDataMapper,
    this._mealDataMapper,
    this._commentDataMapper,
    this._studentDataMapper,
    this._leaveRequestDataMapper,
  );

  final AppApiService _appApiService;
  final AppPreferences _appPreferences;
  final LanguageCodeDataMapper _languageCodeDataMapper;
  final MealDataMapper _mealDataMapper;
  final CommentDataMapper _commentDataMapper;
  final StudentDataMapper _studentDataMapper;
  final LeaveRequestDataMapper _leaveRequestDataMapper;

  /// In-memory storage for meals
  List<MealDataModel>? _mealsCache;

  /// In-memory storage for leave requests
  List<LeaveRequestDataModel>? _leaveRequestsCache;

  List<LeaveRequestDataModel> _getOrCreateLeaveRequestsCache() {
    if (_leaveRequestsCache != null) return _leaveRequestsCache!;

    _leaveRequestsCache = [
      LeaveRequestDataModel(
        id: '1',
        leaveType: 'multipleDays',
        startDate: DateTime(2026, 6, 16).toIso8601String(),
        endDate: DateTime(2026, 6, 18).toIso8601String(),
        reason: 'Con bị ngã chân, khó di chuyển đến trường.',
        status: 'pending',
        createdAt: DateTime(2026, 6, 15, 8, 30).toIso8601String(),
      ),
      LeaveRequestDataModel(
        id: '2',
        leaveType: 'singleDay',
        startDate: DateTime(2026, 5, 20).toIso8601String(),
        endDate: DateTime(2026, 5, 20).toIso8601String(),
        reason: 'Gia đình có việc hiếu, xin cho con nghỉ.',
        status: 'approved',
        createdAt: DateTime(2026, 5, 19, 10, 0).toIso8601String(),
      ),
    ];
    return _leaveRequestsCache!;
  }


  List<MealDataModel> _getOrCreateMealsCache() {
    if (_mealsCache != null) return _mealsCache!;

    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final List<MealDataModel> meals = [];

    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(now.year, now.month, i);

      meals.add(MealDataModel(
        date: date,
        title: 'Bữa sáng',
        type: 0,
        time: '07:00 - 07:30',
        mainDish: i % 2 == 0 ? 'Phở bò' : 'Bánh mì ốp la, xúc xích',
        sideDish: i % 2 == 0 ? 'Trà đá' : 'Sữa tươi',
        calories: i % 2 == 0 ? '500 kcal' : '450 kcal',
      ));

      meals.add(MealDataModel(
        date: date,
        title: 'Bữa trưa',
        type: 1,
        time: '11:00 - 12:00',
        mainDish: i % 3 == 0
            ? 'Cơm rang dưa bò'
            : (i % 2 == 0
                ? 'Cơm gà'
                : 'Cơm trắng, Thịt kho tiêu, Canh rau ngót'),
        sideDish: i % 3 == 0
            ? 'Canh cải'
            : (i % 2 == 0 ? 'Salad' : 'Chuối tráng miệng'),
        calories: '650 kcal',
      ));

      if (i % 4 != 0) {
        meals.add(MealDataModel(
          date: date,
          title: 'Bữa chiều',
          type: 2,
          time: '14:30 - 15:00',
          mainDish: 'Sữa chua',
          sideDish: 'Bánh quy',
          calories: '200 kcal',
        ));
      } else {
        meals.add(MealDataModel(
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

    _mealsCache = meals;
    return _mealsCache!;
  }

  @override
  bool get isFirstLaunchApp => _appPreferences.isFirstLaunchApp;

  @override
  Stream<bool> get onConnectivityChanged => Connectivity()
      .onConnectivityChanged
      .map((event) => event != ConnectivityResult.none);

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
    return _appPreferences
        .saveLanguageCode(_languageCodeDataMapper.mapToData(languageCode));
  }

  @override
  Future<bool> saveIsDarkMode(bool isDarkMode) =>
      _appPreferences.saveIsDarkMode(isDarkMode);

  @override
  Future<List<Meal>> getMeals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mealDataMapper.mapToListEntity(_getOrCreateMealsCache());
  }

  @override
  Future<void> addMeal(Meal meal) async {
    final dataModel = _mealDataMapper.mapToData(meal);
    _getOrCreateMealsCache().add(dataModel);
  }

  @override
  Future<void> updateMeal(Meal meal) async {
    final cache = _getOrCreateMealsCache();
    final index = cache.indexWhere((m) =>
        m.date?.year == meal.date?.year &&
        m.date?.month == meal.date?.month &&
        m.date?.day == meal.date?.day &&
        m.title == meal.title);
    if (index != -1) {
      cache[index] = _mealDataMapper.mapToData(meal);
    }
  }

  @override
  Future<void> deleteMeal(Meal meal) async {
    final cache = _getOrCreateMealsCache();
    cache.removeWhere((m) =>
        m.date?.year == meal.date?.year &&
        m.date?.month == meal.date?.month &&
        m.date?.day == meal.date?.day &&
        m.title == meal.title &&
        m.type == meal.type.serverValue);
  }

  @override
  Future<List<Comment>> getComments() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final mockList = [
      CommentDataModel(
        id: '1',
        date: DateTime(2026, 10, 15, 9, 0),
        title: 'Nhận xét tình hình học tập T10/2026',
        numberOfSubjects: 10,
        isNew: true,
        content:
            'Học sinh Hoàng Quang Hưng tiếp thu bài tốt, hăng hái phát biểu xây dựng bài trong các tiết học.',
      ),
      CommentDataModel(
        id: '2',
        date: DateTime(2026, 9, 15, 9, 0),
        title: 'Nhận xét tình hình học tập T9/2026',
        numberOfSubjects: 10,
        isNew: false,
        content:
            'Học sinh ngoan, chú ý nghe giảng. Cần tập trung hơn ở môn Toán.',
      ),
      CommentDataModel(
        id: '3',
        date: DateTime(2026, 8, 15, 9, 0),
        title: 'Nhận xét tình hình học tập T8/2026',
        numberOfSubjects: 10,
        isNew: false,
        content: 'Hoàn thành tốt các nhiệm vụ học tập đầu năm học.',
      ),
    ];
    return _commentDataMapper.mapToListEntity(mockList);
  }

  @override
  Future<List<SubjectComment>> getSubjectComments(String commentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      SubjectComment(
        subjectName: 'Toán học',
        date: DateTime(2026, 8, 15, 9, 0),
        content:
            'Điểm khảo sát đầu năm học của con là: 7.0.\nKiến thức đọc hiểu thể loại của con tương đối tốt. Con cần chú ý hơn trong cách diễn đạt khi trả lời những câu hỏi ngắn.\nChú ý viết câu gọn và rõ về nghĩa. Dạng bài nghị luận về một tác phẩm truyện của con còn sa đà vào việc kể lại nội dung.\nCon cần chú ý sử dụng các thao tác lập luận, phân tích, đánh giá, so sánh để làm sáng tỏ vấn đề.\nCon chịu khó đọc thêm sách tham khảo để học cách viết văn sâu và sắc vấn đề hơn nhé.',
        teacherName: 'Nguyễn Thuỳ Linh',
        teacherAvatarUrl: '',
        teacherTitle: 'Giáo viên bộ môn',
      ),
      SubjectComment(
        subjectName: 'Ngữ Văn',
        date: DateTime(2026, 8, 15, 9, 0),
        content:
            'Con có tinh thần tự giác học tập tốt. Khả năng cảm thụ văn học khá. Cần phát huy thế mạnh viết các bài văn nghị luận xã hội.',
        teacherName: 'Phạm Minh Đức',
        teacherAvatarUrl: '',
        teacherTitle: 'Giáo viên bộ môn',
      ),
      SubjectComment(
        subjectName: 'Tiếng Anh',
        date: DateTime(2026, 8, 15, 9, 0),
        content:
            'Kỹ năng nghe nói của con rất tốt, phản xạ nhanh nhạy. Con cần rèn luyện thêm phần ngữ pháp nâng cao để đạt điểm số tối ưu.',
        teacherName: 'Trần Thị Thuỷ',
        teacherAvatarUrl: '',
        teacherTitle: 'Giáo viên bộ môn',
      ),
      SubjectComment(
        subjectName: 'Vật lý',
        date: DateTime(2026, 8, 15, 9, 0),
        content:
            'Con tiếp thu tốt các định luật Vật lý và công thức tính nhanh. Đôi lúc còn tính toán nhầm lẫn do chủ quan, cần cẩn thận hơn.',
        teacherName: 'Hoàng Văn Nam',
        teacherAvatarUrl: '',
        teacherTitle: 'Giáo viên bộ môn',
      ),
      SubjectComment(
        subjectName: 'Hóa Học',
        date: DateTime(2026, 8, 15, 9, 0),
        content:
            'Con tiếp thu tốt các định luật Vật lý và công thức tính nhanh. Đôi lúc còn tính toán nhầm lẫn do chủ quan, cần cẩn thận hơn.',
        teacherName: 'Hoàng Văn Nam',
        teacherAvatarUrl: '',
        teacherTitle: 'Giáo viên bộ môn',
      ),
    ];
  }

  @override
  Future<Student> getStudentInfo() async {
    await Future.delayed(const Duration(milliseconds: 300));
    const mockStudent = StudentDataModel(
      firstName: 'Hưng',
      fullName: 'Hoàng Quang Hưng',
      avatarUrl:
          'https://th.bing.com/th/id/OIP.TP90O5IlYW3CMzpj1BUONQHaJP?r=0&o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3',
    );
    return _studentDataMapper.mapToEntity(mockStudent);
  }

  @override
  Future<List<Student>> getStudents({
    String? search,
    String? name,
    String? fullName,
    String? cityName,
    String? sex,
  }) async {
    try {
      final response = await _appApiService.getStudents();
      var students = _studentDataMapper.mapToListEntity(response);

      if (search != null && search.trim().isNotEmpty) {
        final query = search.trim().toLowerCase();
        students = students.where((s) {
          final sFirstName = s.firstName.toLowerCase();
          final sFullName = s.fullName.toLowerCase();
          final sCityName = s.cityName?.toLowerCase() ?? '';
          final sSex = (s.sex ?? '').toLowerCase();

          final matchGender = (query == 'nam' && sSex == 'male') ||
              (query == 'nữ' && sSex == 'female') ||
              (query == 'nu' && sSex == 'female');

          return sFirstName.contains(query) ||
              sFullName.contains(query) ||
              sCityName.contains(query) ||
              sSex.contains(query) ||
              matchGender;
        }).toList();
      }

      if (name != null && name.trim().isNotEmpty) {
        final query = name.trim().toLowerCase();
        students = students.where((s) => s.firstName.toLowerCase().contains(query) || s.fullName.toLowerCase().contains(query)).toList();
      }

      if (fullName != null && fullName.trim().isNotEmpty) {
        final query = fullName.trim().toLowerCase();
        students = students.where((s) => s.fullName.toLowerCase().contains(query)).toList();
      }

      if (cityName != null && cityName.trim().isNotEmpty) {
        final query = cityName.trim().toLowerCase();
        students = students.where((s) => (s.cityName?.toLowerCase() ?? '').contains(query)).toList();
      }

      if (sex != null && sex.trim().isNotEmpty) {
        final query = sex.trim().toLowerCase();
        students = students.where((s) => (s.sex ?? '').toLowerCase() == query).toList();
      }

      return students;
    } on RemoteException catch (e) {
      if (e.httpErrorCode == 404) {
        return [];
      }
      rethrow;
    }
  }

  @override
  Future<Student> addStudent(Student student) async {
    final dataModel = _studentDataMapper.mapToData(student);
    final json = <String, dynamic>{
      ...dataModel.toJson(),
      if (student.rawJson != null) ...student.rawJson!,
    };
    final response = await _appApiService.addStudent(json);
    return _studentDataMapper.mapToEntity(response);
  }

  @override
  Future<Student> updateStudent(Student student) async {
    final dataModel = _studentDataMapper.mapToData(student);
    final json = <String, dynamic>{
      ...dataModel.toJson(),
      if (student.rawJson != null) ...student.rawJson!,
    };
    final response = await _appApiService.updateStudent(student.id ?? '', json);
    return _studentDataMapper.mapToEntity(response);
  }

  @override
  Future<void> deleteStudent(String id) async {
    await _appApiService.deleteStudent(id);
  }

  @override
  Future<List<LeaveRequest>> getLeaveRequests() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final cache = _getOrCreateLeaveRequestsCache();
    final sortedCache = List<LeaveRequestDataModel>.from(cache)
      ..sort((a, b) {
        final aTime = DateTime.tryParse(a.createdAt ?? '') ?? DateTime.now();
        final bTime = DateTime.tryParse(b.createdAt ?? '') ?? DateTime.now();
        return bTime.compareTo(aTime);
      });
    return _leaveRequestDataMapper.mapToListEntity(sortedCache);
  }

  @override
  Future<void> addLeaveRequest(LeaveRequest request) async {
    final cache = _getOrCreateLeaveRequestsCache();
    final dataModel = _leaveRequestDataMapper.mapToData(request);
    final finalModel = dataModel.copyWith(id: (cache.length + 1).toString());
    cache.add(finalModel);
  }
}

