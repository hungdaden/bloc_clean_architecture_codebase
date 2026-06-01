import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/domain.dart';

import '../../../app.dart';
import 'meal_menu.dart';

@Injectable()
class MealMenuBloc extends BaseBloc<MealMenuEvent, MealMenuState> {
  MealMenuBloc(this._getMealsUseCase) : super(MealMenuState()) {
    on<MealMenuPageInitiated>(
      _onMealMenuPageInitiated,
      transformer: log(),
    );
  }

  final GetMealsUseCase _getMealsUseCase;

  FutureOr<void> _onMealMenuPageInitiated(
      MealMenuPageInitiated event, Emitter<MealMenuState> emit) async {
    return runBlocCatching(
        handleLoading: false,
        action: () async {
          final output = await _getMealsUseCase.execute(const GetMealsInput());

          emit(state.copyWith(
            meals: output.meals,
          ));
        },
        doOnSubscribe: () async {
          emit(state.copyWith(isShimmerLoading: true));
          
        },
        doOnSuccessOrError: () async{
          emit(state.copyWith(isShimmerLoading: false));
        },
        );
  }
}

