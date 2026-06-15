import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../data.dart';

@Injectable()
class StudentDataMapper extends BaseDataMapper<StudentDataModel, Student> with DataMapperMixin {
  @override
  Student mapToEntity(StudentDataModel? data) {
    return Student(
      firstName: data?.firstName ?? '',
      fullName: data?.fullName ?? '',
      avatarUrl: data?.avatarUrl ?? '',
      id: data?.id,
      emoji: data?.emoji,
      sex: data?.sex,
      cityName: data?.cityName,
      birthdate: data?.birthdate,
      rawJson: data?.rawJson,

    );
  }

  @override
  StudentDataModel mapToData(Student entity) {
    return StudentDataModel(
      avatarUrl: entity.avatarUrl,
      id: entity.id,
      fullName: entity.fullName,
      firstName: entity.firstName,
      emoji: entity.emoji,
      sex: entity.sex,
      cityName: entity.cityName,
      birthdate: entity.birthdate,
      rawJson: entity.rawJson,
    );
  }
}
