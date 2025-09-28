import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/conversation_list_item.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../chat_detail/chat_detail_screen.dart';
import '../widget/app_dialogs.dart';
import 'bloc/chat_list_cubit.dart';
import 'bloc/chat_list_state.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ChatListCubit>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatListCubit, ChatListState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                20.spaceH,
                _appBar(),
                10.spaceH,
                Expanded(
                  child: ListView.builder(
                    itemCount: state.conversationList.length,
                    itemBuilder: (context, index) {
                      var conversation = state.conversationList[index];
                      return _chatItem(conversation);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        state.getConversationsApiResult.whenOrNull(
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            showSnackBar(
              message: LocaleKeys.chatDeleted.tr(),
              type: SnackBarType.SUCCESS,
            );
            EasyLoading.dismiss();
          },
          error: (error) {
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
            EasyLoading.dismiss();
          },
        );
      },
    );
  }

  Widget _appBar() {
    return Row(
      children: [
        BaseButton(
          child: Assets.icons.icBackIcon.image(height: 36, width: 36),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        12.w.spaceW,
        LocaleKeys.chatHistory.tr().appText(fontWeight: FontWeight.w700),
      ],
    ).appPadding(left: 20);
  }

  Widget _chatItem(ConversationListItem conversation) {
    return BaseButton(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              offset: Offset(1, 1),
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: (conversation.firstMessage ?? "").appText(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
            8.spaceW,
            BaseButton(
              child: Icon(Icons.delete_outline, size: 16, color: Colors.red),
              onTap: () {
                _deleteChatDialog(conversation);
              },
            ),
            8.spaceW,
          ],
        ).appPadding(all: 12),
      ).appPadding(left: 20, right: 20),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ChatDetailScreen(conversationId: conversation.conversationId),
          ),
        );
      },
    ).appPadding(top: 10);
  }

  void _deleteChatDialog(ConversationListItem conversation) {
    showAppDialog(
      child: (context) {
        return Dialog(
          insetPadding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Container(
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Column(
              children: [
                20.h.spaceH,
                LocaleKeys.deleteChat.tr().appText(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                20.h.spaceH,
                LocaleKeys.areYouSureToDeleteChat.tr().appText(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                40.h.spaceH,
                Row(
                  children: [
                    20.w.spaceW,
                    Expanded(
                      child: BaseButton(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: LocaleKeys.cancel
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )
                              .appPadding(top: 10.h, bottom: 10.h),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    10.w.spaceW,
                    Expanded(
                      child: BaseButton(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: LocaleKeys.logOut
                              .tr()
                              .appText(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )
                              .appPadding(top: 10.h, bottom: 10.h),
                        ),
                        onTap: () {
                          if (conversation.conversationId != null) {
                            context.read<ChatListCubit>().deleteChat(
                              conversation.conversationId!,
                            );
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    20.w.spaceW,
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
