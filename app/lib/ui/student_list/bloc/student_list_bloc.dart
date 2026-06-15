import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/domain.dart';

import '../../../app.dart';
import 'student_list.dart';

@Injectable()
class StudentListBloc extends BaseBloc<StudentListEvent, StudentListState> {
  StudentListBloc(
    this._getStudentsUseCase,
    this._addStudentUseCase,
    this._deleteStudentUseCase,
    this._updateStudentUseCase,
  ) : super(StudentListState()) {
    on<StudentListPageInitiated>(
      _onStudentListPageInitiated,
      transformer: log(),
    );
    on<StudentListRefreshRequested>(
      _onStudentListRefreshRequested,
      transformer: log(),
    );
    on<StudentListAddPressed>(
      _onStudentListAddPressed,
      transformer: log(),
    );
    on<StudentListEditPressed>(
      _onStudentListEditPressed,
      transformer: log(),
    );
    on<StudentListDeletePressed>(
      _onStudentListDeletePressed,
      transformer: log(),
    );
    on<StudentListSearchKeywordChanged>(
      _onStudentListSearchKeywordChanged,
      transformer: debounceTime(),
    );
    on<StudentListSearchFieldChanged>(
      _onStudentListSearchFieldChanged,
      transformer: log(),
    );
  }

  final GetStudentsUseCase _getStudentsUseCase;
  final AddStudentUseCase _addStudentUseCase;
  final DeleteStudentUseCase _deleteStudentUseCase;
  final UpdateStudentUseCase _updateStudentUseCase;

  FutureOr<void> _onStudentListPageInitiated(
      StudentListPageInitiated event, Emitter<StudentListState> emit) async {
    return _fetchStudents(emit);
  }

  FutureOr<void> _onStudentListRefreshRequested(
      StudentListRefreshRequested event, Emitter<StudentListState> emit) async {
    return _fetchStudents(emit);
  }

  FutureOr<void> _onStudentListAddPressed(
      StudentListAddPressed event, Emitter<StudentListState> emit) async {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        await _addStudentUseCase.execute(AddStudentInput(student: event.student));
        add(const StudentListRefreshRequested());
      },
    );
  }

  FutureOr<void> _onStudentListEditPressed(
      StudentListEditPressed event, Emitter<StudentListState> emit) async {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        await _updateStudentUseCase.execute(UpdateStudentInput(student: event.student));
        add(const StudentListRefreshRequested());
      },
    );
  }

  FutureOr<void> _onStudentListDeletePressed(
      StudentListDeletePressed event, Emitter<StudentListState> emit) async {
    return runBlocCatching(
      handleLoading: true,
      action: () async {
        await _deleteStudentUseCase.execute(DeleteStudentInput(id: event.id));
        add(const StudentListRefreshRequested());
      },
    );
  }

  FutureOr<void> _onStudentListSearchKeywordChanged(
      StudentListSearchKeywordChanged event, Emitter<StudentListState> emit) async {
    emit(state.copyWith(searchKeyword: event.keyword));
    return _fetchStudents(emit);
  }

  FutureOr<void> _onStudentListSearchFieldChanged(
      StudentListSearchFieldChanged event, Emitter<StudentListState> emit) async {
    emit(state.copyWith(searchField: event.field));
    return _fetchStudents(emit);
  }

  Future<void> _fetchStudents(Emitter<StudentListState> emit) async {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        final keyword = state.searchKeyword.trim();
        final field = state.searchField;

        String? sexQuery;
        if (field == 'sex' && keyword.isNotEmpty) {
          final normalized = keyword.toLowerCase();
          if (normalized == 'nam' || normalized == 'male') {
            sexQuery = 'male';
          } else if (normalized == 'nữ' || normalized == 'nu' || normalized == 'female') {
            sexQuery = 'female';
          } else {
            sexQuery = keyword;
          }
        }

        final input = GetStudentsInput(
          search: field == 'search' && keyword.isNotEmpty ? keyword : null,
          name: field == 'name' && keyword.isNotEmpty ? keyword : null,
          fullName: field == 'full_name' && keyword.isNotEmpty ? keyword : null,
          cityName: field == 'city_name' && keyword.isNotEmpty ? keyword : null,
          sex: sexQuery,
        );

        final output = await _getStudentsUseCase.execute(input);
        emit(state.copyWith(
          students: output.students,
        ));
      },
      doOnSubscribe: () async {
        emit(state.copyWith(isShimmerLoading: true));
      },
      doOnSuccessOrError: () async {
        emit(state.copyWith(isShimmerLoading: false));
      },
    );
  }
}
