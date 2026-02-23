import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:loving_brain/ui/widget/app_image.dart';
import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../main.dart';
import '../../model/journal_model.dart';
import '../../other/app_color.dart';
import '../../other/extra_methods.dart';
import '../../other/snack_bar.dart';
import '../chat_detail/chat_detail_screen.dart';
import '../thought_list/thought_list_scren.dart';
import 'bloc/write_your_thought_cubit.dart';
import 'bloc/write_your_thought_state.dart';

class WriteYourThoughtScreen extends StatefulWidget {
  const WriteYourThoughtScreen({super.key});

  @override
  State<WriteYourThoughtScreen> createState() => _WriteYourThoughtScreenState();
}

class _WriteYourThoughtScreenState extends State<WriteYourThoughtScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<WriteYourThoughtCubit>().init();
    });
  }

  final TextEditingController yourThoughtsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WriteYourThoughtCubit, WriteYourThoughtState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.imgWriteYourThoughtBg.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 24.h,
                  bottom: 32.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _header(),
                    16.h.spaceH,
                    _description(),
                    24.h.spaceH,
                    _typeYourThoughtsHere(state),
                    24.h.spaceH,
                    _actionButtons(state),
                    if (state.journalList.isNotEmpty) ...[
                      28.h.spaceH,
                      _pastEntriesSection(state),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        state.apiResultStatus.whenOrNull(
          initial: () {},
          loading: () {
            EasyLoading.show();
          },
          data: (data) {
            EasyLoading.dismiss();
            yourThoughtsController.clear();
            context.read<WriteYourThoughtCubit>().changeProps(thoughtsText: '');
          },
          error: (error) {
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
            EasyLoading.dismiss();
          },
        );
      },
    );
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.08),
            blurRadius: 24.r,
            offset: Offset(0, 8.h),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: LocaleKeys.writeYourThoughts.tr().appText(
        color: primaryColor,
        fontWeight: FontWeight.w800,
        fontSize: 22.sp,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _description() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.06),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.05),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: "${LocaleKeys.hi.tr()}, ${LocaleKeys.howYourHeartTodayTakeMomentReflect.tr()}"
          .appText(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: blackTextColor,
            height: 1.45,
            textAlign: TextAlign.center,
          ),
    );
  }

  Widget _typeYourThoughtsHere(WriteYourThoughtState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.06),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: AppTextField(
        controller: yourThoughtsController,
        fillColor: Colors.transparent,
        filled: true,
        minLines: 6,
        contentPadding: EdgeInsets.all(20.w),
        hintStyle: getTextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          color: greyColor1,
        ),
        hint: LocaleKeys.typeYourThoughtsHere.tr(),
        error: state.thoughtsErrorText,
        maxLines: 8,
        onChanged: (value) {
          context.read<WriteYourThoughtCubit>().changeProps(thoughtsText: value);
        },
      ),
    );
  }

  Widget _actionButtons(WriteYourThoughtState state) {
    return Row(
      children: [
        Expanded(
          child: BaseButton(
            onTap: () {
              context.read<WriteYourThoughtCubit>().logThought();
            },
            child: Container(
              height: 52.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    yellowColor3,
                    yellowColor2,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(26.r),
                boxShadow: [
                  BoxShadow(
                    color: yellowColor3.withValues(alpha: 0.4),
                    blurRadius: 12.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Center(
                child: LocaleKeys.saveEntry.tr().appText(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        16.w.spaceW,
        Expanded(
          child: BaseButton(
            onTap: () {
              if (context.read<WriteYourThoughtCubit>().isValidate()) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatDetailScreen(
                      initialChat: state.thoughtsText,
                    ),
                  ),
                );
              }
            },
            child: Container(
              height: 52.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(26.r),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.08),
                    blurRadius: 12.r,
                    offset: Offset(0, 4.h),
                  ),
                ],
              ),
              child: Center(
                child: LocaleKeys.getAIReflection.tr().appText(
                  color: primaryColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pastEntriesSection(WriteYourThoughtState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LocaleKeys.yourPastEntries.tr().appText(
              fontWeight: FontWeight.w800,
              fontSize: 17.sp,
              color: primaryColor,
            ),
            BaseButton(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ThoughtListScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: LocaleKeys.viewAll.tr().appText(
                  color: primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ),
        16.h.spaceH,
        ListView.separated(
          itemCount: state.journalList.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => 12.h.spaceH,
          itemBuilder: (context, index) {
            final JournalModel journal = state.journalList[index];
            return _pastEntryCard(journal: journal);
          },
        ),
      ],
    );
  }

  Widget _pastEntryCard({required JournalModel journal}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.06),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.calendar_today_rounded,
                  size: 16.sp,
                  color: primaryColor,
                ),
              ),
              10.w.spaceW,
              convertToMMMMDYYYY(journal.logTime).appText(
                fontWeight: FontWeight.w700,
                fontSize: 13.sp,
                color: primaryColor,
              ),
            ],
          ),
          14.h.spaceH,
          if ((journal.imageUrl ?? '').isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: AppImage(
                imageUrl: journal.imageUrl!,
                height: 180.h,
                width: double.infinity,
                boxFit: BoxFit.cover,
              ),
            ),
            14.h.spaceH,
          ],
          if ((journal.prompt ?? '').isNotEmpty) ...[
            'Prompt: ${journal.prompt}'.appText(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              color: blackTextColor,
              textAlign: TextAlign.start,
            ),
            8.h.spaceH,
          ],
          if ((journal.thoughtText ?? '').isNotEmpty &&
              journal.thoughtText != 'Drawing Entry' &&
              !(journal.thoughtText ?? '')
                  .startsWith('Drawn from Connect & Play:'))
            (journal.thoughtText ?? '').appText(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              textAlign: TextAlign.start,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              color: blackTextColor,
              height: 1.4,
            ),
        ],
      ).appPadding(all: 16),
    );
  }

  @override
  void dispose() {
    yourThoughtsController.dispose();
    if (navigatorKey.currentContext != null) {
      navigatorKey.currentContext!.read<WriteYourThoughtCubit>().dispose();
    }
    super.dispose();
  }
}
