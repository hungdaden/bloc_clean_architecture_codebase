import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import 'bloc/comment_detail.dart';
import 'widgets/comment_detail_body.dart';

@RoutePage()
class CommentDetailPage extends StatefulWidget {
  const CommentDetailPage({super.key, required this.comment});

  final Comment comment;

  @override
  State<StatefulWidget> createState() {
    return _CommentDetailPageState();
  }
}

class _CommentDetailPageState extends BasePageState<CommentDetailPage, CommentDetailBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(CommentDetailPageInitiated(comment: widget.comment));
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
      title: 'Chi tiết nhận xét',
      onBackPressed: () => navigator.pop(),
      onSettingsPressed: () {
        final appState = context.read<AppBloc>().state;
        _showSettingsBottomSheet(context, appState);
      },
      child: BlocBuilder<CommentDetailBloc, CommentDetailState>(
        builder: (context, state) {
          if (state.isShimmerLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.primaryColor,
              ),
            );
          }

          return CommentDetailBody(
            state: state,
            onTabChanged: (index) {
              bloc.add(CommentDetailTabChanged(tabIndex: index));
            },
            onBackPressed: () => navigator.pop(),
          );
        },
      ),
    );
  }
}
