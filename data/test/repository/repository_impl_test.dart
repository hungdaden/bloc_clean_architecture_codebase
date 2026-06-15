import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppApiService extends Mock implements AppApiService {}

class MockAppPreferences extends Mock implements AppPreferences {}

class MockLanguageCodeDataMapper extends Mock implements LanguageCodeDataMapper {}

class MockMealDataMapper extends Mock implements MealDataMapper {}

class MockCommentDataMapper extends Mock implements CommentDataMapper {}

class MockStudentDataMapper extends Mock implements StudentDataMapper {}

class MockLeaveRequestDataMapper extends Mock implements LeaveRequestDataMapper {}

void main() {
  late Repository repository;
  final _mockAppApiService = MockAppApiService();
  final _mockAppPreferences = MockAppPreferences();
  final _mockLanguageCodeDataMapper = MockLanguageCodeDataMapper();
  final _mockMealDataMapper = MockMealDataMapper();
  final _mockCommentDataMapper = MockCommentDataMapper();
  final _mockStudentDataMapper = MockStudentDataMapper();
  final _mockLeaveRequestDataMapper = MockLeaveRequestDataMapper();

  setUp(() {
    repository = RepositoryImpl(
      _mockAppApiService,
      _mockAppPreferences,
      _mockLanguageCodeDataMapper,
      _mockMealDataMapper,
      _mockCommentDataMapper,
      _mockStudentDataMapper,
      _mockLeaveRequestDataMapper,
    );
  });

  group('test repository', () {
    test('dummy test', () {
      expect(repository, isNotNull);
    });
  });
}
