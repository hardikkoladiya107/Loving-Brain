import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/ui/family_sharing_consent/family_sharing_consent_screen.dart';
import 'package:loving_brain/ui/mentorship_unavailable/mentorship_unavailable_screen.dart';
import 'package:loving_brain/ui/microphone_permission/microphone_permission_screen.dart';
import 'package:loving_brain/ui/notifications_permission/notifications_permission_screen.dart';
import 'package:loving_brain/ui/sleep_low_confidence/sleep_low_confidence_screen.dart';
import 'package:loving_brain/ui/sleep_no_data/sleep_no_data_screen.dart';
import 'package:loving_brain/ui/widget/alert_bottom_sheet.dart';
import 'package:loving_brain/ui/widget/offline_banner.dart';
import 'package:loving_brain/ui/widget/skeleton_loader.dart';

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
                  onChanged: (val) => setState(() => _isOffline = val),
                  activeColor: const Color(0xFF5C6BC0),
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
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FamilySharingConsentScreen(),
                    ),
                  ),
                ),
                _buildLink(
                  context,
                  "Microphone Permission",
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MicrophonePermissionScreen(),
                    ),
                  ),
                ),
                _buildLink(
                  context,
                  "Notifications Permission",
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPermissionScreen(),
                    ),
                  ),
                ),

                const Divider(),
                _buildSection("Data Context States"),
                _buildLink(
                  context,
                  "No Data State (Sleep)",
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SleepNoDataScreen(),
                    ),
                  ),
                ),
                _buildLink(
                  context,
                  "Low Confidence State (Sleep)",
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SleepLowConfidenceScreen(),
                    ),
                  ),
                ),
                _buildLink(
                  context,
                  "Service Unavailable (Mentorship)",
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MentorshipUnavailableScreen(),
                    ),
                  ),
                ),

                const Divider(),
                _buildSection("Skeleton Loaders"),
                _buildLink(
                  context,
                  "Loading Skeleton Screen",
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoadingSkeletonScreen(),
                    ),
                  ),
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
