import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/brainy_conversation_cubit.dart';
import 'bloc/brainy_conversation_state.dart';

class BrainyConversationScreen extends StatefulWidget {
  const BrainyConversationScreen({super.key});

  @override
  State<BrainyConversationScreen> createState() =>
      _BrainyConversationScreenState();
}

class _BrainyConversationScreenState extends State<BrainyConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrainyConversationCubit()..init(),
      child: BlocBuilder<BrainyConversationCubit, BrainyConversationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFFEF8F4),
            body: Stack(
              children: [
                // Top Left Glow
                Positioned(
                  left: -150,
                  top: -150,
                  child: Container(
                    width: 400,
                    height: 400,
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
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Material(
                            color: Colors.transparent,
                            child: Ink(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(24),
                                onTap: () => Navigator.pop(context),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: darkBlue,
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                          itemCount:
                              state.messages.length + (state.isTyping ? 1 : 0),
                          separatorBuilder: (_, __) => 16.spaceH,
                          itemBuilder: (context, index) {
                            if (index == state.messages.length) {
                              return _buildTypingIndicator();
                            }
                            final msg = state.messages[index];
                            return _buildMessageCardFromData(msg);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: _controller,
                                hint: "Ask Brainy...",
                                tfType: TFTYPE.FILLED,
                                filled: true,
                                fillColor: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                contentPadding: EdgeInsets.only(
                                  left: 20.w,
                                  right: 20.w,
                                  top: 0.h,
                                  bottom: 6.h,
                                ),
                                onSubmitted: (val) {
                                  context
                                      .read<BrainyConversationCubit>()
                                      .sendMessage(val);
                                  _controller.clear();
                                  _scrollToBottom();
                                },
                              ),
                            ),
                            12.spaceW,
                            Material(
                              color: Colors.transparent,
                              child: Ink(
                                decoration: const BoxDecoration(
                                  color: secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(24),
                                  onTap: () {
                                    context
                                        .read<BrainyConversationCubit>()
                                        .sendMessage(_controller.text);
                                    _controller.clear();
                                    _scrollToBottom();
                                  },
                                  child: SizedBox(
                                    width: 56.w,
                                    height: 56.w,
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                      size: 24.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageCardFromData(BrainyMessage msg) {
    IconData icon;
    Color chipColor;
    Color chipBgColor;

    switch (msg.type) {
      case MessageType.user:
        icon = Icons.stars;
        chipColor = primaryColor;
        chipBgColor = orangeLightColor;
        break;
      case MessageType.aiInfo:
        icon = Icons.info;
        chipColor = primaryColor;
        chipBgColor = orangeLightColor;
        break;
      case MessageType.aiAction:
        icon = Icons.stars;
        chipColor = indigoLight;
        chipBgColor = const Color(0xFFE5E7EB);
        break;
    }

    return _buildMessageCard(
      chipTitle: msg.chipTitle,
      icon: icon,
      chipColor: chipColor,
      chipBgColor: chipBgColor,
      headline: msg.headline,
      subtext: msg.subtext,
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16.w,
            height: 16.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: primaryColor,
            ),
          ),
          12.spaceW,
          "Brainy is thinking...".appText(
            fontSize: 14.sp,
            color: greyColor,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard({
    required String chipTitle,
    required IconData icon,
    required Color chipColor,
    required Color chipBgColor,
    required String headline,
    String? subtext,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoChip(
            chipTitle: chipTitle,
            iconData: icon,
            color: chipColor,
            bgColor: chipBgColor,
          ),
          16.spaceH,
          headline.appText(
            fontSize: 22.sp,
            fraunces: true,
            textAlign: TextAlign.start,
            height: 1.2,
          ),
          if (subtext != null) ...[
            12.spaceH,
            subtext.appText(
              fontSize: 14.sp,
              color: greyColor,
              textAlign: TextAlign.start,
              height: 1.4,
            ),
          ],
        ],
      ),
    );
  }
}
