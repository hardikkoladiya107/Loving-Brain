import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/content/milestone_content.dart';
import 'package:loving_brain/core/age_utils.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/ai_response_model.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/conversation_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/repo/ai_repo.dart';
import 'package:loving_brain/repo/milestone_repo.dart';
import 'package:loving_brain/ui/home/bloc/home_cubit.dart';
import 'package:loving_brain/ui/home/bloc/home_state.dart';
import 'package:loving_brain/ui/journal/bloc/journal_cubit.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class MilestoneStoryScreen extends StatefulWidget {
  const MilestoneStoryScreen({super.key, this.milestoneKey});

  final String? milestoneKey;

  @override
  State<MilestoneStoryScreen> createState() => _MilestoneStoryScreenState();
}

class _MilestoneStoryScreenState extends State<MilestoneStoryScreen> {
  MilestoneDefinition? _milestone;
  String _storyText = '';
  bool _loadingStory = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMilestone());
  }

  Future<void> _loadMilestone() async {
    final HomeState homeState = context.read<HomeCubit>().state;
    final String childName = homeState.childModel?.childName ?? 'your child';
    final String parentName = homeState.userModel?.parentName ?? 'Parent';
    final int ageInMonths = AgeUtils.resolvedAgeInMonths(
      dob: homeState.childModel?.childDob,
      legacyAgeText: homeState.childModel?.childAge ?? '',
    );
    MilestoneDefinition? milestone;
    if ((widget.milestoneKey ?? '').isNotEmpty) {
      milestone = await MilestoneContent.resolveByKey(
        milestoneKey: widget.milestoneKey!,
        childName: childName,
        parentName: parentName,
        ageInMonths: ageInMonths,
      );
    }
    milestone ??= await MilestoneContent.resolveForAge(
      childName: childName,
      parentName: parentName,
      ageInMonths: ageInMonths,
    );
    if (mounted) {
      setState(() {
        _milestone = milestone;
      });
    }
  }

  Future<void> _generateAndSaveStory() async {
    if (_milestone == null || _loadingStory || _saved) {
      return;
    }
    final HomeState homeState = context.read<HomeCubit>().state;
    final String childId = homeState.childModel?.reference?.id ?? '';
    final String uid = homeState.userModel?.uid ?? '';
    if (childId.isEmpty || uid.isEmpty) {
      await showSnackBar(
        message: LocaleKeys.somethingWentWrong.tr(),
        type: SnackBarType.ERROR,
      );
      return;
    }
    setState(() {
      _loadingStory = true;
    });
    EasyLoading.show();
    final ApiResultStatus response = await AiRepo.instance.createResponse(
      conversationId: 'milestone-${DateTime.now().millisecondsSinceEpoch}',
      messageText: _milestone!.storyPrompt,
      systemPrompt:
          'You are a gentle storyteller for LovingBrain parents. Write in second person to the parent. Never use age comparison language.',
    );
    String generatedText = '';
    response.whenOrNull(
      data: (dynamic data) {
        final AiResponseModel aiResponse =
            AiResponseModel.fromJson(data as Map<String, dynamic>);
        final List<ConversationItem> output =
            aiResponse.output ?? <ConversationItem>[];
        if (output.isNotEmpty &&
            (output.first.content ?? <AIContent>[]).isNotEmpty) {
          generatedText = output.first.content!.first.text ?? '';
        }
      },
      error: (Exception error) {
        EasyLoading.dismiss();
        showSnackBar(
          message: error.toString().replaceAll('Exception: ', ''),
          type: SnackBarType.ERROR,
        );
        setState(() {
          _loadingStory = false;
        });
      },
    );
    if (generatedText.trim().isEmpty) {
      EasyLoading.dismiss();
      setState(() {
        _loadingStory = false;
      });
      await showSnackBar(
        message: LocaleKeys.somethingWentWrong.tr(),
        type: SnackBarType.ERROR,
      );
      return;
    }
    final int ageInMonths = AgeUtils.resolvedAgeInMonths(
      dob: homeState.childModel?.childDob,
      legacyAgeText: homeState.childModel?.childAge ?? '',
    );
    final ApiResultStatus<String> saveResult =
        await MilestoneRepo.instance.saveMilestone(
      childId: childId,
      actorUid: uid,
      milestoneKey: _milestone!.key,
      title: _milestone!.title,
      whatThisMeans: _milestone!.whatThisMeans,
      storyText: generatedText,
      chapter: _milestone!.chapter,
      ageInMonths: ageInMonths,
    );
    EasyLoading.dismiss();
    saveResult.whenOrNull(
      data: (_) async {
        setState(() {
          _storyText = generatedText;
          _saved = true;
          _loadingStory = false;
        });
        context.read<JournalCubit>().reload();
        await showSnackBar(
          message: LocaleKeys.milestoneSavedSuccess.tr(),
          type: SnackBarType.SUCCESS,
        );
      },
      error: (Exception error) {
        setState(() {
          _loadingStory = false;
        });
        showSnackBar(
          message: error.toString().replaceAll('Exception: ', ''),
          type: SnackBarType.ERROR,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MilestoneDefinition? milestone = _milestone;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFF2F2A44),
        title: LocaleKeys.milestoneStory.tr().appText(
          fontWeight: FontWeight.w900,
          fontSize: 18.sp,
        ),
      ),
      body: SafeArea(
        child: milestone == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    milestone.title.appText(
                      fontWeight: FontWeight.w900,
                      fontSize: 22.sp,
                      color: const Color(0xFF2F2A44),
                    ),
                    8.h.spaceH,
                    LocaleKeys.whatThisMeans.tr().appText(
                      fontWeight: FontWeight.w800,
                      fontSize: 13.sp,
                      color: const Color(0xFF6A24B8),
                    ),
                    6.h.spaceH,
                    milestone.whatThisMeans.appText(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: const Color(0xFF504A67),
                    ),
                    20.h.spaceH,
                    Expanded(
                      child: SingleChildScrollView(
                        child: _storyText.isEmpty
                            ? LocaleKeys.milestoneStoryPrompt.tr().appText(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: const Color(0xFF6A5A9A),
                              )
                            : _storyText.appText(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                color: const Color(0xFF2F2A44),
                              ),
                      ),
                    ),
                    12.h.spaceH,
                    if (!_saved)
                      BaseButton(
                        onTap: _generateAndSaveStory,
                        child: Container(
                          width: double.infinity,
                          height: 52.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: <Color>[
                                Color(0xFF6A24B8),
                                Color(0xFF8F58D7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: LocaleKeys.iSawIt.tr().appText(
                            fontWeight: FontWeight.w900,
                            fontSize: 15.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    10.h.spaceH,
                    BaseButton(
                      onTap: () => context.pop(),
                      child: Container(
                        width: double.infinity,
                        height: 44.h,
                        alignment: Alignment.center,
                        child: LocaleKeys.done.tr().appText(
                          fontWeight: FontWeight.w800,
                          fontSize: 14.sp,
                          color: const Color(0xFF6A5A9A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
