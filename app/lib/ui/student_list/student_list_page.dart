import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import 'bloc/student_list.dart';
import 'component/add_edit_student_dialog.dart';
import 'component/student_search_bar.dart';
import 'component/delete_student_confirmation_dialog.dart';

@RoutePage()
class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StudentListPageState();
  }
}

class _StudentListPageState extends BasePageState<StudentListPage, StudentListBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(const StudentListPageInitiated());
  }

  @override
  Widget buildPage(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final headerHeight = 104.0.responsive();

    return FadedBackgroundPageLayout(
      title: 'Thông tin học sinh',
      onBackPressed: () => navigator.pop(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final student = await showDialog<Student>(
            context: context,
            barrierDismissible: false,
            builder: (context) => const AddEditStudentDialog(),
          );
          if (student != null) {
            bloc.add(StudentListAddPressed(student: student));
          }
        },
        backgroundColor: theme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      child: Column(
        children: [
          SizedBox(height: headerHeight + MediaQuery.of(context).padding.top),
          const StudentSearchBar(),
          Expanded(
            child: BlocBuilder<StudentListBloc, StudentListState>(
              builder: (context, state) {
                if (state.isShimmerLoading && state.students.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.primaryColor,
                    ),
                  );
                }

                return RefreshIndicator(
                  color: theme.primaryColor,
                  onRefresh: () async {
                    final future = bloc.stream.firstWhere((state) => !state.isShimmerLoading);
                    bloc.add(const StudentListRefreshRequested());
                    await future.timeout(
                      const Duration(seconds: 3),
                      onTimeout: () => state,
                    );
                  },
                  child: state.students.isEmpty
                      ? CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverFillRemaining(
                              child: Center(
                                child: Text(
                                  'Không có thông tin học sinh nào',
                                  style: TextStyle(
                                    color: colors.secondaryTextColor,
                                    fontSize: 16.0.responsive(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(
                            left: Dimens.d16.responsive(),
                            right: Dimens.d16.responsive(),
                            bottom: Dimens.d80.responsive(), // Give room for FAB
                            top: Dimens.d16.responsive(),
                          ),
                          itemCount: state.students.length,
                          itemBuilder: (context, index) {
                            final student = state.students[index];
                            return StudentInfoCard(
                              student: student,
                              onEdit: () async {
                                final editedStudent = await showDialog<Student>(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AddEditStudentDialog(student: student),
                                );
                                if (editedStudent != null) {
                                  bloc.add(StudentListEditPressed(student: editedStudent));
                                }
                              },
                              onDelete: student.id != null
                                  ? () => _showDeleteConfirmation(context, student)
                                  : null,
                            );
                          },
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (ctx) => DeleteStudentConfirmationDialog(
        studentName: student.fullName,
        onConfirm: () {
          bloc.add(StudentListDeletePressed(id: student.id!));
        },
      ),
    );
  }
}
