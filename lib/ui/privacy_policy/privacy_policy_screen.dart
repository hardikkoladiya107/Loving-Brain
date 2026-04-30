import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..loadFlutterAsset('assets/html/privacy_policy.html');
      
    // _controller = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..loadRequest(
    //     Uri.parse(
    //       'https://firebasestorage.googleapis.com/v0/b/hugsand-heart-u86wap.firebasestorage.app/o/other-important-document%2Fpivacy_policy.html?alt=media',
    //     ),
    //   );
  }

  // Future<void> _loadHtmlFromAssets() async {
  //   _controller.loadHtmlString(
  //     "https://firebasestorage.googleapis.com/v0/b/hugsand-heart-u86wap.firebasestorage.app/o/other-important-document%2Fpivacy_policy.html?alt=media",
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          _appBar().appPadding(top: 60, left: 20),
        ],
      ),
    );
  }

  Widget _appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BaseButton(
          onTap: () => Navigator.pop(context),
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
