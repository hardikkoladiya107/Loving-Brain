import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/services/chapter_book_pdf_exporter.dart';
import 'package:loving_brain/ui/journal/bloc/journal_state.dart';
import 'package:share_plus/share_plus.dart';

class ChapterBookTab extends StatelessWidget {
  const ChapterBookTab({super.key, required this.state});

  final JournalState state;

  static const List<String> _chapterKeys = <String>[
    'chapterBook1',
    'chapterBook2',
    'chapterBook3',
    'chapterBook4',
    'chapterBook5',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(20.w),
      itemCount: _chapterKeys.length + 1,
      separatorBuilder: (BuildContext context, int index) => 10.h.spaceH,
      itemBuilder: (BuildContext context, int index) {
        if (index == _chapterKeys.length) {
          return _exportButton(context);
        }
        final int chapterNumber = index + 1;
        final String key = _chapterKeys[index];
        final bool unlocked = state.unlockedChapters.contains(chapterNumber);
        return _chapterTile(
          title: key.tr(),
          locked: !unlocked,
          milestoneCount: state.milestones
              .where((m) => m.chapter == chapterNumber)
              .length,
        );
      },
    );
  }

  Widget _chapterTile({
    required String title,
    required bool locked,
    required int milestoneCount,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFECE8F8)),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            locked ? Icons.lock_rounded : Icons.menu_book_rounded,
            color: locked ? const Color(0xFF9A8FB8) : const Color(0xFF6A24B8),
          ),
          12.w.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                title.appText(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.sp,
                  color:
                      locked ? const Color(0xFF9A8FB8) : const Color(0xFF2F2A44),
                ),
                if (!locked && milestoneCount > 0)
                  LocaleKeys.chapterMemoryCount
                      .tr(
                        namedArgs: <String, String>{
                          'count': '$milestoneCount',
                        },
                      )
                      .appText(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        color: const Color(0xFF6A5A9A),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _exportButton(BuildContext context) {
    final bool canExport = state.exportUnlocked;
    return GestureDetector(
      onTap: () async {
        if (!canExport) {
          await showSnackBar(
            message: LocaleKeys.chapterBookExportLocked.tr(),
            type: SnackBarType.None,
          );
          return;
        }
        if (state.childModel == null || state.milestones.isEmpty) {
          await showSnackBar(
            message: LocaleKeys.somethingWentWrong.tr(),
            type: SnackBarType.ERROR,
          );
          return;
        }
        await _exportChapterBookPdf(context);
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF1ECFF),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              canExport ? Icons.download_rounded : Icons.lock_rounded,
              color: const Color(0xFF6A24B8),
            ),
            8.w.spaceW,
            LocaleKeys.chapterBookExport.tr().appText(
              fontWeight: FontWeight.w900,
              fontSize: 14.sp,
              color: const Color(0xFF6A24B8),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportChapterBookPdf(BuildContext context) async {
    EasyLoading.show();
    try {
      final File file = await ChapterBookPdfExporter.buildAndSave(
        childModel: state.childModel!,
        userModel: state.userModel,
        milestones: state.milestones,
      );
      EasyLoading.dismiss();
      await SharePlus.instance.share(
        ShareParams(
          files: <XFile>[XFile(file.path)],
          text: LocaleKeys.chapterBookShareText.tr(),
        ),
      );
      await showSnackBar(
        message: LocaleKeys.chapterBookExportSuccess.tr(),
        type: SnackBarType.SUCCESS,
      );
    } catch (error) {
      EasyLoading.dismiss();
      await showSnackBar(
        message: error.toString().replaceAll('Exception: ', ''),
        type: SnackBarType.ERROR,
      );
    }
  }
}
