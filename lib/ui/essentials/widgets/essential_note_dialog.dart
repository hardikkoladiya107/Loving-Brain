import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/essential_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/essentials/bloc/essentials_cubit.dart';
import 'package:loving_brain/ui/essentials/bloc/essentials_state.dart';
import 'package:loving_brain/ui/widget/app_dialogs.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:go_router/go_router.dart';

class EssentialNoteDialog {
  static void show(BuildContext context, EssentialsState state, {int? index}) {
    final bool isEdit = index != null;
    final int noteIndex = index ?? -1;
    EssentialNote? essentialNote;
    if (isEdit && state.childModel?.essentials != null) {
      final List<EssentialNote> notes = state.childModel!.essentials!;
      if (noteIndex >= 0 && noteIndex < notes.length) {
        essentialNote = notes[noteIndex];
      }
    }
    final TextEditingController titleController = TextEditingController(
      text: essentialNote?.title ?? "",
    );
    final TextEditingController descriptionController = TextEditingController(
      text: essentialNote?.description ?? "",
    );

    showAppDialog(
      child: (BuildContext dialogContext) {
        return BlocBuilder<EssentialsCubit, EssentialsState>(
          builder: (BuildContext context, EssentialsState state) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.84),
                      borderRadius: BorderRadius.circular(32.r),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isEdit
                                    ? LucideIcons.pencil
                                    : LucideIcons.filePlus,
                                color: primaryColor,
                                size: 20.sp,
                              ),
                            ),
                            12.w.spaceW,
                            (isEdit
                                    ? LocaleKeys.save.tr()
                                    : LocaleKeys.addEssentialNote.tr())
                                .appText(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black87,
                                ),
                          ],
                        ),
                        20.h.spaceH,
                        AppTextField(
                          title: LocaleKeys.essentialTitle.tr(),
                          hint: LocaleKeys.enterEssentialTitle.tr(),
                          controller: titleController,
                          error: state.titleError,
                        ),
                        AppTextField(
                          title: LocaleKeys.essentialDescription.tr(),
                          hint: LocaleKeys.enterEssentialDescription.tr(),
                          minLines: 4,
                          maxLines: 8,
                          controller: descriptionController,
                          error: state.descriptionError,
                        ),
                        24.h.spaceH,
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: BaseButton(
                                onTap: () => dialogContext.pop(),
                                child: Container(
                                  height: 52.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                      color: Colors.grey.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: LocaleKeys.cancel.tr().appText(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black54,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ),
                            12.w.spaceW,
                            Expanded(
                              child: BaseButton(
                                onTap: () {
                                  if (isEdit) {
                                    context
                                        .read<EssentialsCubit>()
                                        .editEssentialNote(
                                          noteIndex,
                                          title: titleController.text,
                                          description:
                                              descriptionController.text,
                                        );
                                  } else {
                                    context
                                        .read<EssentialsCubit>()
                                        .addEssentialNote(
                                          title: titleController.text,
                                          description:
                                              descriptionController.text,
                                        );
                                  }
                                },
                                child: Container(
                                  height: 52.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: <Color>[
                                        primaryColor,
                                        Color(0xFFB185DB),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20.r),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: primaryColor.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child:
                                      (isEdit
                                              ? LocaleKeys.save
                                              : LocaleKeys.addEssentialNote)
                                          .tr()
                                          .appText(
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            fontSize: 15.sp,
                                          ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
