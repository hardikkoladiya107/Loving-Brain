import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import 'bloc/ai_chat_cubit.dart';
import 'bloc/ai_chat_state.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (mounted) {
        context.read<AiChatCubit>().init();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitIfNotEmpty(AiChatState state) {
    final String text = state.chatText.trim();
    if (text.isEmpty) {
      return;
    }
    context.read<AiChatCubit>().changeProps(chatText: '');
    _textController.clear();
    context.push(
      RoutePaths.chatDetail,
      extra: <String, dynamic>{'initialChat': text},
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AiChatCubit, AiChatState>(
      builder: (BuildContext context, AiChatState state) {
        if (_textController.text != state.chatText) {
          _textController.value = _textController.value.copyWith(
            text: state.chatText,
            selection: TextSelection.collapsed(offset: state.chatText.length),
          );
        }

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.imgAiChatBg.path),
            ),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(child: Center(child: _speechBubble(state))),
                      _historyButton(),
                    ],
                  ).appPadding(left: 16.w, right: 16.w, top: 16.h),
                  Spacer(),
                  Flexible(
                    child: _suggestionGrid(
                      state,
                    ).appPadding(left: 20.w, right: 20.w),
                  ),
                  _composerBar(state),
                ],
              ),
            ),
          ),
        );
      },
      listener: (BuildContext context, AiChatState state) {},
    );
  }

  Widget _speechBubble(AiChatState state) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
          constraints: BoxConstraints(maxWidth: 280.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.65),
              width: 1.5,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child:
              "I’m here to assist you, ${state.userModel?.parentName ?? "User"}!"
                  .appText(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: Colors.black87,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
        ),
      ),
    );
  }

  Widget _historyButton() {
    return BaseButton(
      onTap: () {
        context.push(RoutePaths.chatList);
      },
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.88),
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.75),
            width: 1.5,
          ),
        ),
        child: Icon(Icons.history_rounded, color: Colors.black87, size: 24.sp),
      ),
    );
  }

  Widget _suggestionGrid(AiChatState state) {
    final double cardMinHeight = 108.h;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: _suggestionCard(
                          minHeight: cardMinHeight,
                          color: aiQuestionCardColor1,
                          text: LocaleKeys.howCanIHandleToddlerTantrumInPublic
                              .tr(),
                          onTap: () => _pushPreset(
                            LocaleKeys.howCanIHandleToddlerTantrumInPublic.tr(),
                          ),
                        ),
                      ),
                      12.w.spaceW,
                      Expanded(
                        child: _suggestionCard(
                          minHeight: cardMinHeight,
                          color: aiQuestionCardColor2,
                          text: LocaleKeys
                              .whatAreSomeTipsForConsistentInfantSleep
                              .tr(),
                          onTap: () => _pushPreset(
                            LocaleKeys.whatAreSomeTipsForConsistentInfantSleep
                                .tr(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                12.h.spaceH,
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: _suggestionCard(
                          minHeight: cardMinHeight,
                          color: aiQuestionCardColor3,
                          text: LocaleKeys
                              .myNewbornIsCryingContinuouslyWhatStepsShouldITake
                              .tr(),
                          onTap: () => _pushPreset(
                            LocaleKeys
                                .myNewbornIsCryingContinuouslyWhatStepsShouldITake
                                .tr(),
                          ),
                        ),
                      ),
                      12.w.spaceW,
                      Expanded(
                        child: _suggestionCard(
                          minHeight: cardMinHeight,
                          color: aiQuestionCardColor4,
                          text: LocaleKeys
                              .howCanIEncourageMyChildExpressTheirFeelings
                              .tr(),
                          onTap: () => _pushPreset(
                            LocaleKeys
                                .howCanIEncourageMyChildExpressTheirFeelings
                                .tr(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _pushPreset(String initialChat) {
    context.push(
      RoutePaths.chatDetail,
      extra: <String, dynamic>{'initialChat': initialChat},
    );
  }

  Widget _suggestionCard({
    required double minHeight,
    required Color color,
    required String text,
    required VoidCallback onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: minHeight),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.75),
              width: 1,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -14.r,
                right: -14.r,
                child: Container(
                  height: 52.r,
                  width: 52.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.28),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 14.h,
                  ),
                  child: Center(
                    child: text.appText(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D2D2D),
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      height: 1.28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Single-line composer: text only; blocks newline input.
  Widget _composerBar(AiChatState state) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          height: 54.h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.9),
              width: 1.5,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 16.w, right: 6.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _textController,
                  maxLines: 1,
                  minLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  textInputAction: TextInputAction.send,
                  keyboardType: TextInputType.text,
                  style: getTextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xFF2D2D2D),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.deny(RegExp(r'[\n\r]')),
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    filled: false,
                    border: InputBorder.none,
                    hintText: LocaleKeys.connectWithBrainAI.tr(),
                    hintStyle: TextStyle(
                      color: greyColor1.withValues(alpha: 0.55),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 14.h,
                    ),
                  ),
                  onChanged: (String value) {
                    context.read<AiChatCubit>().changeProps(chatText: value);
                  },
                  onSubmitted: (_) => _submitIfNotEmpty(state),
                ),
              ),
              BaseButton(
                onTap: () => _submitIfNotEmpty(state),
                child: Container(
                  margin: EdgeInsets.only(right: 2.w),
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.38),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 21.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).appPadding(bottom: 10.h, right: 16.r, left: 16.r);
  }
}
