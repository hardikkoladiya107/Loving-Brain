import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

import '../../../gen/assets.gen.dart';
import '../../../other/app_color.dart';
import '../../widget/app_text_field.dart';
import 'bloc/register_cubit.dart';
import 'bloc/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.v2.images.imgBg.path),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseButton(child: Assets.v2.icons.icBack.svg(), onTap: () {}),
                  "Let’s get you set up"
                      .appText(
                        fraunces: true,
                        fontSize: 28,
                        textAlign: TextAlign.start,
                      )
                      .appPadding(left: 20.r, right: 20.r),
                  "We only ask for what we need to make your first suggestion useful."
                      .appText(textAlign: TextAlign.start, fontSize: 14)
                      .appPadding(left: 20.r, right: 20.r),
                  21.spaceH,

                  AppTextField(
                    title: "Email",
                    hint: "Enter email",
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) {
                      context.read<RegisterCubit>().changeProps(
                        emailAddress: val,
                      );
                    },
                    error: state.emailAddressError.isNotEmpty
                        ? state.emailAddressError
                        : null,
                  ).appPadding(left: 20.r, right: 20.r),

                  32.spaceH,
                  Row(
                    children: [
                      Expanded(
                        child: Container(color: greyColor2, height: 1.r),
                      ),
                      12.spaceW,
                      "Or".appText(textAlign: TextAlign.start, fontSize: 14),
                      12.spaceW,
                      Expanded(
                        child: Container(color: greyColor2, height: 1.r),
                      ),
                    ],
                  ).appPadding(left: 20.r, right: 20.r),
                  32.spaceH,
                  AppButton(
                    onTap: () {},
                    backgroundColor: Colors.black,
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.v2.icons.icAppleIcon.image(
                          color: Colors.white,
                          height: 24.r,
                          width: 24.r,
                        ),
                        10.spaceW,
                        "Continue with Apple".appText(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  16.spaceH,
                  AppButton(
                    onTap: () {},
                    backgroundColor: Colors.black,
                    widget: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.v2.icons.icGoogleIcon.image(
                          height: 24.r,
                          width: 24.r,
                        ),
                        10.spaceW,
                        "Continue with Apple".appText(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  AppButton(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      context.read<RegisterCubit>().sendOtp();
                    },

                    title: "Continue",
                    isLoading: state.isAuthSubmitting,
                  ),
                  32.spaceH,
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        state.apiResultStatus.whenOrNull(
          data: (data) {
            context.push(RoutePaths.otp, extra: state.emailAddress);
            context.read<RegisterCubit>().changeProps(
              apiResultStatus: const ApiResultStatus.initial(),
            );
          },
          error: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString().replaceAll("Exception: ", "")),
              ),
            );
            context.read<RegisterCubit>().changeProps(
              apiResultStatus: const ApiResultStatus.initial(),
            );
          },
        );
      },
    );
  }
}
