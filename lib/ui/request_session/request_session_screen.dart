import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/session_request_confirmation/session_request_confirmation_screen.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

import 'bloc/request_session_cubit.dart';
import 'bloc/request_session_state.dart';

class RequestSessionScreen extends StatelessWidget {
  const RequestSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RequestSessionCubit(),
      child: BlocBuilder<RequestSessionCubit, RequestSessionState>(
        builder: (context, state) {
          final cubit = context.read<RequestSessionCubit>();
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
            child: Scaffold(
              backgroundColor: const Color(0xFFFEF8F4),
              body: Stack(
                children: [
                  Positioned(
                    left: -150,
                    top: -150,
                    child: Container(
                      width: 450,
                      height: 450,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(12),
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
                        "Priya will confirm availability and come back to you."
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
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBEADB),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child:
                                "We'll share your recent LovingBrain summary with Priya so you don't have to explain from scratch. You can turn this off."
                                    .appText(
                                      fontSize: 14.sp,
                                      color: greyColor9,
                                      textAlign: TextAlign.start,
                                      height: 1.4,
                                    ),
                          ),
                        ),
                        180.spaceH,
                      ],
                    ),
                  ),
                  _buildBottomActions(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, RequestSessionState state) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 40.h,
          bottom: 32.h,
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
                  : () async {
                      final cubit = context.read<RequestSessionCubit>();
                      await cubit.submitRequest();
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const SessionRequestConfirmationScreen(),
                          ),
                        );
                      }
                    },
            ),
            16.spaceH,
            "Or schedule directly via Priya's calendar link".appText(
              fontSize: 14.sp,
              color: greyColor,
              fontWeight: FontWeight.w500,
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

  const SessionField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.autoFocus = false,
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
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isValid = _controller.text.trim().isNotEmpty;
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isFocused ? primaryColor : Colors.transparent,
            width: 1.5,
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
                    color: greyColor9.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w700,
                  ),
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: (val) {
                      setState(() {});
                      widget.onChanged(val);
                    },
                    maxLines: null,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: darkBlue,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                      fontFamily: 'Nunito',
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.only(top: 4.h, bottom: 8.h),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            if (isValid)
              Icon(Icons.check_circle, color: primaryColor, size: 24.sp)
            else
              SizedBox(width: 24.sp, height: 24.sp),
          ],
        ),
      ),
    );
  }
}
