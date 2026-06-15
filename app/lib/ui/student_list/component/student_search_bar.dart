import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app.dart';
import '../bloc/student_list.dart';

class StudentSearchBar extends StatefulWidget {
  const StudentSearchBar({super.key});

  @override
  State<StudentSearchBar> createState() => _StudentSearchBarState();
}

class _StudentSearchBarState extends State<StudentSearchBar> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    context.read<StudentListBloc>().add(StudentListSearchKeywordChanged(keyword: _searchController.text));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    return BlocBuilder<StudentListBloc, StudentListState>(
      buildWhen: (prev, curr) => prev.searchField != curr.searchField,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.d16.responsive(),
            vertical: Dimens.d8.responsive(),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16.0.responsive()),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(
                      color: colors.primaryTextColor,
                      fontSize: 14.0.responsive(),
                    ),
                    decoration: InputDecoration(
                      hintText: _getHintText(state.searchField),
                      hintStyle: TextStyle(
                        color: colors.secondaryTextColor.withValues(alpha: 0.6),
                        fontSize: 14.0.responsive(),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.primaryColor,
                        size: 20.0.responsive(),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0.responsive(),
                        horizontal: 16.0.responsive(),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: Dimens.d8.responsive()),
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16.0.responsive()),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.0.responsive()),
                child: PopupMenuButton<String>(
                  initialValue: state.searchField,
                  icon: Icon(
                    Icons.filter_list,
                    color: theme.primaryColor,
                    size: 24.0.responsive(),
                  ),
                  onSelected: (field) {
                    context.read<StudentListBloc>().add(StudentListSearchFieldChanged(field: field));
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'search',
                      child: Text('Tất cả các trường', style: TextStyle(fontSize: 14.0.responsive())),
                    ),
                    PopupMenuItem(
                      value: 'full_name',
                      child: Text('Họ và tên', style: TextStyle(fontSize: 14.0.responsive())),
                    ),
                    PopupMenuItem(
                      value: 'name',
                      child: Text('Tên gọi', style: TextStyle(fontSize: 14.0.responsive())),
                    ),
                    PopupMenuItem(
                      value: 'city_name',
                      child: Text('Thành phố', style: TextStyle(fontSize: 14.0.responsive())),
                    ),
                    PopupMenuItem(
                      value: 'sex',
                      child: Text('Giới tính', style: TextStyle(fontSize: 14.0.responsive())),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getHintText(String searchField) {
    switch (searchField) {
      case 'full_name':
        return 'Tìm theo họ và tên...';
      case 'name':
        return 'Tìm theo tên gọi...';
      case 'city_name':
        return 'Tìm theo thành phố...';
      case 'sex':
        return 'Tìm theo giới tính (male/female)...';
      default:
        return 'Tìm kiếm học sinh...';
    }
  }
}
