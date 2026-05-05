import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_state_model.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/home/bloc/home_cubit.dart';
import 'package:loving_brain/ui/home/bloc/home_state.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

class FamilyMeterStatePickerScreen extends StatefulWidget {
  const FamilyMeterStatePickerScreen({super.key});

  @override
  State<FamilyMeterStatePickerScreen> createState() =>
      _FamilyMeterStatePickerScreenState();
}

class _FamilyMeterStatePickerScreenState
    extends State<FamilyMeterStatePickerScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (BuildContext context, HomeState state) {},
      builder: (BuildContext context, HomeState state) {
        final String childName = state.childModel?.childName ?? 'Child';
        return Scaffold(
          backgroundColor: const Color(0xFFF7F7FB),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF2F2A44),
            title: 'How is $childName right now?'.appText(
              fontWeight: FontWeight.w900,
              fontSize: 18.sp,
              color: const Color(0xFF2F2A44),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                children:
                    <_StateChoice>[
                      _StateChoice(
                        state: ChildState.calm,
                        icon: Icons.eco_rounded,
                      ),
                      _StateChoice(
                        state: ChildState.highEnergy,
                        icon: Icons.bolt_rounded,
                      ),
                      _StateChoice(
                        state: ChildState.fussy,
                        icon: Icons.cloud_rounded,
                      ),
                      _StateChoice(
                        state: ChildState.tired,
                        icon: Icons.nightlight_round,
                      ),
                    ].map((_StateChoice choice) {
                      return BaseButton(
                        onTap: () => _saveState(choice.state),
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: 80.h,
                            minWidth: 80.w,
                          ),
                          decoration: BoxDecoration(
                            color: choice.state.lightColor,
                            borderRadius: BorderRadius.circular(18.r),
                            border: Border.all(
                              color: choice.state.color.withValues(alpha: 0.5),
                              width: 1.3,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                choice.icon,
                                color: choice.state.color,
                                size: 36.sp,
                              ),
                              10.h.spaceH,
                              choice.state.label.appText(
                                fontWeight: FontWeight.w900,
                                color: choice.state.color,
                                fontSize: 15.sp,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveState(ChildState childState) async {
    EasyLoading.show();
    final ApiResultStatus apiResultStatus = await context
        .read<HomeCubit>()
        .updateFamilyMeterState(childState: childState);
    EasyLoading.dismiss();
    apiResultStatus.whenOrNull(
      data: (dynamic data) async {
        if (!mounted) {
          return;
        }
        context.pop();
        await Future<void>.delayed(const Duration(milliseconds: 80));
        await showSnackBar(
          message: 'State updated successfully.',
          type: SnackBarType.SUCCESS,
        );
      },
      error: (dynamic error) async {
        await showSnackBar(
          message: error.toString().replaceAll('Exception: ', ''),
          type: SnackBarType.ERROR,
        );
      },
    );
  }
}

class _StateChoice {
  const _StateChoice({required this.state, required this.icon});

  final ChildState state;
  final IconData icon;
}
