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
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Row(), 250.spaceH, _header(), 20.spaceH],
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
                                .whatAreSomeTipsForConsistentInfantSleep
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
                                .whatAreSomeTipsForConsistentInfantSleep
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
                    text: LocaleKeys.howCanIHandleToddlerTantrumInPublic.tr(), onTap: () {
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

  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: "I’m here to assist you, Sarah!"
          .appText(fontWeight: FontWeight.w700, fontSize: 14)
          .appPadding(left: 10, right: 10, top: 2, bottom: 2),
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
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            10.spaceH,
            LocaleKeys.whatAreSomeTipsForConsistentInfantSleep
                .tr()
                .appText(fontSize: 12)
                .appPadding(left: 10.w, right: 10.w),
          ],
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
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            10.spaceH,
            text.appText(fontSize: 12).appPadding(left: 10.w, right: 10.w),
          ],
        ),
      ),
    );
  }

  Widget _bottomTextField(AiChatState state) {
    return Positioned(
      right: 20,
      bottom: 0,
      left: 20,
      child: AppTextField(
        tfType: TFTYPE.FILLED,
        controller: textEditingController,
        onChanged: (value) {
          context.read<AiChatCubit>().changeProps(chatText: value);
        },
        hint: LocaleKeys.connectWithBrainAI.tr(),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        prefixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            10.spaceW,
            Icon(Icons.mic_outlined),
            10.spaceW,
            Icon(Icons.image_outlined),
            10.spaceW,
          ],
        ),
        suffixIcon: BaseButton(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [10.spaceW, Icon(Icons.search), 10.spaceW],
          ),
          onTap: () {
            if ((state.chatText ?? "").isNotEmpty) {
              var chatText = state.chatText;
              context.read<AiChatCubit>().changeProps(chatText: "");
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(initialChat: chatText),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _chatListButton() {
    return Positioned(
      right: 20,
      top: 40,
      child: BaseButton(
        child: Icon(Icons.list_outlined),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ChatListScreen()),
          );
        },
      ),
    );
  }
}
