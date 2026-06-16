import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import 'bloc/breakfast_tracking_bloc.dart';
import 'bloc/breakfast_tracking_event.dart';
import 'bloc/breakfast_tracking_state.dart';
import 'widgets/breakfast_status_card.dart';
import 'widgets/breakfast_terms_dialog.dart';
import 'widgets/cancel_confirmation_dialog.dart';
import 'widgets/delete_cancel_confirmation_dialog.dart';
import 'widgets/student_horizontal_selector.dart';

@RoutePage()
class BreakfastTrackingPage extends StatefulWidget {
  const BreakfastTrackingPage({super.key});

  @override
  State<BreakfastTrackingPage> createState() => _BreakfastTrackingPageState();
}

class _BreakfastTrackingPageState
    extends BasePageState<BreakfastTrackingPage, BreakfastTrackingBloc>
    with SingleTickerProviderStateMixin {
  final _reasonController = TextEditingController();
  late final AnimationController _toastController;
  late final Animation<Offset> _toastAnimation;
  bool _isToastVisible = false;
  String _toastMessage = '';

  @override
  void initState() {
    super.initState();
    bloc.add(const BreakfastTrackingInitiated());
    _toastController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _toastAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _toastController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _toastController.dispose();
    super.dispose();
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BreakfastTermsDialog(
          onConfirm: () {
            Navigator.of(dialogContext).pop();
            bloc.add(const TermsAgreedChanged(true));
          },
          onCancel: () {
            Navigator.of(dialogContext).pop();
            bloc.add(const TermsAgreedChanged(false));
          },
        );
      },
    );
  }

  void _showCancelConfirmation(BuildContext context, dynamic student) {
    CancelConfirmationDialog.show(
      context,
      studentName: student.fullName,
      onConfirm: () {
        bloc.add(ConfirmCancellation(student));
        _showToast(context, 'Huỷ sử dụng dịch vụ thành công');
      },
      onCancel: () {},
    );
  }

  void _showWithdrawConfirmation(BuildContext context, dynamic student) {
    DeleteCancelConfirmationDialog.show(
      context,
      onConfirm: () {
        bloc.add(WithdrawCancellation(student));
        _showToast(context, 'Xoá đơn huỷ dịch vụ thành công');
      },
      onCancel: () {},
    );
  }

  void _showToast(BuildContext context, String message) {
    _showCustomToast(message);
  }

  void _showCustomToast(String message) {
    if (!mounted) return;

    _toastController.stop();

    setState(() {
      _toastMessage = message;
      _isToastVisible = true;
    });

    _toastController.forward(from: 0.0);

    // Auto hide after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isToastVisible && _toastMessage == message) {
        _toastController.reverse().then((_) {
          if (mounted) {
            setState(() {
              _isToastVisible = false;
            });
          }
        });
      }
    });
  }

  Widget _buildToastWidget() {
    if (!_isToastVisible) return const SizedBox.shrink();
    return SlideTransition(
      position: _toastAnimation,
      child: Container(
        height: 50.0.responsive(),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(25.0.responsive()),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0.responsive()),
        alignment: Alignment.center,
        child: Text(
          _toastMessage,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14.0.responsive(),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final topPadding = MediaQuery.of(context).padding.top;
    final headerHeight = 104.0.responsive();

    return BlocBuilder<BreakfastTrackingBloc, BreakfastTrackingState>(
      builder: (context, state) {
        final listStudents = state.studentsStatus.keys.toList();

        Widget bodyContent;
        String title;

        switch (state.currentStep) {
          case BreakfastScreenStep.list:
            title = 'Theo dõi ăn sáng';
            bodyContent = _buildListScreen(
              context,
              state,
              bottomPadding,
              headerHeight,
              topPadding,
            );
            break;
          case BreakfastScreenStep.register:
            title = 'Đăng ký ăn sáng';
            bodyContent = _buildRegisterScreen(
              context,
              state,
              listStudents,
              bottomPadding,
              headerHeight,
              topPadding,
            );
            break;
          case BreakfastScreenStep.details:
            title = 'Đăng ký ăn sáng #01';
            bodyContent = _buildDetailsScreen(
              context,
              state,
              bottomPadding,
              headerHeight,
              topPadding,
            );
            break;
          case BreakfastScreenStep.cancelReason:
            title = 'Hủy dịch vụ ăn sáng';
            bodyContent = _buildCancelReasonScreen(
              context,
              state,
              bottomPadding,
              headerHeight,
              topPadding,
            );
            break;
          case BreakfastScreenStep.cancelDetails:
            title = 'Huỷ dịch vụ ăn sáng #01';
            bodyContent = _buildCancelDetailsScreen(
              context,
              state,
              bottomPadding,
              headerHeight,
              topPadding,
            );
            break;
        }

        return PopScope(
          canPop: state.currentStep == BreakfastScreenStep.list,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            bloc.add(const CancelButtonPressed());
          },
          child: FadedBackgroundPageLayout(
            title: title,
            titleFontSize: 18.0.responsive(),
            rightIcon: state.currentStep == BreakfastScreenStep.list
                ? Icons.refresh_rounded
                : null,
            onSettingsPressed: state.currentStep == BreakfastScreenStep.list
                ? () {
                    HapticFeedback.mediumImpact();
                    bloc.add(const BreakfastTrackingInitiated());
                    _showToast(context, 'Đã đặt lại trạng thái ban đầu');
                  }
                : null,
            onBackPressed: () {
              HapticFeedback.mediumImpact();
              if (state.currentStep != BreakfastScreenStep.list) {
                bloc.add(const CancelButtonPressed());
              } else {
                navigator.pop();
              }
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.03),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          )),
                          child: child,
                        ),
                      );
                    },
                    child: bodyContent,
                  ),
                ),
                if (state.isSubmitting)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black12,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                // Custom Toast Overlay next to the circular back button
                if (state.currentStep != BreakfastScreenStep.register)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      ignoring: !_isToastVisible,
                      child: _buildBottomPanel(
                        bottomPadding: bottomPadding,
                        bgThemeColor: Colors.transparent,
                        child: Row(
                          children: [
                            SizedBox(width: 66.0.responsive()), // Align right of back button
                            Expanded(
                              child: _buildToastWidget(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListScreen(
    BuildContext context,
    BreakfastTrackingState state,
    double bottomPadding,
    double headerHeight,
    double topPadding,
  ) {
    final theme = Theme.of(context);

    return Stack(
      key: const ValueKey('list'),
      children: [
        Positioned.fill(
          child: ListView.builder(
            itemCount: state.studentsStatus.length,
            padding: EdgeInsets.only(
              left: 20.0.responsive(),
              right: 20.0.responsive(),
              top: headerHeight + topPadding + 16.0.responsive(),
              bottom: 88.0.responsive() + bottomPadding,
            ),
            itemBuilder: (context, index) {
              final student = state.studentsStatus.keys.elementAt(index);
              final status = state.studentsStatus[student]!;

              return BreakfastStatusCard(
                student: student,
                status: status,
                onCancelPendingPressed: () {
                  bloc.add(StudentCardPressed(student));
                },
              );
            },
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildBottomPanel(
            bottomPadding: bottomPadding,
            bgThemeColor: theme.scaffoldBackgroundColor,
            child: Row(
              children: [
                // Bottom Left Circular Back Button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    navigator.pop();
                  },
                  child: Container(
                    width: 50.0.responsive(),
                    height: 50.0.responsive(),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.08),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                      size: 18.0.responsive(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterScreen(
    BuildContext context,
    BreakfastTrackingState state,
    List<dynamic> listStudents,
    double bottomPadding,
    double headerHeight,
    double topPadding,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final isDark = theme.brightness == Brightness.dark;

    final primaryHSL = HSLColor.fromColor(theme.primaryColor);
    final darkerPrimary = primaryHSL
        .withLightness((primaryHSL.lightness - 0.15).clamp(0.0, 1.0))
        .toColor();

    final unregisteredStudents = listStudents
        .where((s) => state.studentsStatus[s] == BreakfastStatus.notRegistered)
        .toList();

    return Stack(
      key: const ValueKey('register'),
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: headerHeight + topPadding + 16.0.responsive(),
              bottom: 110.0.responsive() + bottomPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.responsive()),
                  child: Text(
                    'Chọn học sinh đăng ký:',
                    style: TextStyle(
                      fontSize: 14.0.responsive(),
                      fontWeight: FontWeight.bold,
                      color: colors.primaryTextColor,
                    ),
                  ),
                ),
                SizedBox(height: 6.0.responsive()),
                StudentHorizontalSelector(
                  students: List<Student>.from(unregisteredStudents),
                  selectedStudent: state.selectedStudentForRegister,
                  onStudentSelected: (student) {
                    bloc.add(StudentSelected(student));
                  },
                ),
                SizedBox(height: 12.0.responsive()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.responsive()),
                  child: AppThemeCard(
                    padding: EdgeInsets.all(16.0.responsive()),
                    borderRadius: 20.0.responsive(),
                    borderColor: theme.primaryColor,
                    borderWidth: 4.0.responsive(),
                    showBorder: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '2.640.000 đ',
                          style: TextStyle(
                            fontSize: 28.0.responsive(),
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        SizedBox(height: 4.0.responsive()),
                        Text(
                          'Học phí ăn sáng / Học kỳ 1',
                          style: TextStyle(
                            fontSize: 13.0.responsive(),
                            color: colors.secondaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 12.0.responsive()),
                        const Divider(color: Colors.black12),
                        SizedBox(height: 8.0.responsive()),
                        _buildRowInfo('Đơn giá:', '30.000 đ/ngày', colors),
                        SizedBox(height: 6.0.responsive()),
                        _buildRowInfo('Số ngày học:', '88 ngày', colors),
                        SizedBox(height: 6.0.responsive()),
                        _buildRowInfo('Thời hạn áp dụng:',
                            '05/09/2026 - 15/01/2027', colors),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.0.responsive()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.responsive()),
                  child: Row(
                    children: [
                      Checkbox(
                        value: state.termsAgreed,
                        onChanged: (val) {
                          HapticFeedback.lightImpact();
                          if (val == true) {
                            _showTermsDialog(context);
                          } else {
                            bloc.add(const TermsAgreedChanged(false));
                          }
                        },
                        activeColor: theme.primaryColor,
                      ),
                      Expanded(
                        child: Text(
                          'Tôi đồng ý với điều khoản dịch vụ ăn sáng',
                          style: TextStyle(
                            fontSize: 13.0.responsive(),
                            color: colors.primaryTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildBottomPanel(
            bottomPadding: bottomPadding,
            bgThemeColor: theme.scaffoldBackgroundColor,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      bloc.add(const CancelButtonPressed());
                    },
                    child: Container(
                      height: 50.0.responsive(),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.15)
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(25.0.responsive()),
                      ),
                      padding: EdgeInsets.only(
                        top: 1.0.responsive(),
                        left: 1.0.responsive(),
                        right: 1.0.responsive(),
                        bottom: 4.0.responsive(), // Thick bottom border
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(24.0.responsive()),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Hủy',
                          style: TextStyle(
                            color: colors.secondaryTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0.responsive(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0.responsive()),
                Expanded(
                  child: GestureDetector(
                    onTap: state.termsAgreed
                        ? () {
                            HapticFeedback.mediumImpact();
                            bloc.add(const RegisterSubmitPressed());
                            _showToast(context, 'Đăng ký dịch vụ ăn sáng thành công');
                          }
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      height: 50.0.responsive(),
                      decoration: BoxDecoration(
                        color: state.termsAgreed
                            ? darkerPrimary
                            : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(25.0.responsive()),
                      ),
                      padding: EdgeInsets.only(
                        top: 1.0.responsive(),
                        left: 1.0.responsive(),
                        right: 1.0.responsive(),
                        bottom: 4.0.responsive(), // Thick bottom border
                      ),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: state.termsAgreed
                              ? theme.primaryColor
                              : (isDark
                                  ? Colors.grey.shade900.withValues(alpha: 0.4)
                                  : Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(24.0.responsive()),
                        ),
                        alignment: Alignment.center,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: TextStyle(
                            fontSize: 14.0.responsive(),
                            fontWeight: FontWeight.bold,
                            color: state.termsAgreed
                                ? Colors.white
                                : (isDark ? Colors.grey.shade500 : Colors.grey.shade400),
                          ),
                          child: const Text('Đăng ký'),
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
    );
  }

  Widget _buildDetailsScreen(
    BuildContext context,
    BreakfastTrackingState state,
    double bottomPadding,
    double headerHeight,
    double topPadding,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final isDark = theme.brightness == Brightness.dark;

    final student = state.selectedStudentForRegister;
    if (student == null) return const SizedBox.shrink();

    final cardShadowColor = isDark
        ? Colors.black.withValues(alpha: 0.2)
        : Colors.black.withValues(alpha: 0.02);

    return Stack(
      key: const ValueKey('details'),
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: headerHeight + topPadding + 16.0.responsive(),
              bottom: 88.0.responsive() + bottomPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Student Card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.responsive()),
                  child: AppThemeCard(
                    padding: EdgeInsets.all(16.0.responsive()),
                    borderRadius: 20.0.responsive(),
                    borderColor: theme.primaryColor,
                    borderWidth: 4.0.responsive(),
                    showBorder: true,
                    shadowColor: cardShadowColor,
                    backgroundColor: theme.cardColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.fullName,
                                style: TextStyle(
                                  fontSize: 20.0.responsive(),
                                  fontWeight: FontWeight.bold,
                                  color: colors.primaryTextColor,
                                ),
                              ),
                              SizedBox(height: 4.0.responsive()),
                              Text(
                                'Lớp 11D2 - ${student.id ?? 'PS01092007'}',
                                style: TextStyle(
                                  fontSize: 14.0.responsive(),
                                  color: colors.secondaryTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.0.responsive()),
                        Container(
                          width: 54.0.responsive(),
                          height: 54.0.responsive(),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colors.secondaryTextColor
                                  .withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(27.0.responsive()),
                            child: student.avatarUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: student.avatarUrl,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        _buildPlaceholder(colors),
                                  )
                                : _buildPlaceholder(colors),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0.responsive()),

                SizedBox(
                  height: 302.0.responsive(),
                  child: PageView(
                    controller: PageController(viewportFraction: 0.88),
                    children: [
                      // Page 1: Phí dịch vụ cả năm & Thông tin đăng ký
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6.0.responsive()),
                        child: Column(
                          children: [
                            // Card A: Phí dịch vụ cả năm
                            AppThemeCard(
                              padding: EdgeInsets.all(12.0.responsive()),
                              borderRadius: 16.0.responsive(),
                              borderColor: theme.primaryColor,
                              borderWidth: 4.0.responsive(),
                              showBorder: true,
                              shadowColor: cardShadowColor,
                              backgroundColor: theme.cardColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      _buildSmallCircleIcon(
                                          Icons.monetization_on_outlined,
                                          const Color(0xFF2E7D32),
                                          const Color(0xFFE8F5E9)),
                                      SizedBox(width: 8.0.responsive()),
                                      Text(
                                        'Phí dịch vụ cả năm',
                                        style: TextStyle(
                                          fontSize: 14.0.responsive(),
                                          fontWeight: FontWeight.bold,
                                          color: colors.primaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0.responsive()),
                                  Text(
                                    '2.600.000 đ',
                                    style: TextStyle(
                                      fontSize: 22.0.responsive(),
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                  SizedBox(height: 8.0.responsive()),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Năm học',
                                                style: TextStyle(
                                                    fontSize: 11.0.responsive(),
                                                    color: colors
                                                        .secondaryTextColor)),
                                            SizedBox(height: 2.0.responsive()),
                                            Text('2025 - 2026',
                                                style: TextStyle(
                                                    fontSize: 13.0.responsive(),
                                                    fontWeight: FontWeight.bold,
                                                    color: colors
                                                        .primaryTextColor)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Thời gian',
                                                style: TextStyle(
                                                    fontSize: 11.0.responsive(),
                                                    color: colors
                                                        .secondaryTextColor)),
                                            SizedBox(height: 2.0.responsive()),
                                            Text('Toàn bộ năm học',
                                                style: TextStyle(
                                                    fontSize: 13.0.responsive(),
                                                    fontWeight: FontWeight.bold,
                                                    color: colors
                                                        .primaryTextColor)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.0.responsive()),
                            // Card B: Thông tin đăng ký
                            AppThemeCard(
                              padding: EdgeInsets.all(12.0.responsive()),
                              borderRadius: 16.0.responsive(),
                              borderColor: theme.primaryColor,
                              borderWidth: 4.0.responsive(),
                              showBorder: true,
                              shadowColor: cardShadowColor,
                              backgroundColor: theme.cardColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      _buildSmallCircleIcon(
                                          Icons.description_outlined,
                                          const Color(0xFF1976D2),
                                          const Color(0xFFE3F2FD)),
                                      SizedBox(width: 8.0.responsive()),
                                      Text(
                                        'Thông tin đăng ký',
                                        style: TextStyle(
                                          fontSize: 14.0.responsive(),
                                          fontWeight: FontWeight.bold,
                                          color: colors.primaryTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0.responsive()),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Loại dịch vụ',
                                                style: TextStyle(
                                                    fontSize: 11.0.responsive(),
                                                    color: colors
                                                        .secondaryTextColor)),
                                            SizedBox(height: 2.0.responsive()),
                                            Text('Dịch vụ ăn sáng',
                                                style: TextStyle(
                                                    fontSize: 13.0.responsive(),
                                                    fontWeight: FontWeight.bold,
                                                    color: colors
                                                        .primaryTextColor)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Loại đăng ký',
                                                style: TextStyle(
                                                    fontSize: 11.0.responsive(),
                                                    color: colors
                                                        .secondaryTextColor)),
                                            SizedBox(height: 2.0.responsive()),
                                            Text('Đăng ký cả năm',
                                                style: TextStyle(
                                                    fontSize: 13.0.responsive(),
                                                    fontWeight: FontWeight.bold,
                                                    color: colors
                                                        .primaryTextColor)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0.responsive()),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Tháng sử dụng',
                                                style: TextStyle(
                                                    fontSize: 11.0.responsive(),
                                                    color: colors
                                                        .secondaryTextColor)),
                                            SizedBox(height: 2.0.responsive()),
                                            Text('T8/2026 → T5/2027',
                                                style: TextStyle(
                                                    fontSize: 13.0.responsive(),
                                                    fontWeight: FontWeight.bold,
                                                    color: colors
                                                        .primaryTextColor)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Số tháng sử dụng',
                                                style: TextStyle(
                                                    fontSize: 11.0.responsive(),
                                                    color: colors
                                                        .secondaryTextColor)),
                                            SizedBox(height: 2.0.responsive()),
                                            Text('10 tháng',
                                                style: TextStyle(
                                                    fontSize: 13.0.responsive(),
                                                    fontWeight: FontWeight.bold,
                                                    color: colors
                                                        .primaryTextColor)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Page 2: Phí dịch vụ chia theo tháng
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6.0.responsive()),
                        child: AppThemeCard(
                          padding: EdgeInsets.all(12.0.responsive()),
                          borderRadius: 20.0.responsive(),
                          borderColor: theme.primaryColor,
                          borderWidth: 4.0.responsive(),
                          showBorder: true,
                          shadowColor: cardShadowColor,
                          backgroundColor: theme.cardColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  _buildSmallCircleIcon(
                                      Icons.calendar_month_outlined,
                                      const Color(0xFFE65100),
                                      const Color(0xFFFFF3E0)),
                                  SizedBox(width: 8.0.responsive()),
                                  Text(
                                    'Học phí chia theo tháng',
                                    style: TextStyle(
                                      fontSize: 14.0.responsive(),
                                      fontWeight: FontWeight.bold,
                                      color: colors.primaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.0.responsive()),
                              _buildMonthlyRow(
                                  'Tháng 8/2026', '400.000 đ', colors),
                              _buildMonthlyRow(
                                  'Tháng 9/2026', '400.000 đ', colors),
                              _buildMonthlyRow(
                                  'Tháng 10/2026', '400.000 đ', colors),
                              _buildMonthlyRow(
                                  'Tháng 11/2026', '380.000 đ', colors),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0.responsive()),

                // Bottom Section: Cán bộ bếp phê duyệt
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.responsive()),
                  child: AppThemeCard(
                    padding: EdgeInsets.all(16.0.responsive()),
                    borderRadius: 20.0.responsive(),
                    borderColor: theme.primaryColor,
                    borderWidth: 4.0.responsive(),
                    showBorder: true,
                    shadowColor: cardShadowColor,
                    backgroundColor: theme.cardColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            _buildSmallCircleIcon(
                                Icons.verified_user_outlined,
                                const Color(0xFF2E7D32),
                                const Color(0xFFE8F5E9)),
                            SizedBox(width: 8.0.responsive()),
                            Text(
                              'Cán bộ bếp phê duyệt',
                              style: TextStyle(
                                fontSize: 14.0.responsive(),
                                fontWeight: FontWeight.bold,
                                color: colors.primaryTextColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0.responsive()),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Họ và tên',
                                      style: TextStyle(
                                          fontSize: 11.0.responsive(),
                                          color: colors.secondaryTextColor)),
                                  SizedBox(height: 2.0.responsive()),
                                  Text('Trương Đức Nghĩa',
                                      style: TextStyle(
                                          fontSize: 13.0.responsive(),
                                          fontWeight: FontWeight.bold,
                                          color: colors.primaryTextColor)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Mã giáo viên',
                                      style: TextStyle(
                                          fontSize: 11.0.responsive(),
                                          color: colors.secondaryTextColor)),
                                  SizedBox(height: 2.0.responsive()),
                                  Text('PS102',
                                      style: TextStyle(
                                          fontSize: 13.0.responsive(),
                                          fontWeight: FontWeight.bold,
                                          color: colors.primaryTextColor)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0.responsive()),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Trạng thái',
                                      style: TextStyle(
                                          fontSize: 11.0.responsive(),
                                          color: colors.secondaryTextColor)),
                                  SizedBox(height: 4.0.responsive()),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0.responsive(),
                                        vertical: 3.0.responsive()),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(
                                          12.0.responsive()),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.check_circle,
                                            size: 12, color: Color(0xFF2E7D32)),
                                        SizedBox(width: 4.0.responsive()),
                                        const Text('Đã duyệt',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF2E7D32))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Thời gian duyệt',
                                      style: TextStyle(
                                          fontSize: 11.0.responsive(),
                                          color: colors.secondaryTextColor)),
                                  SizedBox(height: 2.0.responsive()),
                                  Text('18/05/2026 09:00',
                                      style: TextStyle(
                                          fontSize: 13.0.responsive(),
                                          fontWeight: FontWeight.bold,
                                          color: colors.primaryTextColor)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.0.responsive()),

                // Cancel Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.responsive()),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      _showCancelConfirmation(context, student);
                    },
                    child: Container(
                      height: 50.0.responsive(),
                      decoration: BoxDecoration(
                        color: const Color(
                            0xFFC62828), // Outer solid red border line
                        borderRadius: BorderRadius.circular(25.0.responsive()),
                      ),
                      padding: EdgeInsets.only(
                        top: 1.0.responsive(),
                        left: 1.0.responsive(),
                        right: 1.0.responsive(),
                        bottom: 4.0.responsive(), // Thick bottom border
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? const Color(
                                  0xFF3D1D1D) // Opaque dark red for dark mode
                              : const Color(
                                  0xFFFFECEC), // Opaque soft red for light mode
                          borderRadius:
                              BorderRadius.circular(24.0.responsive()),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Huỷ sử dụng dịch vụ',
                          style: TextStyle(
                            color: const Color(0xFFC62828),
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0.responsive(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom panel containing only the circular back button
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildBottomPanel(
            bottomPadding: bottomPadding,
            bgThemeColor: theme.scaffoldBackgroundColor,
            child: Row(
              children: [
                // Bottom Left Circular Back Button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    bloc.add(const CancelButtonPressed());
                  },
                  child: Container(
                    width: 50.0.responsive(),
                    height: 50.0.responsive(),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.08),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                      size: 18.0.responsive(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelDetailsScreen(
    BuildContext context,
    BreakfastTrackingState state,
    double bottomPadding,
    double headerHeight,
    double topPadding,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final isDark = theme.brightness == Brightness.dark;

    final student = state.selectedStudentForRegister;
    if (student == null) return const SizedBox.shrink();

    final cardShadowColor = isDark
        ? Colors.black.withValues(alpha: 0.2)
        : Colors.black.withValues(alpha: 0.02);

    return Stack(
      key: const ValueKey('cancel_details'),
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: headerHeight + topPadding + 16.0.responsive(),
              bottom: 88.0.responsive() + bottomPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Student Card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.responsive()),
                  child: AppThemeCard(
                    padding: EdgeInsets.all(16.0.responsive()),
                    borderRadius: 20.0.responsive(),
                    borderColor: theme.primaryColor,
                    borderWidth: 4.0.responsive(),
                    showBorder: true,
                    shadowColor: cardShadowColor,
                    backgroundColor: theme.cardColor,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.fullName,
                                style: TextStyle(
                                  fontSize: 20.0.responsive(),
                                  fontWeight: FontWeight.bold,
                                  color: colors.primaryTextColor,
                                ),
                              ),
                              SizedBox(height: 4.0.responsive()),
                              Text(
                                'Lớp 11D2 - ${student.id ?? 'PS01092007'}',
                                style: TextStyle(
                                  fontSize: 14.0.responsive(),
                                  color: colors.secondaryTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.0.responsive()),
                        Container(
                          width: 54.0.responsive(),
                          height: 54.0.responsive(),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colors.secondaryTextColor
                                  .withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(27.0.responsive()),
                            child: student.avatarUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: student.avatarUrl,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        _buildPlaceholder(colors),
                                  )
                                : _buildPlaceholder(colors),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0.responsive()),

                // Thông tin huỷ dịch vụ Card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.responsive()),
                  child: AppThemeCard(
                    padding: EdgeInsets.all(16.0.responsive()),
                    borderRadius: 20.0.responsive(),
                    borderColor: theme.primaryColor,
                    borderWidth: 4.0.responsive(),
                    showBorder: true,
                    shadowColor: cardShadowColor,
                    backgroundColor: theme.cardColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            _buildSmallCircleIcon(
                                Icons.info_outline,
                                const Color(0xFF1976D2),
                                const Color(0xFFE3F2FD)),
                            SizedBox(width: 8.0.responsive()),
                            Text(
                              'Thông tin huỷ dịch vụ',
                              style: TextStyle(
                                fontSize: 14.0.responsive(),
                                fontWeight: FontWeight.bold,
                                color: colors.primaryTextColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0.responsive()),
                        _buildDetailRow('Họ tên học sinh', student.fullName,
                            'Mã học sinh', student.id ?? 'PS01092007', colors),
                        SizedBox(height: 10.0.responsive()),
                        _buildDetailRow('Lớp học', 'Lớp 11D2', 'Loại dịch vụ',
                            'Dịch vụ ăn sáng', colors),
                        SizedBox(height: 10.0.responsive()),
                        _buildDetailRow('Tháng đăng ký', 'T8/2026 → T5/2027',
                            'Số tháng đăng ký', '10 tháng', colors),
                        SizedBox(height: 10.0.responsive()),
                        _buildDetailRow('Tháng huỷ', 'T1/2027 → T5/2027',
                            'Số tháng huỷ', '5 tháng', colors),
                        SizedBox(height: 10.0.responsive()),
                        _buildDetailRow('Người tạo', 'PH. Nguyễn Thu Thảo',
                            'Thời gian tạo', 'T2, 20/07/2026 09:00', colors),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0.responsive()),

                // Cán bộ bếp phê duyệt Card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.responsive()),
                  child: AppThemeCard(
                    padding: EdgeInsets.all(16.0.responsive()),
                    borderRadius: 20.0.responsive(),
                    borderColor: theme.primaryColor,
                    borderWidth: 4.0.responsive(),
                    showBorder: true,
                    shadowColor: cardShadowColor,
                    backgroundColor: theme.cardColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            _buildSmallCircleIcon(
                                Icons.verified_user_outlined,
                                const Color(0xFF2E7D32),
                                const Color(0xFFE8F5E9)),
                            SizedBox(width: 8.0.responsive()),
                            Text(
                              'Cán bộ bếp phê duyệt',
                              style: TextStyle(
                                fontSize: 14.0.responsive(),
                                fontWeight: FontWeight.bold,
                                color: colors.primaryTextColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0.responsive()),
                        _buildDetailRow('Họ và tên', 'Trương Đức Nghĩa',
                            'Mã giáo viên', 'PS102', colors),
                        SizedBox(height: 10.0.responsive()),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Trạng thái',
                                      style: TextStyle(
                                          fontSize: 11.0.responsive(),
                                          color: colors.secondaryTextColor)),
                                  SizedBox(height: 4.0.responsive()),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0.responsive(),
                                        vertical: 3.0.responsive()),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF3E0),
                                      borderRadius: BorderRadius.circular(
                                          12.0.responsive()),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.pending_rounded,
                                            size: 12, color: Color(0xFFE65100)),
                                        SizedBox(width: 4.0.responsive()),
                                        const Text('Chờ duyệt',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFE65100))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Thời gian duyệt',
                                      style: TextStyle(
                                          fontSize: 11.0.responsive(),
                                          color: colors.secondaryTextColor)),
                                  SizedBox(height: 2.0.responsive()),
                                  Text('--',
                                      style: TextStyle(
                                          fontSize: 13.0.responsive(),
                                          fontWeight: FontWeight.bold,
                                          color: colors.primaryTextColor)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0.responsive()),

                // Green info banner
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.responsive()),
                  child: Container(
                    padding: EdgeInsets.all(16.0.responsive()),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1B3A2A)
                          : const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(16.0.responsive()),
                      border: Border.all(
                        color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'Học sinh vẫn tiếp tục sử dụng bữa sáng trong tháng hiện tại theo đơn đăng ký trước đó.',
                      style: TextStyle(
                        fontSize: 13.0.responsive(),
                        color: isDark
                            ? const Color(0xFF81C784)
                            : const Color(0xFF2E7D32),
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.0.responsive()),

                // Red delete button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.responsive()),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      _showWithdrawConfirmation(context, student);
                    },
                    child: Container(
                      height: 50.0.responsive(),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC62828),
                        borderRadius: BorderRadius.circular(25.0.responsive()),
                      ),
                      padding: EdgeInsets.only(
                        top: 1.0.responsive(),
                        left: 1.0.responsive(),
                        right: 1.0.responsive(),
                        bottom: 4.0.responsive(),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF3D1D1D)
                              : const Color(0xFFFFECEC),
                          borderRadius:
                              BorderRadius.circular(24.0.responsive()),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Xoá đơn huỷ dịch vụ',
                          style: TextStyle(
                            color: const Color(0xFFC62828),
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0.responsive(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom back button
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildBottomPanel(
            bottomPadding: bottomPadding,
            bgThemeColor: theme.scaffoldBackgroundColor,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    bloc.add(const CancelButtonPressed());
                  },
                  child: Container(
                    width: 50.0.responsive(),
                    height: 50.0.responsive(),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.08),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: theme.brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                      size: 18.0.responsive(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelReasonScreen(
    BuildContext context,
    BreakfastTrackingState state,
    double bottomPadding,
    double headerHeight,
    double topPadding,
  ) {
    final theme = Theme.of(context);
    final colors = theme.colors;

    final student = state.selectedStudentForRegister;

    return Stack(
      key: const ValueKey('cancel_reason'),
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 20.0.responsive(),
              right: 20.0.responsive(),
              top: headerHeight + topPadding + 16.0.responsive(),
              bottom: 110.0.responsive() + bottomPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (student != null)
                  BreakfastStatusCard(
                    student: student,
                    status: BreakfastStatus.pending,
                    onCancelPendingPressed: () {},
                  ),
                SizedBox(height: 12.0.responsive()),
                Text(
                  'Lý do hủy dịch vụ:',
                  style: TextStyle(
                    fontSize: 14.0.responsive(),
                    fontWeight: FontWeight.bold,
                    color: colors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 8.0.responsive()),
                TextField(
                  controller: _reasonController,
                  maxLines: 4,
                  onChanged: (val) {
                    bloc.add(CancelReasonChanged(val));
                  },
                  decoration: InputDecoration(
                    hintText:
                        'Nhập lý do chi tiết hủy dịch vụ ăn sáng của học sinh...',
                    hintStyle: TextStyle(
                      color: colors.secondaryTextColor.withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: theme.cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0.responsive()),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0.responsive()),
                      borderSide:
                          BorderSide(color: theme.primaryColor, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildBottomPanel(
            bottomPadding: bottomPadding,
            bgThemeColor: theme.scaffoldBackgroundColor,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      bloc.add(const CancelButtonPressed());
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.secondaryTextColor,
                      side: BorderSide(color: theme.dividerColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0.responsive()),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 14.0.responsive()),
                    ),
                    child: const Text('Quay lại'),
                  ),
                ),
                SizedBox(width: 16.0.responsive()),
                Expanded(
                  child: Container(
                    height: 50.0.responsive(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0.responsive()),
                      color: state.cancelReason.isNotEmpty
                          ? const Color(0xFFC62828)
                          : Colors.grey.shade400,
                    ),
                    child: ElevatedButton(
                      onPressed: state.cancelReason.isNotEmpty
                          ? () {
                              HapticFeedback.mediumImpact();
                              if (student != null) {
                                _showCancelConfirmation(context, student);
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(25.0.responsive()),
                        ),
                      ),
                      child: Text(
                        'Hủy đăng ký',
                        style: TextStyle(
                          fontSize: 14.0.responsive(),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
    );
  }

  Widget _buildRowInfo(String label, String value, dynamic colors) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0.responsive()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13.0.responsive(),
              color: colors.secondaryTextColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.0.responsive(),
              fontWeight: FontWeight.w500,
              color: colors.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label1, String value1, String label2,
      String value2, dynamic colors) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label1,
                  style: TextStyle(
                      fontSize: 11.0.responsive(),
                      color: colors.secondaryTextColor)),
              SizedBox(height: 2.0.responsive()),
              Text(value1,
                  style: TextStyle(
                      fontSize: 13.0.responsive(),
                      fontWeight: FontWeight.bold,
                      color: colors.primaryTextColor)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label2,
                  style: TextStyle(
                      fontSize: 11.0.responsive(),
                      color: colors.secondaryTextColor)),
              SizedBox(height: 2.0.responsive()),
              Text(value2,
                  style: TextStyle(
                      fontSize: 13.0.responsive(),
                      fontWeight: FontWeight.bold,
                      color: colors.primaryTextColor)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomPanel({
    required double bottomPadding,
    required Color bgThemeColor,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.0.responsive(),
        right: 20.0.responsive(),
        top: 16.0.responsive(),
        bottom: (bottomPadding > 0 ? bottomPadding : 16.0).responsive(),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            bgThemeColor.withValues(alpha: 0.0),
            bgThemeColor.withValues(alpha: 0.12),
            bgThemeColor.withValues(alpha: 0.35),
            bgThemeColor.withValues(alpha: 0.65),
            bgThemeColor.withValues(alpha: 0.88),
            bgThemeColor.withValues(alpha: 0.98),
          ],
          stops: const [0.0, 0.25, 0.5, 0.72, 0.88, 1.0],
        ),
      ),
      child: child,
    );
  }

  Widget _buildSmallCircleIcon(IconData icon, Color color, Color bgColor) {
    return Container(
      padding: EdgeInsets.all(6.0.responsive()),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 16.0.responsive(),
        color: color,
      ),
    );
  }

  Widget _buildMonthlyRow(
      String monthLabel, String priceLabel, dynamic colors) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.responsive()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            monthLabel,
            style: TextStyle(
              fontSize: 13.0.responsive(),
              color: colors.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            priceLabel,
            style: TextStyle(
              fontSize: 13.0.responsive(),
              fontWeight: FontWeight.bold,
              color: colors.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(dynamic colors) {
    return Container(
      color: colors.secondaryTextColor.withValues(alpha: 0.1),
      child: Icon(
        Icons.person,
        color: colors.secondaryTextColor.withValues(alpha: 0.5),
        size: 20,
      ),
    );
  }
}
