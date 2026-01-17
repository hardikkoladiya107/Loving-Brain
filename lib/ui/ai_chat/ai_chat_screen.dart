import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../other/app_color.dart';
import '../chat_detail/chat_detail_screen.dart';
import '../chat_list/chat_list_screen.dart';
import 'bloc/ai_chat_cubit.dart';
import 'bloc/ai_chat_state.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    context.read<AiChatCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AiChatCubit, AiChatState>(
      builder: (context, state) {
        if (textEditingController.text != state.chatText) {
          textEditingController.value = textEditingController.value.copyWith(
            text: state.chatText ?? '',
            selection: textEditingController.selection,
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
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                // Overlay for better text readability if needed
                Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.1)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Row(), 60.spaceH, _header(state), 20.spaceH],
                ),
                Positioned(
                  left: 20.w,
                  bottom: 100.h,
                  child: _verticalCard(
                    color: aiQuestionCardColor3,
                    text: LocaleKeys
                        .myNewbornIsCryingContinuouslyWhatStepsShouldITake
                        .tr(),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatDetailScreen(
                            initialChat: LocaleKeys
                                .myNewbornIsCryingContinuouslyWhatStepsShouldITake
                                .tr(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 20.w,
                  bottom: 100.h,
                  child: _horizontalCard(
                    color: aiQuestionCardColor4,
                    text: LocaleKeys.howCanIEncourageMyChildExpressTheirFeelings
                        .tr(),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatDetailScreen(
                            initialChat: LocaleKeys
                                .howCanIEncourageMyChildExpressTheirFeelings
                                .tr(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 20.w,
                  bottom: 300.h,
                  child: _horizontalCard(
                    color: aiQuestionCardColor1,
                    text: LocaleKeys.howCanIHandleToddlerTantrumInPublic.tr(),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatDetailScreen(
                            initialChat: LocaleKeys
                                .howCanIHandleToddlerTantrumInPublic
                                .tr(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 20.w,
                  bottom: 215.h,
                  child: _verticalCard(
                    color: aiQuestionCardColor2,
                    text: LocaleKeys.whatAreSomeTipsForConsistentInfantSleep
                        .tr(),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatDetailScreen(
                            initialChat: LocaleKeys
                                .whatAreSomeTipsForConsistentInfantSleep
                                .tr(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _chatListButton(),
                _bottomTextField(state),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _header(AiChatState state) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child:
              "I’m here to assist you, ${state.userModel?.parentName ?? "User"}!"
                  .appText(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
        ),
      ),
    );
  }

  Widget _verticalCard({
    required Color color,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 195.h,
        width: 140.w,
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 6),
              spreadRadius: 2,
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                top: -20,
                right: -20,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    text.appText(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,

                      textAlign: TextAlign.center,
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _horizontalCard({
    required Color color,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        height: 110.h,
        width: 205.w,
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 6),
              spreadRadius: 2,
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Center(
                  child: text.appText(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomTextField(AiChatState state) {
    return Positioned(
      right: 20,
      bottom: 20,
      left: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: AppTextField(
              tfType: TFTYPE.FILLED,
              fillColor: Colors.transparent,
              controller: textEditingController,
              onChanged: (value) {
                context.read<AiChatCubit>().changeProps(chatText: value);
              },
              hint: LocaleKeys.connectWithBrainAI.tr(),
              hintStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  16.spaceW,
                  Icon(Icons.mic_none_rounded, color: primaryColor),
                  12.spaceW,
                  Icon(Icons.image_outlined, color: primaryColor),
                  12.spaceW,
                ],
              ),
              suffixIcon: BaseButton(
                child: Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onTap: () {
                  if ((state.chatText ?? "").isNotEmpty) {
                    var chatText = state.chatText;
                    context.read<AiChatCubit>().changeProps(chatText: "");
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatDetailScreen(initialChat: chatText),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chatListButton() {
    return Positioned(
      right: 20,
      top: 60,
      child: BaseButton(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Icon(Icons.history_rounded, color: Colors.black87, size: 26),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ChatListScreen()),
          );
        },
      ),
    );
  }
}
