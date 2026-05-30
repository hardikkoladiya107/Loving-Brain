import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/essentials/bloc/essentials_cubit.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:url_launcher/url_launcher.dart';

class EssentialsDocumentsSection extends StatelessWidget {
  const EssentialsDocumentsSection({
    required this.childModel,
    required this.onUploadTap,
    super.key,
  });

  final ChildModel? childModel;
  final VoidCallback onUploadTap;

  @override
  Widget build(BuildContext context) {
    final List<String> documents = childModel?.documents ?? <String>[];
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Column(
            children: <Widget>[
              if (documents.isNotEmpty) ...<Widget>[
                ListView.separated(
                  padding: EdgeInsets.all(12.w),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: documents.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(color: Colors.black.withValues(alpha: 0.05)),
                  itemBuilder: (BuildContext context, int index) =>
                      _fileNameWidget(context, documents, index),
                ),
              ] else ...<Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.h),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        LucideIcons.filePlus,
                        color: Colors.grey.shade300,
                        size: 40.w,
                      ),
                      8.h.spaceH,
                      LocaleKeys.noDocumentsAttached.tr().appText(
                        fontSize: 13.sp,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
              _uploadDocButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _uploadDocButton() {
    return BaseButton(
      onTap: onUploadTap,
      child: Container(
        height: 48.h,
        margin: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(LucideIcons.uploadCloud, color: primaryColor, size: 20.sp),
            10.w.spaceW,
            LocaleKeys.uploadDocument.tr().appText(
              color: primaryColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          ],
        ),
      ),
    );
  }

  Widget _fileNameWidget(
    BuildContext context,
    List<String> documents,
    int index,
  ) {
    final String fileUrl = documents[index];
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(LucideIcons.fileText, size: 20.sp, color: primaryColor),
        ),
        12.w.spaceW,
        Expanded(
          child: BaseButton(
            onTap: () async {
              if (!await launchUrl(Uri.parse(fileUrl))) {
                showSnackBar(
                  message: LocaleKeys.somethingWentWrong.tr(),
                  type: SnackBarType.ERROR,
                );
              }
            },
            child: fileUrl.firebaseFileName.appText(
              textAlign: TextAlign.start,
              fontSize: 14.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDecoration: TextDecoration.underline,
            ),
          ),
        ),
        BaseButton(
          onTap: () =>
              context.read<EssentialsCubit>().deleteDocument(index: index),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.trash2,
              size: 18.sp,
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }
}
