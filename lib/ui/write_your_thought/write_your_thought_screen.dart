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
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  Assets.images.imgWriteYourThoughtBg.path,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    top: 16.h,
                    bottom: 120.h, // Prevent bottom pill cover
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header(),
                      8.h.spaceH,
                      _description(),
                      32.h.spaceH,
                      _typeYourThoughtsHere(state),
                      32.h.spaceH,
                      _actionButtons(state),
                      if (state.journalList.isNotEmpty) ...[
                        40.h.spaceH,
                        _pastEntriesSection(state),
                      ],
                    ],
                  ),
                ),
              ),
            ],
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
    return LocaleKeys.writeYourThoughts.tr().appText(
      color: primaryColor,
      fontWeight: FontWeight.w900,
      fontSize: 28.sp,
      letterSpacing: 0.2,
    );
  }

  Widget _description() {
    return "${LocaleKeys.hi.tr()}, ${LocaleKeys.howYourHeartTodayTakeMomentReflect.tr()}"
        .appText(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          height: 1.4,
          textAlign: TextAlign.start,
        );
  }

  Widget _typeYourThoughtsHere(WriteYourThoughtState state) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(32.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20.r,
                spreadRadius: 0,
              ),
            ],
          ),
          child: AppTextField(
            controller: yourThoughtsController,
            fillColor: Colors.transparent,
            filled: true,
            minLines: 8,
            contentPadding: EdgeInsets.all(24.w),
            hintStyle: getTextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15.sp,
              color: greyColor1.withValues(alpha: 0.7),
            ),
            hint: LocaleKeys.typeYourThoughtsHere.tr(),
            error: state.thoughtsErrorText,
            maxLines: 12,
            onChanged: (value) {
              context.read<WriteYourThoughtCubit>().changeProps(thoughtsText: value);
            },
          ),
        ),
      ),
    );
  }

  Widget _actionButtons(WriteYourThoughtState state) {
    return Column(
      children: [
        BaseButton(
          onTap: () {
            context.read<WriteYourThoughtCubit>().logThought();
          },
          child: Container(
            width: double.infinity,
            height: 58.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [orangeColorStart, orangeColorEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: orangeColorEnd.withValues(alpha: 0.4),
                  blurRadius: 16.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            child: Center(
              child: LocaleKeys.saveEntry.tr().appText(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
        16.h.spaceH,
        BaseButton(
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
            width: double.infinity,
            height: 58.h,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome_rounded, color: primaryColor, size: 22.sp),
                8.w.spaceW,
                LocaleKeys.getAIReflection.tr().appText(
                  color: primaryColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ],
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
              fontWeight: FontWeight.w900,
              fontSize: 19.sp,
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
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: LocaleKeys.viewAll.tr().appText(
                  color: primaryColor,
                  fontWeight: FontWeight.w800,
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
          separatorBuilder: (context, index) => 16.h.spaceH,
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
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.9),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor.withValues(alpha: 0.8), primaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8.r,
                      offset: Offset(0, 4.h),
                    )
                  ],
                ),
                child: Icon(
                  Icons.calendar_month_rounded,
                  size: 16.sp,
                  color: Colors.white,
                ),
              ),
              12.w.spaceW,
              convertToMMMMDYYYY(journal.logTime).appText(
                fontWeight: FontWeight.w800,
                fontSize: 14.sp,
                color: primaryColor,
              ),
            ],
          ),
          16.h.spaceH,
          if ((journal.imageUrl ?? '').isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: AppImage(
                imageUrl: journal.imageUrl!,
                height: 200.h,
                width: double.infinity,
                boxFit: BoxFit.cover,
              ),
            ),
            16.h.spaceH,
          ],
          if ((journal.prompt ?? '').isNotEmpty) ...[
            'Prompt: ${journal.prompt}'.appText(
              fontWeight: FontWeight.w800,
              fontSize: 13.sp,
              color: primaryColor,
              textAlign: TextAlign.start,
            ),
            8.h.spaceH,
          ],
          if ((journal.thoughtText ?? '').isNotEmpty &&
              journal.thoughtText != 'Drawing Entry' &&
              !(journal.thoughtText ?? '')
                  .startsWith('Drawn from Connect & Play:'))
            (journal.thoughtText ?? '').appText(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              textAlign: TextAlign.start,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              color: Colors.black87,
              height: 1.5,
            ),
        ],
      ).appPadding(all: 20),
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
