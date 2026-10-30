import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loving_brain/router/route_paths.dart';
import 'package:loving_brain/ui/widget/alert_bottom_sheet.dart';
import 'package:loving_brain/ui/widget/offline_banner.dart';

class StatesGalleryScreen extends StatefulWidget {
  const StatesGalleryScreen({super.key});

  @override
  State<StatesGalleryScreen> createState() => _StatesGalleryScreenState();
}

class _StatesGalleryScreenState extends State<StatesGalleryScreen> {
  bool _isOffline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF1E293B)),
        title: const Text(
          "Key Screen States",
          style: TextStyle(color: Color(0xFF1E293B)),
        ),
      ),
      body: Column(
        children: [
          OfflineBanner(isVisible: _isOffline),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                SwitchListTile(
                  title: const Text("Toggle Global Offline Banner"),
                  value: _isOffline,
                  onChanged: (bool val) => setState(() => _isOffline = val),
                  activeThumbColor: const Color(0xFF5C6BC0),
                ),
                const Divider(),
                _buildSection("Alert Bottom Sheets"),
                _buildLink(
                  context,
                  "Error State",
                  () => AlertBottomSheet.showError(context),
                ),
                _buildLink(
                  context,
                  "Safety Concern",
                  () => AlertBottomSheet.showSafetyConcern(context),
                ),

                const Divider(),
                _buildSection("Consent / Permissions"),
                _buildLink(
                  context,
                  "Family Sharing Consent",
                  () => context.push(RoutePaths.familySharingConsent),
                ),
                _buildLink(
                  context,
                  "Microphone Permission",
                  () => context.push(RoutePaths.microphonePermission),
                ),
                _buildLink(
                  context,
                  "Notifications Permission",
                  () => context.push(RoutePaths.notificationsPermission),
                ),

                const Divider(),
                _buildSection("Data Context States"),
                _buildLink(
                  context,
                  "No Data State (Sleep)",
                  () => context.push(RoutePaths.sleepNoData),
                ),
                _buildLink(
                  context,
                  "Low Confidence State (Sleep)",
                  () => context.push(RoutePaths.sleepLowConfidence),
                ),
                _buildLink(
                  context,
                  "Service Unavailable (Mentorship)",
                  () => context.push(RoutePaths.mentorshipUnavailable),
                ),

                const Divider(),
                _buildSection("Skeleton Loaders"),
                _buildLink(
                  context,
                  "Loading Skeleton Screen",
                  () => context.push(RoutePaths.loadingSkeleton),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildLink(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
