import 'package:injectable/injectable.dart';

import '../../../../data.dart';

@LazySingleton()
class AppApiService {
  AppApiService(
    this._noneAuthAppServerApiClient,
    this._authAppServerApiClient,
    this._randomUserApiClient,
    this._studentApiClient,
  );
  
  final NoneAuthAppServerApiClient _noneAuthAppServerApiClient;
  final AuthAppServerApiClient _authAppServerApiClient;
  final RandomUserApiClient _randomUserApiClient;
  final StudentApiClient _studentApiClient;

  Future<List<StudentDataModel>?> getStudents({Map<String, dynamic>? queryParameters}) async {
    return _studentApiClient.request<StudentDataModel, List<StudentDataModel>>(
      method: RestMethod.get,
      path: '/student',
      queryParameters: queryParameters,
      decoder: (json) {
        final map = json as Map<String, dynamic>;
        return StudentDataModel.fromJson(map).copyWith(rawJson: map);
      },
      successResponseMapperType: SuccessResponseMapperType.jsonArray,
    );
  }

  Future<StudentDataModel?> addStudent(Map<String, dynamic> json) async {
    return _studentApiClient.request<StudentDataModel, StudentDataModel>(
      method: RestMethod.post,
      path: '/student',
      body: json,
      decoder: (responseJson) {
        final map = responseJson as Map<String, dynamic>;
        return StudentDataModel.fromJson(map).copyWith(rawJson: map);
      },
      successResponseMapperType: SuccessResponseMapperType.jsonObject,
    );
  }

  Future<StudentDataModel?> updateStudent(String id, Map<String, dynamic> json) async {
    return _studentApiClient.request<StudentDataModel, StudentDataModel>(
      method: RestMethod.put,
      path: '/student/$id',
      body: json,
      decoder: (responseJson) {
        final map = responseJson as Map<String, dynamic>;
        return StudentDataModel.fromJson(map).copyWith(rawJson: map);
      },
      successResponseMapperType: SuccessResponseMapperType.jsonObject,
    );
  }

  Future<void> deleteStudent(String id) async {
    await _studentApiClient.request<Map<String, dynamic>, Map<String, dynamic>>(
      method: RestMethod.delete,
      path: '/student/$id',
      successResponseMapperType: SuccessResponseMapperType.jsonObject,
      decoder: (json) => json as Map<String, dynamic>,
    );
  }
}
