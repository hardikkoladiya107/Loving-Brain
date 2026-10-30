import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/mentorship_models.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/request_session_cubit.dart';
import 'bloc/request_session_state.dart';

/// Screen 47: Request a Session.
/// Conforms strictly to AGENTS.md Rules 3, 5, and 6.
class RequestSessionScreen extends StatefulWidget {
  final GuideProfileModel? guide;

  const RequestSessionScreen({super.key, this.guide});

  @override
  State<RequestSessionScreen> createState() => _RequestSessionScreenState();
}

class _RequestSessionScreenState extends State<RequestSessionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestSessionCubit>().init(guide: widget.guide);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestSessionCubit, RequestSessionState>(
      listener: (BuildContext context, RequestSessionState state) {
        state.saveStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) {
            EasyLoading.dismiss();
            showSnackBar(
              message: "Session request submitted successfully",
              type: SnackBarType.SUCCESS,
            );
            context.pushReplacement(
              RoutePaths.sessionConfirmation,
              extra: state.guide?.name ?? "your guide",
            );
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (BuildContext context, RequestSessionState state) {
        final RequestSessionCubit cubit = context.read<RequestSessionCubit>();
        final String guideName = state.guide?.name ?? "Priya";

        return Scaffold(
          backgroundColor: const Color(0xFFFEF8F4),
          body: Stack(
            children: [
              Positioned(
                left: -150.w,
                top: -150.h,
                child: Container(
                  width: 450.w,
                  height: 450.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                        const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () => context.pop(),
                          child: Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: darkBlue,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    24.spaceH,
                    "Request a session".appText(
                      fontSize: 28.sp,
                      color: darkBlue,
                      fraunces: true,
                      textAlign: TextAlign.start,
                    ),
                    8.spaceH,
                    "$guideName will confirm availability and come back to you."
                        .appText(
                          fontSize: 14.sp,
                          color: greyColor9,
                          textAlign: TextAlign.start,
                          height: 1.4,
                        ),
                    24.spaceH,
                    SessionField(
                      label: "MAIN CONCERN",
                      initialValue: state.mainConcern,
                      errorText: state.mainConcernError,
                      onChanged: cubit.updateMainConcern,
                      autoFocus: true,
                    ),
                    12.spaceH,
                    SessionField(
                      label: "CHILD AGE",
                      initialValue: state.childAge,
                      onChanged: cubit.updateChildAge,
                    ),
                    12.spaceH,
                    SessionField(
                      label: "PREFERRED DAYS / TIMES",
                      initialValue: state.preferredDays,
                      onChanged: cubit.updatePreferredDays,
                    ),
                    12.spaceH,
                    SessionField(
                      label: "PREFERRED LANGUAGE",
                      initialValue: state.preferredLanguage,
                      onChanged: cubit.updatePreferredLanguage,
                    ),
                    24.spaceH,
                    GestureDetector(
                      onTap: () =>
                          cubit.toggleShareSummary(!state.shareSummary),
                      child: Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFBEADB),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child:
                                  "We'll share your recent Loving Brain summary with $guideName so you don't have to explain from scratch. You can turn this off."
                                      .appText(
                                        fontSize: 14.sp,
                                        color: greyColor9,
                                        textAlign: TextAlign.start,
                                        height: 1.4,
                                      ),
                            ),
                            12.spaceW,
                            Switch(
                              value: state.shareSummary,
                              onChanged: cubit.toggleShareSummary,
                              activeThumbColor: Colors.white,
                              activeTrackColor: primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    180.spaceH,
                  ],
                ),
              ),
              _buildBottomActions(context, state, cubit),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    RequestSessionState state,
    RequestSessionCubit cubit,
  ) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: isKeyboardOpen ? 12.h : 24.h,
          bottom: isKeyboardOpen ? 10.h : 24.h,
          left: 20.w,
          right: 20.w,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFEF8F4).withValues(alpha: 0.0),
              const Color(0xFFFEF8F4),
              const Color(0xFFFEF8F4),
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              title: state.isSubmitting ? "Sending..." : "Send request",
              onTap: state.isSubmitting
                  ? () {}
                  : () {
                      cubit.submitRequest();
                    },
            ),
            16.spaceH,
            InkWell(
              onTap: () async {
                final String? rawUrl = state.guide?.calendarUrl;
                if (rawUrl != null && rawUrl.isNotEmpty) {
                  final Uri? uri = Uri.tryParse(rawUrl);
                  if (uri != null) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
              },
              child: "Or schedule directly via your guide's calendar link"
                  .appText(
                    fontSize: 14.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    textDecoration: TextDecoration.underline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class SessionField extends StatefulWidget {
  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final bool autoFocus;
  final String? errorText;

  const SessionField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.autoFocus = false,
    this.errorText,
  });

  @override
  State<SessionField> createState() => _SessionFieldState();
}

class _SessionFieldState extends State<SessionField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    if (widget.autoFocus) {
      _isFocused = true;
      _focusNode.requestFocus();
    }
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode.addListener(() {
      if (!mounted) return;
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void didUpdateWidget(SessionField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError =
        widget.errorText != null && widget.errorText!.isNotEmpty;
    final bool isValid = _controller.text.trim().isNotEmpty && !hasError;
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: 20.w,
          right: 16.w,
          top: 12.h,
          bottom: 8.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: hasError
                ? Colors.red
                : (_isFocused ? primaryColor : Colors.transparent),
            width: hasError || _isFocused ? 1.5.w : 0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.label.appText(
                    fontSize: 12.sp,
                    color: hasError
                        ? Colors.red
                        : greyColor9.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w700,
                  ),
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: (String val) {
                      setState(() {});
                      widget.onChanged(val);
                    },
                    maxLines: null,
                    textInputAction: TextInputAction.next,
                    style: getTextStyle(
                      fontSize: 16.sp,
                      color: darkBlue,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.only(top: 4.h, bottom: 8.h),
                      border: InputBorder.none,
                      hintStyle: getTextStyle(
                        fontSize: 16.sp,
                        color: greyColor4,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  if (hasError) ...[
                    4.spaceH,
                    widget.errorText!.appText(
                      fontSize: 12.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ],
              ),
            ),
            if (isValid)
              Icon(Icons.check_circle, color: primaryColor, size: 24.sp)
            else if (hasError)
              Icon(Icons.error_outline, color: Colors.red, size: 24.sp)
            else
              SizedBox(width: 24.sp, height: 24.sp),
          ],
        ),
      ),
    );
  }
}
