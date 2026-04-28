import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:loving_brain/model/essential_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/essentials/bloc/essentials_cubit.dart';
import 'package:loving_brain/ui/essentials/bloc/essentials_state.dart';
import 'package:loving_brain/ui/essentials/widgets/essential_note_dialog.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class EssentialsNotesSection extends StatelessWidget {
  const EssentialsNotesSection({required this.state, super.key});

  final EssentialsState state;

  @override
  Widget build(BuildContext context) {
    final List<EssentialNote> notes =
        state.childModel?.essentials ?? <EssentialNote>[];
    if (notes.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Icon(LucideIcons.fileText, color: Colors.grey.shade300, size: 48.w),
            12.h.spaceH,
            "No essentials added yet".appText(
              fontSize: 14.sp,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notes.length,
      separatorBuilder: (BuildContext context, int index) => 12.h.spaceH,
      itemBuilder: (BuildContext context, int index) {
        final EssentialNote note = notes[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: (note.title ?? "").appText(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      8.w.spaceW,
                      Row(
                        children: <Widget>[
                          _buildIconButton(
                            icon: LucideIcons.pencil,
                            color: primaryColor,
                            onTap: () => EssentialNoteDialog.show(
                              context,
                              state,
                              index: index,
                            ),
                          ),
                          8.w.spaceW,
                          _buildIconButton(
                            icon: LucideIcons.trash2,
                            color: Colors.redAccent,
                            onTap: () => context
                                .read<EssentialsCubit>()
                                .deleteEssentialNote(index: index),
                          ),
                        ],
                      ),
                    ],
                  ),
                  8.h.spaceH,
                  (note.description ?? "").appText(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return BaseButton(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 16.sp),
      ),
    );
  }
}
