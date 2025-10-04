import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

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
                      155.spaceH,
                      _header(),
                      20.spaceH,
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
                              width: 150.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: yellowColor3,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: LocaleKeys.saveEntry.tr().appText(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
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
                              width: 150.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: yellowColor3,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: LocaleKeys.getAIReflection.tr().appText(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
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
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: LocaleKeys.writeYourThoughts
          .tr()
          .appText(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          )
          .appPadding(left: 10, right: 10, top: 6, bottom: 6),
    );
  }

  Widget _description() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child:
          "${LocaleKeys.hi.tr()}, ${LocaleKeys.howYourHeartTodayTakeMomentReflect.tr()}"
              .appText(fontSize: 9, fontWeight: FontWeight.w800)
              .appPadding(left: 10, right: 10, top: 6, bottom: 6),
    ).appPadding(left: 16, right: 16);
  }

  Widget _typeYourThoughtsHere(WriteYourThoughtState state) {
    return AppTextField(
      controller: yourThoughtsController,
      fillColor: Colors.grey.withValues(alpha: 0.4),
      filled: true,
      minLines: 5,
      contentPadding: EdgeInsets.only(top: 16, left: 16),
      hintStyle: getTextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      hint: LocaleKeys.typeYourThoughtsHere.tr(),
      error: state.thoughtsErrorText,
      maxLines: 5,
      onChanged: (value) {
        context.read<WriteYourThoughtCubit>().changeProps(thoughtsText: value);
      },
    ).appPadding(left: 20, right: 20);
  }

  Widget _pastEntry({required Color color, required JournalModel journal}) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.spaceH,
          convertToMMMMDYYYY(
            journal.logTime,
          ).appText(fontWeight: FontWeight.w700, fontSize: 11),
          6.spaceH,
          (journal.thoughtText ?? "").appText(
            fontWeight: FontWeight.w600,
            fontSize: 11,
            textAlign: TextAlign.start,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          /*8.spaceH,
          "\"Parenting is not about perfection, but connection.\"".appText(
            fontWeight: FontWeight.w800,
            fontSize: 11,
            textAlign: TextAlign.center,
          ),*/
          8.spaceH,
        ],
      ).appPadding(left: 10.w, right: 10.w),
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
