import '../../domain.dart';

abstract class Repository {
  bool get isFirstLaunchApp;

  bool get isDarkMode;

  LanguageCode get languageCode;

  Stream<bool> get onConnectivityChanged;

  Future<bool> saveIsFirstLaunchApp(bool isFirstLaunchApp);

  Future<bool> saveIsDarkMode(bool isDarkMode);

  Future<bool> saveLanguageCode(LanguageCode languageCode);

  Future<List<Meal>> getMeals();

  Future<void> addMeal(Meal meal);

  Future<void> updateMeal(Meal meal);

  Future<void> deleteMeal(Meal meal);

  Future<List<Comment>> getComments();

  Future<List<SubjectComment>> getSubjectComments(String commentId);

  Future<Student> getStudentInfo();

  Future<List<Student>> getStudents({
    String? search,
    String? name,
    String? fullName,
    String? cityName,
    String? sex,
  });

  Future<Student> addStudent(Student student);

  Future<Student> updateStudent(Student student);

  Future<void> deleteStudent(String id);

  Future<List<LeaveRequest>> getLeaveRequests();

  Future<void> addLeaveRequest(LeaveRequest request);
}

