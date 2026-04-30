import 'package:go_router/go_router.dart';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/main.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/essentials/widgets/essential_note_dialog.dart';
import 'package:loving_brain/ui/essentials/widgets/essentials_documents_section.dart';
import 'package:loving_brain/ui/essentials/widgets/essentials_notes_section.dart';
import 'package:loving_brain/ui/widget/app_dropdown.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import 'bloc/essentials_cubit.dart';
import 'bloc/essentials_state.dart';

class EssentialsScreen extends StatefulWidget {
  const EssentialsScreen({super.key});

  @override
  State<EssentialsScreen> createState() => _EssentialsScreenState();
}

class _EssentialsScreenState extends State<EssentialsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EssentialsCubit>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EssentialsCubit, EssentialsState>(
      listener: (BuildContext context, EssentialsState state) {
        state.addEssentialsApiResult.whenOrNull(
          data: (dynamic data) {
            EasyLoading.dismiss();
            Navigator.of(context, rootNavigator: true).maybePop();
          },
          error: (dynamic error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll("Exception: ", ""),
              type: SnackBarType.ERROR,
            );
          },
          loading: () => EasyLoading.show(),
        );
        state.childrenListApiResult.whenOrNull(
          data: (dynamic data) => EasyLoading.dismiss(),
          error: (dynamic error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll("Exception: ", ""),
              type: SnackBarType.ERROR,
            );
          },
          loading: () => EasyLoading.show(),
        );
        state.uploadDocumentApiResultStatus.whenOrNull(
          data: (dynamic data) => EasyLoading.dismiss(),
          error: (dynamic error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll("Exception: ", ""),
              type: SnackBarType.ERROR,
            );
          },
          loading: () => EasyLoading.show(),
        );
      },
      builder: (BuildContext context, EssentialsState state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: const Color(0xFFFAFAFA),
          body: Stack(
            children: <Widget>[
              _buildAuroraBackground(),
              _buildGlassOverlay(),
              _essentialsBody(state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuroraBackground() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: -100.h,
          left: -50.w,
          child: Container(
            width: 350.w,
            height: 350.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF894BCD).withValues(alpha: 0.18),
            ),
          ),
        ),
        Positioned(
          top: 150.h,
          right: -100.w,
          child: Container(
            width: 300.w,
            height: 300.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFF66C4).withValues(alpha: 0.12),
            ),
          ),
        ),
        Positioned(
          bottom: -50.h,
          left: -80.w,
          child: Container(
            width: 400.w,
            height: 400.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF5271FF).withValues(alpha: 0.10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassOverlay() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Container(color: Colors.white.withValues(alpha: 0.35)),
      ),
    );
  }

  Widget _essentialsBody(EssentialsState state) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            sliver: SliverToBoxAdapter(child: _appBar(state)),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  16.h.spaceH,
                  _buildSectionHeader(state),
                  20.h.spaceH,
                  _addNotesButton(state),
                  16.h.spaceH,
                  _buildSectionTitle("Daily Essentials"),
                  EssentialsNotesSection(state: state),
                  24.h.spaceH,
                  _buildSectionTitle(LocaleKeys.attachedDocuments.tr()),
                  EssentialsDocumentsSection(
                    childModel: state.childModel,
                    onUploadTap: _chooseImage,
                  ),
                  100.h.spaceH,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar(EssentialsState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        BaseButton(
          onTap: () => context.pop(),
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Icon(
              LucideIcons.chevronLeft,
              color: Colors.black87,
              size: 24.sp,
            ),
          ),
        ),
        _buildChildSelector(state),
      ],
    );
  }

  Widget _buildChildSelector(EssentialsState state) {
    return AppDropDownButton(
      offset: Offset(0, 48.h),
      dropdownWidth: 180.w,
      dropDownWidget: (Function close) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: state.childList.map((child) {
                  final bool isSelected =
                      state.childModel?.reference?.id == child.reference?.id;
                  return BaseButton(
                    onTap: () {
                      context.read<EssentialsCubit>().changeProps(
                        childModel: child,
                      );
                      context.read<EssentialsCubit>().fetchChildFromFirestore(
                        refVal: child.reference,
                      );
                      close.call();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryColor.withValues(alpha: 0.1)
                            : Colors.transparent,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black.withValues(alpha: 0.05),
                            width: 1,
                          ),
                        ),
                      ),
                      child: (child.childName ?? "").appText(
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                        fontSize: 14.sp,
                        color: isSelected ? primaryColor : Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
      child: Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            (state.childModel?.childName ?? LocaleKeys.pleaseSelectChild.tr())
                .appText(
                  fontWeight: FontWeight.w800,
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
            8.w.spaceW,
            Icon(LucideIcons.chevronDown, size: 16.sp, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(EssentialsState state) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF894BCD), Color(0xFFB185DB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF894BCD).withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              LucideIcons.shieldCheck,
              color: Colors.white,
              size: 22.sp,
            ),
          ),
          14.w.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                (state.childModel?.childName ?? LocaleKeys.child.tr()).appText(
                  fontWeight: FontWeight.w900,
                  fontSize: 24.sp,
                  color: Colors.white,
                ),
                4.h.spaceH,
                LocaleKeys.sharedInformationBothParentsSamePage.tr().appText(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: Colors.white.withValues(alpha: 0.88),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: title.toUpperCase().appText(
        textAlign: TextAlign.start,
        fontWeight: FontWeight.w800,
        fontSize: 11.sp,
        letterSpacing: 1.5,
        color: Colors.grey.shade500,
      ),
    );
  }

  Widget _addNotesButton(EssentialsState state) {
    return BaseButton(
      onTap: () {
        context.read<EssentialsCubit>().changeProps(
          descriptionError: "",
          titleError: "",
          addEssentialsApiResult: ApiResultStatus.initial(),
        );
        EssentialNoteDialog.show(context, state);
      },
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[primaryColor, Color(0xFFB185DB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(LucideIcons.plusCircle, color: Colors.white, size: 22.sp),
            12.w.spaceW,
            LocaleKeys.addEssentialNote.tr().appText(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _chooseImage() async {
    final FilePickerResult? filePickerResult = await FilePicker.platform
        .pickFiles(allowMultiple: false);
    final String? selectedPath = filePickerResult?.paths.first;
    if (selectedPath != null && selectedPath.isNotEmpty) {
      navigatorKey.currentContext
          ?.read<EssentialsCubit>()
          .uploadToFirebaseStorage(selectedPath);
    }
  }
}
