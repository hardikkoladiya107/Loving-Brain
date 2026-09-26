import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/onboarding/widgets/info_chip.dart';
import 'package:loving_brain/ui/widget/app_button.dart';

class ProgramRecommendationScreen extends StatefulWidget {
  const ProgramRecommendationScreen({super.key});

  @override
  State<ProgramRecommendationScreen> createState() =>
      _ProgramRecommendationScreenState();
}

class _ProgramRecommendationScreenState
    extends State<ProgramRecommendationScreen> {
  String selectedCategory = 'All';

  final List<Map<String, String>> _allPrograms = [
    {
      'image': Assets.v2.images.imgSleepRestore01.path,
      'title': "Sleep Restore",
      'subtitle': "6-week guided sleep programme",
      'price': "From ?2,400",
      'category': "Sleep",
    },
    {
      'image': Assets.v2.images.imgSleepRestore02.path,
      'title': "Gentle Awakening",
      'subtitle': "4-week guided sleep programme",
      'price': "From ?1,800",
      'category': "Sleep",
    },
    {
      'image': Assets.v2.images.imgSleepRestore03.path,
      'title': "Calm Moments",
      'subtitle': "Manage anxiety in toddlers",
      'price': "From ?3,200",
      'category': "Anxiety",
    },
    {
      'image': Assets.v2.images.imgSleepRestore04.path,
      'title': "Positive Discipline",
      'subtitle': "Effective parenting strategies",
      'price': "From ?2,800",
      'category': "Parenting",
    },
    {
      'image': Assets.v2.images.imgSleepRestore01.path,
      'title': "Tantrum Tamer",
      'subtitle': "Understanding big emotions",
      'price': "From ?2,000",
      'category': "Behaviour",
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredPrograms = _allPrograms.where((prog) {
      if (selectedCategory == 'All') return true;
      return prog['category'] == selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context),
          12.spaceH,
          _buildCategoryChips(),
          16.spaceH,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                if (filteredPrograms.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.h),
                    child: "No programs available in this category.".appText(
                      color: greyColor,
                      fontSize: 14.sp,
                    ),
                  )
                else
                  ...filteredPrograms.map(
                    (prog) => Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: _buildProgramCard(
                        prog['image']!,
                        prog['title']!,
                        prog['subtitle']!,
                        prog['price']!,
                      ),
                    ),
                  ),
                12.spaceH,
                _buildInfoCard(
                  "Why this is recommended",
                  "The changes you've tried haven't settled into a pattern yet. A guided sleep journey may help you build a more consistent routine.",
                ),
                16.spaceH,
                _buildInfoCard(
                  "What's included",
                  "A weekly plan, two sessions with a guide, and check-ins between them over six weeks.",
                ),
                32.spaceH,
                AppButton(
                  title: "View All programs",
                  onTap: () {},
                  backgroundColor: primaryColor,
                  textColor: Colors.white,
                ),
                16.spaceH,
                TextButton(
                  onPressed: () {},
                  child: "Not now".appText(
                    fontSize: 16.sp,
                    color: greyColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                100.spaceH,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 350,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(Assets.v2.images.imgSleepBackground.path),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            height: 150,
            width: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(
                  Assets.v2.images.imgNoriProgramRecommendation.path,
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: EdgeInsets.only(left: 16.w, top: 16.h),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back, color: darkBlue, size: 24.sp),
                ),
              ),
              32.spaceH,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Would some guided support help?".appText(
                      fontSize: 28.sp,
                      color: Colors.white,
                      fraunces: true,
                      textAlign: TextAlign.start,
                    ),
                    16.spaceH,
                    "Bedtime has been unsettled for two weeks now.".appText(
                      fontSize: 14.sp,
                      color: Colors.white.withValues(alpha: 0.8),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChips() {
    final categories = ['All', 'Sleep', 'Behaviour', 'Parenting', 'Anxiety'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: categories.map((cat) {
          final isSelected = cat == selectedCategory;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = cat;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? orangeLightColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : primaryColor,
                ),
              ),
              child: cat.appText(
                color: primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProgramCard(
    String imagePath,
    String title,
    String subtitle,
    String price,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(imagePath),
              ),
            ),
          ),
          12.spaceW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title.appText(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  textAlign: TextAlign.start,
                ),
                4.spaceH,
                subtitle.appText(
                  fontSize: 12.sp,
                  color: greyColor,
                  textAlign: TextAlign.start,
                ),
                8.spaceH,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    price.appText(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: "View program".appText(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String description) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: primaryColor, size: 16.sp),
              8.spaceW,
              title.appText(
                fontSize: 10.sp,
                fontWeight: FontWeight.w800,
                color: primaryColor,
                letterSpacing: 1.2,
              ),
            ],
          ),
          12.spaceH,
          description.appText(
            fontSize: 12.sp,
            color: greyColor,
            textAlign: TextAlign.start,
            height: 1.5,
          ),
        ],
      ),
    );
  }
}
