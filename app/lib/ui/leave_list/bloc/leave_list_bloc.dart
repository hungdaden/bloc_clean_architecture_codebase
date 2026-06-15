import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/domain.dart';

import '../../../app.dart';
import 'leave_list.dart';

@Injectable()
class LeaveListBloc extends BaseBloc<LeaveListEvent, LeaveListState> {
  LeaveListBloc(
    this._getLeaveRequestsUseCase,
    this._repository,
  ) : super(LeaveListState()) {
    on<LeaveListPageInitiated>(
      _onLeaveListPageInitiated,
      transformer: log(),
    );
    on<LeaveListRefreshRequested>(
      _onLeaveListRefreshRequested,
      transformer: log(),
    );
    on<LeaveListTabChanged>(
      _onLeaveListTabChanged,
      transformer: log(),
    );
  }

  final GetLeaveRequestsUseCase _getLeaveRequestsUseCase;
  final Repository _repository;

  FutureOr<void> _onLeaveListPageInitiated(
      LeaveListPageInitiated event, Emitter<LeaveListState> emit) async {
    return _fetchLeaveRequests(emit);
  }

  FutureOr<void> _onLeaveListRefreshRequested(
      LeaveListRefreshRequested event, Emitter<LeaveListState> emit) async {
    return _fetchLeaveRequests(emit);
  }

  FutureOr<void> _onLeaveListTabChanged(
      LeaveListTabChanged event, Emitter<LeaveListState> emit) {
    emit(state.copyWith(selectedTabIndex: event.index));
  }

  Future<void> _fetchLeaveRequests(Emitter<LeaveListState> emit) async {
    return runBlocCatching(
      handleLoading: false,
      action: () async {
        final student = await _repository.getStudentInfo();
        final output = await _getLeaveRequestsUseCase.execute(const GetLeaveRequestsInput());
        emit(state.copyWith(
          student: student,
          requests: output.requests,
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
