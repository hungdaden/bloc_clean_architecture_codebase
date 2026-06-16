import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import 'bloc/leave_list.dart';
import 'component/attendance_status_card.dart';
import 'component/leave_status_card.dart';
import '../leave_registration/component/student_profile_header_card.dart';

@RoutePage()
class LeaveListPage extends StatefulWidget {
  const LeaveListPage({super.key});

  @override
  State<LeaveListPage> createState() => _LeaveListPageState();
}

class _LeaveListPageState extends BasePageState<LeaveListPage, LeaveListBloc> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    bloc.add(const LeaveListPageInitiated());
  }

  void _showSettingsBottomSheet(BuildContext context, AppState appState) {
    final appBloc = context.read<AppBloc>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return SettingsBottomSheet(
          initialAccentColor: appState.accentColor,
          initialThemeMode:
              appState.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
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
    final colors = theme.colors;
    final headerHeight = 104.0.responsive();
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return FadedBackgroundPageLayout(
      title: 'Đăng kí nghỉ phép',
      onBackPressed: () => navigator.pop(),
      onSettingsPressed: () {
        final appState = context.read<AppBloc>().state;
        _showSettingsBottomSheet(context, appState);
      },
      child: BlocBuilder<LeaveListBloc, LeaveListState>(
        builder: (context, state) {
          if (state.isShimmerLoading && state.requests.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.primaryColor,
              ),
            );
          }

          final allCount = state.requests.length;
          final approvedCount = state.requests
              .where((r) =>
                  r.status == LeaveStatus.approved ||
                  r.status == LeaveStatus.pending)
              .length;
          final rejectedCount = state.requests
              .where((r) => r.status == LeaveStatus.rejected)
              .length;

          final filteredRequests = state.requests.where((r) {
            if (state.selectedTabIndex == 0) return true;
            if (state.selectedTabIndex == 1) {
              return r.status == LeaveStatus.approved ||
                  r.status == LeaveStatus.pending;
            }
            if (state.selectedTabIndex == 2) {
              return r.status == LeaveStatus.rejected;
            }
            return true;
          }).toList();

          return Stack(
            children: [
              // Scrollable Content
              Positioned.fill(
                child: RefreshIndicator(
                  color: theme.primaryColor,
                  onRefresh: () async {
                    final future = bloc.stream
                        .firstWhere((state) => !state.isShimmerLoading);
                    bloc.add(const LeaveListRefreshRequested());
                    await future.timeout(
                      const Duration(seconds: 3),
                      onTimeout: () => state,
                    );
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: 20.0.responsive(),
                      right: 20.0.responsive(),
                      top: headerHeight +
                          MediaQuery.of(context).padding.top -
                          16.0.responsive(),
                      bottom: (bottomPadding > 0 ? bottomPadding : 16.0)
                              .responsive() +
                          80.0.responsive(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Custom Tab/Segmented Selector (scrolling with app content)
                        _buildTabBar(state.selectedTabIndex, allCount,
                            approvedCount, rejectedCount, theme, colors),
                        SizedBox(height: 16.0.responsive()),

                        StudentProfileHeaderCard(student: state.student),
                        SizedBox(height: 16.0.responsive()),
                        const AttendanceStatusCard(),
                        SizedBox(height: 20.0.responsive()),

                        // Leave Request Section Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Đơn đăng ký nghỉ phép (${filteredRequests.length})',
                              style: TextStyle(
                                fontSize: 14.0.responsive(),
                                fontWeight: FontWeight.bold,
                                color: colors.primaryTextColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0.responsive()),

                        if (filteredRequests.isEmpty)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 40.0.responsive()),
                              child: Text(
                                'Không có đơn đăng ký nghỉ phép nào',
                                style: TextStyle(
                                  color: colors.secondaryTextColor,
                                  fontSize: 14.0.responsive(),
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          )
                        else
                          ...filteredRequests
                              .map((req) => LeaveStatusCard(request: req)),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Button (floating/transparent overlay)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 20.0.responsive(),
                    right: 20.0.responsive(),
                    top: 24.0.responsive(),
                    bottom:
                        (bottomPadding > 0 ? bottomPadding : 16.0).responsive(),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        theme.scaffoldBackgroundColor.withValues(alpha: 0.0),
                        theme.scaffoldBackgroundColor.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                  child: Container(
                    height: 50.0.responsive(),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0.responsive()),
                      color: Color.alphaBlend(
                          Colors.black.withValues(alpha: 0.20),
                          theme.primaryColor),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(bottom: 4.0.responsive()),
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              HapticFeedback.mediumImpact();
                              setState(() {
                                _isLoading = true;
                              });
                              Future.delayed(const Duration(milliseconds: 500),
                                  () async {
                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                                final result = await navigator.push(
                                    const AppRouteInfo.leaveRegistration());
                                if (result == true && mounted) {
                                  bloc.add(const LeaveListRefreshRequested());
                                }
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: _isLoading
                            ? theme.primaryColor
                            : Colors.grey.shade300,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(25.0.responsive()),
                          side: BorderSide.none,
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              width: 20.0.responsive(),
                              height: 20.0.responsive(),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              'Đăng ký nghỉ phép',
                              style: TextStyle(
                                fontSize: 15.0.responsive(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabBar(
    int selectedIndex,
    int allCount,
    int approvedCount,
    int rejectedCount,
    ThemeData theme,
    dynamic colors,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        top: 0,
        bottom: 8.0.responsive(),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabItem(
                0, 'Tất cả\n($allCount)', selectedIndex, theme, colors),
          ),
          SizedBox(width: 8.0.responsive()),
          Expanded(
            child: _buildTabItem(
                1, 'Có phép\n($approvedCount)', selectedIndex, theme, colors),
          ),
          SizedBox(width: 8.0.responsive()),
          Expanded(
            child: _buildTabItem(2, 'Không phép\n($rejectedCount)',
                selectedIndex, theme, colors),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title, int selectedIndex,
      ThemeData theme, dynamic colors) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        bloc.add(LeaveListTabChanged(index: index));
      },
      child: AppThemeCard(
        padding: EdgeInsets.symmetric(vertical: 10.0.responsive()),
        borderRadius: 12.0.responsive(),
        backgroundColor: isSelected ? theme.primaryColor : theme.cardColor,
        borderColor: isSelected
            ? Color.alphaBlend(
                Colors.black.withValues(alpha: 0.20), theme.primaryColor)
            : Color.alphaBlend(
                Colors.black.withValues(alpha: 0.12), theme.cardColor),
        borderWidth: isSelected ? 4.0.responsive() : 2.0.responsive(),
        showBorder: true,
        shadowColor: isSelected
            ? theme.primaryColor.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.02),
        shadowBlurRadius: isSelected ? 8 : 4,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.0.responsive(),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : colors.secondaryTextColor,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}
