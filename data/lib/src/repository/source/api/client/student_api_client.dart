import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/shared.dart';

import '../../../../../data.dart';

@LazySingleton()
class StudentApiClient extends RestApiClient {
  StudentApiClient()
      : super(
          dio: DioBuilder.createDio(
            options: BaseOptions(baseUrl: UrlConstants.studentApiBaseUrl),
          ),
        );
}
