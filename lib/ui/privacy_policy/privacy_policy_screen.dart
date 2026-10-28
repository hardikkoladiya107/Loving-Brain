import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/manager/subscription_manager/subscription_utils.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasFallbackLoaded = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            final bool isMainFrame = error.isForMainFrame ?? true;
            if (isMainFrame) {
              if (!_hasFallbackLoaded) {
                _hasFallbackLoaded = true;
                _controller.loadFlutterAsset('assets/html/privacy_policy.html');
              } else {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                    _hasError = true;
                  });
                }
              }
            }
          },
        ),
      );

    _loadContent();
  }

  void _loadContent() {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _hasFallbackLoaded = false;
      });
    }

    final Uri? uri = Uri.tryParse(privacyPolicyUrl);
    if (uri != null && uri.hasScheme && uri.host.isNotEmpty) {
      _controller.loadRequest(uri);
    } else {
      _hasFallbackLoaded = true;
      _controller.loadFlutterAsset('assets/html/privacy_policy.html');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFFEF8F4),
      body: Stack(
        children: <Widget>[
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: primaryColor)),
          if (_hasError)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(LucideIcons.wifiOff, size: 48.sp, color: greyColor),
                    16.spaceH,
                    "Unable to load Privacy Policy".appText(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: darkBlue,
                    ),
                    8.spaceH,
                    "Please check your connection and try again.".appText(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: greyColor,
                      textAlign: TextAlign.center,
                    ),
                    24.spaceH,
                    AppButton(title: "Retry", onTap: _loadContent),
                  ],
                ),
              ),
            ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: _appBar().appPadding(top: 10.h, left: 20.w),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        BaseButton(
          onTap: () => context.pop(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
          ),
        ),
      ],
    );
  }
}
