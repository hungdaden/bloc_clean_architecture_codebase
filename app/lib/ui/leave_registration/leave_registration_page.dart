import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import 'bloc/leave_registration.dart';
import 'component/student_profile_header_card.dart';
import 'component/leave_type_selector.dart';
import 'component/leave_calendar_picker.dart';
import 'component/leave_reason_input.dart';
import 'component/leave_confirmation_view.dart';

@RoutePage()
class LeaveRegistrationPage extends StatefulWidget {
  const LeaveRegistrationPage({super.key});

  @override
  State<LeaveRegistrationPage> createState() => _LeaveRegistrationPageState();
}

class _LeaveRegistrationPageState
    extends BasePageState<LeaveRegistrationPage, LeaveRegistrationBloc> {
  final PageController _pageController = PageController();
  bool _isButtonLoading = false;

  @override
  void initState() {
    super.initState();
    bloc.add(const LeaveRegistrationPageInitiated());
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isStepValid(LeaveRegistrationState state) {
    switch (state.currentStep) {
      case 0:
        return state.leaveType != null;
      case 1:
        return state.startDate != null;
      case 2:
        return state.reason.length >= 6;
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _onNextPressed(LeaveRegistrationState state) {
    if (!_isStepValid(state)) return;
    if (state.currentStep < 3) {
      bloc.add(const LeaveRegistrationStepChanged(isNext: true));
      _pageController.animateToPage(
        state.currentStep + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      bloc.add(const LeaveRegistrationSubmitPressed());
    }
  }

  void _onBackPressed(LeaveRegistrationState state) {
    if (state.currentStep > 0) {
      bloc.add(const LeaveRegistrationStepChanged(isNext: false));
      _pageController.animateToPage(
        state.currentStep - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      navigator.pop();
    }
  }

  String _getAppBarTitle(LeaveRegistrationState state) {
    if (state.leaveType != null && state.currentStep > 0) {
      return state.leaveType!.label;
    }
    return 'Đăng ký nghỉ phép';
  }

  String _getAppBarSubtitle(LeaveRegistrationState state) {
    switch (state.currentStep) {
      case 0:
        return 'Chọn hình thức nghỉ phép phù hợp\n cho học sinh';
      case 1:
        return 'Chọn ngày nghỉ phép để nhà trường ghi nhận ngày nghỉ học của học sinh';
      case 2:
        return 'Nhập lý do xin nghỉ phép chi tiết\n để nhà trường xét duyệt';
      case 3:
        return 'Kiểm tra lại thông tin đăng ký nghỉ phép của học sinh';
      default:
        return '';
    }
  }

  @override
  Widget buildPage(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return BlocBuilder<LeaveRegistrationBloc, LeaveRegistrationState>(
      builder: (context, state) {
        final isValid = _isStepValid(state);
        final headerHeight = 152.0.responsive();
        final useSolidBg = state.currentStep == 1;
        final bgThemeColor = useSolidBg
            ? Color.alphaBlend(
                Colors.black.withValues(alpha: 0.45), theme.primaryColor)
            : theme.scaffoldBackgroundColor;

        return FadedBackgroundPageLayout(
          title: _getAppBarTitle(state),
          subtitle: _getAppBarSubtitle(state),
          onBackPressed: () => _onBackPressed(state),
          onSettingsPressed: () {
            final appState = context.read<AppBloc>().state;
            _showSettingsBottomSheet(context, appState);
          },
          useSolidThemeBackground: useSolidBg,
          child: Stack(
            children: [
              // Indicators and PageView
              Positioned.fill(
                child: Column(
                  children: [
                    SizedBox(height: headerHeight + 2.0.responsive()),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // Step 1: Select Type
                          _buildStepWrapper(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StudentProfileHeaderCard(
                                    student: state.student, showBorder: true),
                                SizedBox(height: 12.0.responsive()),
                                LeaveTypeSelector(
                                  selectedType: state.leaveType,
                                  onTypeSelected: (type) {
                                    bloc.add(LeaveRegistrationTypeSelected(
                                        leaveType: type));
                                  },
                                ),
                              ],
                            ),
                          ),

                          // Step 2: Select Date (Calendar)
                          _buildStepWrapper(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StudentProfileHeaderCard(
                                    student: state.student, showBorder: true),
                                if (state.leaveType != null) ...[
                                  SizedBox(height: 6.0.responsive()),
                                  LeaveCalendarPicker(
                                    leaveType: state.leaveType!,
                                    startDate: state.startDate,
                                    endDate: state.endDate,
                                    onDatesChanged: (start, end) {
                                      bloc.add(LeaveRegistrationDatesChanged(
                                        startDate: start,
                                        endDate: end,
                                      ));
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Step 3: Input Reason
                          _buildStepWrapper(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StudentProfileHeaderCard(
                                    student: state.student, showBorder: true),
                                SizedBox(height: 12.0.responsive()),
                                LeaveReasonInput(
                                  reason: state.reason,
                                  onReasonChanged: (reason) {
                                    bloc.add(LeaveRegistrationReasonChanged(
                                        reason: reason));
                                  },
                                ),
                              ],
                            ),
                          ),

                          // Step 4: Confirm details
                          _buildStepWrapper(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StudentProfileHeaderCard(
                                    student: state.student, showBorder: true),
                                SizedBox(height: 12.0.responsive()),
                                if (state.leaveType != null &&
                                    state.startDate != null &&
                                    state.endDate != null)
                                  LeaveConfirmationView(
                                    leaveType: state.leaveType!,
                                    startDate: state.startDate!,
                                    endDate: state.endDate!,
                                    reason: state.reason,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Actions Panel (transparent overlay with top fading)
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
                        bgThemeColor.withValues(alpha: 0.0),
                        bgThemeColor.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      // Circular Back Icon Button
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          _onBackPressed(state);
                        },
                        child: Container(
                          width: 50.0.responsive(),
                          height: 50.0.responsive(),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.cardColor,
                            border: Border.all(
                              color: colors.secondaryTextColor
                                  .withValues(alpha: 0.15),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.chevron_left,
                            color: colors.primaryTextColor,
                            size: 24.0.responsive(),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0.responsive()),
                      // Next/Confirm Button (Pill-shaped)
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 50.0.responsive(),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(25.0.responsive()),
                            color: isValid
                                ? Color.alphaBlend(
                                    Colors.black.withValues(alpha: 0.20),
                                    theme.primaryColor)
                                : Colors.grey.shade400,
                            boxShadow: isValid
                                ? [
                                    BoxShadow(
                                      color: theme.primaryColor
                                          .withValues(alpha: 0.25),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          padding: EdgeInsets.only(bottom: 4.0.responsive()),
                           child: ElevatedButton(
                            onPressed: (isValid && !_isButtonLoading)
                                ? () {
                                    HapticFeedback.mediumImpact();
                                    setState(() {
                                      _isButtonLoading = true;
                                    });
                                    Future.delayed(const Duration(milliseconds: 500), () {
                                      if (mounted) {
                                        setState(() {
                                          _isButtonLoading = false;
                                        });
                                        _onNextPressed(state);
                                      }
                                    });
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: _isButtonLoading
                                  ? theme.primaryColor
                                  : Colors.grey.shade300,
                              disabledForegroundColor: _isButtonLoading
                                  ? Colors.white
                                  : Colors.grey.shade500,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(25.0.responsive()),
                                side: BorderSide.none,
                              ),
                            ),
                            child: _isButtonLoading
                                ? SizedBox(
                                    width: 20.0.responsive(),
                                    height: 20.0.responsive(),
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    state.currentStep == 3
                                        ? 'Xác nhận (4/4)'
                                        : 'Tiếp tục (${state.currentStep + 1}/4)',
                                    style: TextStyle(
                                      fontSize: 14.0.responsive(),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepWrapper({required Widget child, ScrollPhysics? physics}) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return SingleChildScrollView(
      physics: physics ?? const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        left: 20.0.responsive(),
        right: 20.0.responsive(),
        top: 0,
        bottom: (bottomPadding > 0 ? bottomPadding : 16.0).responsive() +
            80.0.responsive(),
      ),
      child: child,
    );
  }
}
