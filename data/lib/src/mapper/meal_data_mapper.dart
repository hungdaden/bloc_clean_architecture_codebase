import 'package:dartx/dartx.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../../../data.dart';
import '../model/meal_data_model.dart';

@Injectable()
class MealDataMapper extends BaseDataMapper<MealDataModel, Meal> with DataMapperMixin {
  @override
  Meal mapToEntity(MealDataModel? data) {
    return Meal(
      date: data?.date,
      title: data?.title ?? '',
      type: MealType.values.firstOrNullWhere((element) => element.serverValue == data?.type) ?? MealType.defaultValue,
      time: data?.time ?? '',
      mainDish: data?.mainDish ?? '',
      sideDish: data?.sideDish ?? '',
      calories: data?.calories ?? '',
    );
  }

  @override
  MealDataModel mapToData(Meal entity) {
    return MealDataModel(
      date: entity.date,
      title: entity.title,
      type: entity.type.serverValue,
      time: entity.time,
      mainDish: entity.mainDish,
      sideDish: entity.sideDish,
      calories: entity.calories,
    );
  }
}

