import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/domain.dart';

import '../../../app.dart';
import 'admin_meal.dart';

@Injectable()
class AdminMealBloc extends BaseBloc<AdminMealEvent, AdminMealState> {
  AdminMealBloc(
    this._getMealsUseCase,
    this._addMealUseCase,
    this._updateMealUseCase,
    this._deleteMealUseCase,
  ) : super(AdminMealState()) {
    on<AdminMealPageInitiated>(
      _onPageInitiated,
      transformer: log(),
    );
    on<AdminMealAdded>(
      _onMealAdded,
      transformer: log(),
    );
    on<AdminMealUpdated>(
      _onMealUpdated,
      transformer: log(),
    );
    on<AdminMealDeleted>(
      _onMealDeleted,
      transformer: log(),
    );
  }

  final GetMealsUseCase _getMealsUseCase;
  final AddMealUseCase _addMealUseCase;
  final UpdateMealUseCase _updateMealUseCase;
  final DeleteMealUseCase _deleteMealUseCase;

  FutureOr<void> _onPageInitiated(
      AdminMealPageInitiated event, Emitter<AdminMealState> emit) async {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        final output = await _getMealsUseCase.execute(const GetMealsInput());
        emit(state.copyWith(meals: output.meals));
      },
      doOnSubscribe: () async {
        emit(state.copyWith(isShimmerLoading: true));
      },
      doOnSuccessOrError: () async {
        emit(state.copyWith(isShimmerLoading: false));
      },
    );
  }

  FutureOr<void> _onMealAdded(
      AdminMealAdded event, Emitter<AdminMealState> emit) async {
    return runBlocCatching(
      action: () async {
        await _addMealUseCase.execute(AddMealInput(meal: event.meal));
        final output = await _getMealsUseCase.execute(const GetMealsInput());
        emit(state.copyWith(meals: output.meals));
      },
    );
  }

  FutureOr<void> _onMealUpdated(
      AdminMealUpdated event, Emitter<AdminMealState> emit) async {
    return runBlocCatching(
      action: () async {
        await _updateMealUseCase.execute(UpdateMealInput(meal: event.newMeal));
        final output = await _getMealsUseCase.execute(const GetMealsInput());
        emit(state.copyWith(meals: output.meals));
      },
    );
  }

  FutureOr<void> _onMealDeleted(
      AdminMealDeleted event, Emitter<AdminMealState> emit) async {
    return runBlocCatching(
      action: () async {
        await _deleteMealUseCase.execute(DeleteMealInput(meal: event.meal));
        final output = await _getMealsUseCase.execute(const GetMealsInput());
        emit(state.copyWith(meals: output.meals));
      },
    );
  }
}
