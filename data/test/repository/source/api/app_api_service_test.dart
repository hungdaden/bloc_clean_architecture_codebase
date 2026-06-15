import 'package:data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared/shared.dart';

class MockNoneAuthAppServerApiClient extends Mock implements NoneAuthAppServerApiClient {}

class MockAuthAppServerApiClient extends Mock implements AuthAppServerApiClient {}

class MockRandomUserApiClient extends Mock implements RandomUserApiClient {}

class MockStudentApiClient extends Mock implements StudentApiClient {}

void main() {
  late AppApiService appApiService;
  final _noneAuthAppServerApiClient = MockNoneAuthAppServerApiClient();
  final _authAppServerApiClient = MockAuthAppServerApiClient();
  final _randomUserApiClient = MockRandomUserApiClient();
  final _studentApiClient = MockStudentApiClient();

  setUp(() {
    appApiService = AppApiService(
      _noneAuthAppServerApiClient,
      _authAppServerApiClient,
      _randomUserApiClient,
      _studentApiClient,
    );
  });

  group('test `getStudents` function', () {
    test(
      'should return student list when API responds successfully',
      () async {
        final mockList = [
          const StudentDataModel(
            id: '1',
            fullName: 'Willard Kris',
            avatarUrl: 'https://avatars.githubusercontent.com/u/23852744',
          ),
        ];

        when(
          () => _studentApiClient.request<StudentDataModel, List<StudentDataModel>>(
            method: RestMethod.get,
            path: '/student',
            decoder: any(named: 'decoder', that: isA<Decoder<StudentDataModel>>()),
            successResponseMapperType: SuccessResponseMapperType.jsonArray,
          ),
        ).thenAnswer(
          (_) async => mockList,
        );

        final result = await appApiService.getStudents();

        expect(result, mockList);
      },
    );
  });
}
