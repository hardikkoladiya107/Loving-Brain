import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import 'bloc/otp_cubit.dart';
import 'bloc/otp_state.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, this.destination});

  final String? destination;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _otpLength = 4;
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List<TextEditingController>.generate(
      _otpLength,
      (_) => TextEditingController(),
    );
    _focusNodes = List<FocusNode>.generate(
      _otpLength,
      (int index) => FocusNode(
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            if (_controllers[index].text.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
              _controllers[index - 1].clear();
              _updateOtpFromControllers();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
      )..addListener(_onFocusChange),
    );

    WidgetsBinding.instance.addPostFrameCallback((Duration _) {
      if (!mounted) return;
      context.read<OtpCubit>().init(destination: widget.destination);
      _focusNodes[0].requestFocus();
    });
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    for (final FocusNode node in _focusNodes) {
      node.removeListener(_onFocusChange);
      node.dispose();
    }
    for (final TextEditingController controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateOtpFromControllers() {
    final String code = _controllers
        .map((TextEditingController c) => c.text)
        .join();
    context.read<OtpCubit>().onOtpChanged(code);
  }

  void _onDigitChanged(int index, String value) {
    final String cleanValue = value.replaceAll(RegExp(r'\D'), '');

    if (cleanValue.isEmpty) {
      _controllers[index].clear();
      _updateOtpFromControllers();
      return;
    }

    // Full paste: 4 or more digits
    if (cleanValue.length >= _otpLength) {
      for (int i = 0; i < _otpLength; i++) {
        _controllers[i].value = TextEditingValue(
          text: cleanValue[i],
          selection: const TextSelection.collapsed(offset: 1),
        );
      }
      _updateOtpFromControllers();
      _focusNodes[_otpLength - 1].requestFocus();
      return;
    }

    // Typing into an already filled box: replace with newly entered char
    if (cleanValue.length == 2) {
      final String newChar = cleanValue[cleanValue.length - 1];
      _controllers[index].value = TextEditingValue(
        text: newChar,
        selection: const TextSelection.collapsed(offset: 1),
      );
      _updateOtpFromControllers();
      if (index < _otpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      }
      return;
    }

    // Multi-digit paste into current position
    if (cleanValue.length > 2) {
      int targetIndex = index;
      for (
        int j = 0;
        j < cleanValue.length && targetIndex < _otpLength;
        j++, targetIndex++
      ) {
        _controllers[targetIndex].value = TextEditingValue(
          text: cleanValue[j],
          selection: const TextSelection.collapsed(offset: 1),
        );
      }
      _updateOtpFromControllers();
      if (targetIndex < _otpLength) {
        _focusNodes[targetIndex].requestFocus();
      } else {
        _focusNodes[_otpLength - 1].requestFocus();
      }
      return;
    }

    // Normal single digit input
    _controllers[index].value = TextEditingValue(
      text: cleanValue,
      selection: const TextSelection.collapsed(offset: 1),
    );
    _updateOtpFromControllers();
    if (index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else {
      _focusNodes[index].unfocus();
    }
  }

  void _selectBoxText(int index) {
    _controllers[index].selection = TextSelection(
      baseOffset: 0,
      extentOffset: _controllers[index].text.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtpCubit, OtpState>(
      listener: (BuildContext context, OtpState state) {
        state.verifyStatus.whenOrNull(
          loading: () {
            EasyLoading.show();
          },
          data: (dynamic _) {
            EasyLoading.dismiss();
            context.go(RoutePaths.base);
          },
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );

        state.resendStatus.whenOrNull(
          loading: () {
            EasyLoading.show();
          },
          data: (dynamic _) {
            EasyLoading.dismiss();
            showSnackBar(
              message: 'Verification code resent successfully',
              type: SnackBarType.SUCCESS,
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
      builder: (BuildContext context, OtpState state) {
        final String currentText = _controllers
            .map((TextEditingController c) => c.text)
            .join();
        if (state.otpCode != currentText) {
          if (state.otpCode.isEmpty) {
            for (final TextEditingController c in _controllers) {
              c.clear();
            }
          } else if (state.otpCode.length <= _otpLength) {
            for (int i = 0; i < _otpLength; i++) {
              final String char = i < state.otpCode.length
                  ? state.otpCode[i]
                  : '';
              if (_controllers[i].text != char) {
                _controllers[i].text = char;
              }
            }
          }
        }

        final String subtitle = state.destination.isNotEmpty
            ? "We’ve sent a 4 digit verification code to ${state.destination}."
            : "We’ve sent a 4 digit verification code to your mobile number.";

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.v2.images.imgBg.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BaseButton(
                    child: Assets.v2.icons.icBack.svg(),
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      }
                    },
                  ),
                  "Enter OTP"
                      .appText2(fontSize: 28, textAlign: TextAlign.start)
                      .appPadding(left: 20.r, right: 20.r),
                  subtitle
                      .appText(
                        textAlign: TextAlign.start,
                        fontSize: 14,
                        color: greyColor,
                      )
                      .appPadding(left: 20.r, right: 20.r),
                  28.spaceH,
                  Row(
                    children: <Widget>[
                      for (int i = 0; i < _otpLength; i++) ...<Widget>[
                        if (i > 0) 14.w.spaceW,
                        _OtpDigitBox(
                          controller: _controllers[i],
                          focusNode: _focusNodes[i],
                          hasError: state.otpError.isNotEmpty,
                          onChanged: (String value) =>
                              _onDigitChanged(i, value),
                          onTap: () => _selectBoxText(i),
                        ),
                      ],
                    ],
                  ).appPadding(left: 20.r, right: 20.r),
                  if (state.otpError.isNotEmpty) ...<Widget>[
                    10.spaceH,
                    state.otpError
                        .appText(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                          textAlign: TextAlign.start,
                        )
                        .appPadding(left: 20.r, right: 20.r),
                  ],
                  const Spacer(),
                  AppButton(
                    onTap: () {
                      context.read<OtpCubit>().verifyOtp(
                        onSuccess: () {
                          context.go(RoutePaths.base);
                        },
                      );
                    },
                    title: "Continue",
                  ),
                  32.spaceH,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OtpDigitBox extends StatelessWidget {
  const _OtpDigitBox({
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
    this.onTap,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isFocused = focusNode.hasFocus;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        focusNode.requestFocus();
        onTap?.call();
      },
      child: Container(
        width: 56.w,
        height: 56.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: hasError
                ? Colors.red.shade400
                : (isFocused ? primaryColor : Colors.transparent),
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          style: getTextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF212529),
          ),
          cursorColor: primaryColor,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            counterText: '',
          ),
          onChanged: onChanged,
          onTap: onTap,
        ),
      ),
    );
  }
}
