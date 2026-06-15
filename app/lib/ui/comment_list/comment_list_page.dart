import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import 'bloc/comment_list.dart';
import 'widgets/comment_list_body.dart';

@RoutePage()
class CommentListPage extends StatefulWidget {
  const CommentListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CommentListPageState();
  }
}

class _CommentListPageState extends BasePageState<CommentListPage, CommentListBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(const CommentListPageInitiated());
  }

  void _showSettingsBottomSheet(BuildContext context, AppState appState) {
    final appBloc = context.read<AppBloc>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return SettingsBottomSheet(
          initialAccentColor: appState.accentColor,
          initialThemeMode: appState.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          onAccentColorChanged: (color) {
            appBloc.add(AppAccentColorChanged(accentColor: color));
          },
          onThemeModeChanged: (mode) {
            appBloc.add(AppThemeChanged(isDarkTheme: mode == ThemeMode.dark));
          },
        );
      },
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    final theme = Theme.of(context);

    return FadedBackgroundPageLayout(
      title: 'Danh sách nhận xét',
      onBackPressed: () => navigator.pop(),
      onSettingsPressed: () {
        final appState = context.read<AppBloc>().state;
        _showSettingsBottomSheet(context, appState);
      },
      child: BlocBuilder<CommentListBloc, CommentListState>(
        builder: (context, state) {
          if (state.isShimmerLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.primaryColor,
              ),
            );
          }

          return CommentListBody(
            state: state,
            onCommentTap: (comment) {
              navigator.push(AppRouteInfo.commentDetail(comment: comment));
            },
          );
        },
      ),
    );
  }
}
