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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<WriteYourThoughtCubit>().init();
    });
    super.initState();
  }

  TextEditingController yourThoughtsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WriteYourThoughtCubit, WriteYourThoughtState>(
      builder: (context, state) {
        yourThoughtsController.text = state.thoughtsText;
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.images.imgWriteYourThoughtBg.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Assets.images.imgWriteYourThoughtBg.image(
                        height: context.height,
                        width: context.width,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: context.height / 2,
                        width: context.width,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      130.spaceH,
                      _header(),
                      10.spaceH,
                      _description(),
                      20.spaceH,
                      _typeYourThoughtsHere(state),
                      20.spaceH,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BaseButton(
                            onTap: () {
                              context
                                  .read<WriteYourThoughtCubit>()
                                  .logThought();
                            },
                            child: Container(
                              width: 145.w,
                              height: 44.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [yellowColor3, yellowColor3],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Center(
                                child: LocaleKeys.saveEntry.tr().appText(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          BaseButton(
                            onTap: () {
                              if (context
                                  .read<WriteYourThoughtCubit>()
                                  .isValidate()) {
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
                              width: 145.w,
                              height: 44.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [yellowColor3, yellowColor3],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Center(
                                child: LocaleKeys.getAIReflection.tr().appText(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ).appPadding(left: 20, right: 20),

                      if (state.journalList.isNotEmpty) ...[
                        16.spaceH,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LocaleKeys.yourPastEntries.tr().appText(
                              fontWeight: FontWeight.w800,
                            ),
                            BaseButton(
                              child: LocaleKeys.viewAll.tr().appText(
                                color: primaryColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ThoughtListScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ).appPadding(left: 20, right: 20),
                        16.spaceH,
                        ListView.builder(
                          itemCount: state.journalList.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            var journal = state.journalList[index];
                            return _pastEntry(
                              color: Colors.pink,
                              journal: journal,
                            ).appPadding(bottom: 10);
                          },
                        ),
                      ],
                    ],
                  ),
                ],
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
            context.read<WriteYourThoughtCubit>().changeProps(thoughtsText: "");
          },
          error: (error) {
            showSnackBar(message: error.toString(), type: SnackBarType.ERROR);
            EasyLoading.dismiss();
          },
        );
      },
    );
    return Scaffold();
  }

  Widget _header() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: LocaleKeys.writeYourThoughts
          .tr()
          .appText(
            color: primaryColor,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          )
          .appPadding(left: 20, right: 20, top: 10, bottom: 10),
    );
  }

  Widget _description() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child:
          "${LocaleKeys.hi.tr()}, ${LocaleKeys.howYourHeartTodayTakeMomentReflect.tr()}"
              .appText(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              )
              .appPadding(left: 16, right: 16, top: 10, bottom: 10),
    ).appPadding(left: 16, right: 16);
  }

  Widget _typeYourThoughtsHere(WriteYourThoughtState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // Softer shadow
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: AppTextField(
        controller: yourThoughtsController,
        fillColor: Colors.transparent,
        filled: true,
        minLines: 6,
        contentPadding: EdgeInsets.all(16),
        hintStyle: getTextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
          color: Colors.grey[600],
        ),
        hint: LocaleKeys.typeYourThoughtsHere.tr(),
        error: state.thoughtsErrorText,
        maxLines: 8,
        onChanged: (value) {
          context.read<WriteYourThoughtCubit>().changeProps(
            thoughtsText: value,
          );
        },
      ),
    ).appPadding(left: 20, right: 20);
  }

  Widget _pastEntry({required Color color, required JournalModel journal}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: primaryColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: primaryColor,
              ),
              8.spaceW,
              convertToMMMMDYYYY(journal.logTime).appText(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: primaryColor,
              ),
            ],
          ),
          12.spaceH,
          if ((journal.imageUrl ?? "").isNotEmpty) ...[
             ClipRRect(
               borderRadius: BorderRadius.circular(12),
               child: AppImage(
                 imageUrl: journal.imageUrl!,
                 height: 150.h,
                 width: double.infinity,
                 fit: BoxFit.cover,
               ),
             ),
             12.spaceH,
          ],
          if ((journal.prompt ?? "").isNotEmpty) ...[
             "Prompt: ${journal.prompt}".appText(
               fontWeight: FontWeight.w600,
               fontSize: 12,
               color: Colors.black87,
               textAlign: TextAlign.start,
             ),
             8.spaceH,
          ],
          if ((journal.thoughtText ?? "").isNotEmpty)
          (journal.thoughtText ?? "").appText(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            textAlign: TextAlign.start,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            color: Colors.black87,
          ),
          /*8.spaceH,
          "\"Parenting is not about perfection, but connection.\"".appText(
            fontWeight: FontWeight.w800,
            fontSize: 11,
            textAlign: TextAlign.center,
          ),*/
        ],
      ).appPadding(all: 12),
    ).appPadding(left: 20.w, right: 20.w);
  }

  @override
  void dispose() {
    if (navigatorKey.currentContext != null) {
      navigatorKey.currentContext!.read<WriteYourThoughtCubit>().dispose();
    }
    super.dispose();
  }
}
