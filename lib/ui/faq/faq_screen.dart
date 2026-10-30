import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqItem {
  final String category;
  final String question;
  final String answer;

  const FaqItem({
    required this.category,
    required this.question,
    required this.answer,
  });
}

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final Set<int> _expandedIndices = <int>{0};

  static const List<String> _categories = <String>[
    'All',
    'Sleep',
    'Tantrums',
    'Family sharing',
    'Medical',
  ];

  static const List<FaqItem> _allFaqs = <FaqItem>[
    FaqItem(
      category: 'Sleep',
      question: 'How does the sleep forecast predict bedtime and wake windows?',
      answer:
          'Loving Brain uses your child’s age in months and today’s logged naps to calculate healthy wake windows. When a nap is delayed or shorter than 45 minutes, our energy bridge prediction engine automatically shifts the recommended bedtime earlier to avoid overtiredness.',
    ),
    FaqItem(
      category: 'Sleep',
      question: 'What should I do if my child takes a short nap (<45 minutes)?',
      answer:
          'Short "catnaps" provide less restorative rest than full sleep cycles. Loving Brain automatically shortens the subsequent wake window and suggests beginning your wind-down routine 15 to 30 minutes earlier to prevent cortisol spikes and bedtime struggles.',
    ),
    FaqItem(
      category: 'Sleep',
      question:
          'How many sleep logs are needed for high prediction confidence?',
      answer:
          '3 to 9 logged sleep events achieve moderate confidence with 2 indicator dots. Once you log 10 or more sleeps, the forecast achieves high confidence with 3 dots and individualized prediction precision tailored to your child’s circadian rhythms.',
    ),
    FaqItem(
      category: 'Tantrums',
      question:
          'What is the difference between a tantrum and a sensory meltdown?',
      answer:
          'Tantrums are typically goal-oriented protests against a boundary where the child remains conscious of safety. A meltdown is nervous system sensory or emotional overload where logic and reasoning cannot be processed. Loving Brain helps you recognize early stress cues before overload occurs.',
    ),
    FaqItem(
      category: 'Tantrums',
      question: 'How does the Calm Plan guide me during high stress moments?',
      answer:
          'The Calm Plan is an evidence-based co-regulation protocol. It walks you through regulating your own nervous system first (calm breathing, slow vocal tone), reducing sensory stimulation, and offering grounding physical reassurance without overwhelming the child with verbal lectures.',
    ),
    FaqItem(
      category: 'Tantrums',
      question: 'Can I track behavioural triggers and calming tools?',
      answer:
          'Yes! When logging a tantrum or emotional peak, you can record triggers (hunger, fatigue, transitions, overstimulation) and log what helped soothe your child. Loving Brain highlights repeating patterns over time to help you prevent future meltdowns.',
    ),
    FaqItem(
      category: 'Family sharing',
      question: 'How do I invite a co-parent, spouse, or caregiver?',
      answer:
          'Navigate to Parent Profile, select "Invite Co-Parent", and enter their email address. They will receive an invitation link allowing them to join your family snapshot and view your child’s profile seamlessly.',
    ),
    FaqItem(
      category: 'Family sharing',
      question: 'Can multiple caregivers log sleep and meals simultaneously?',
      answer:
          'Yes. Loving Brain syncs data across all linked family members in real-time. If one parent logs offline without an internet connection, our offline sync engine automatically merges the log once connectivity is restored.',
    ),
    FaqItem(
      category: 'Family sharing',
      question: 'Do co-parents or caregivers need their own login?',
      answer:
          'Yes. Each adult signs in with their own Loving Brain account. An invited co-parent joins the same family and can see the shared child profile. This version of the app does not charge a subscription for that.',
    ),
    FaqItem(
      category: 'Medical',
      question:
          'Does Loving Brain replace professional pediatric medical advice?',
      answer:
          'No. Loving Brain offers clinically informed, evidence-based developmental and behavioural guidance. It does not provide medical diagnoses or replace consultations with pediatricians, therapists, or healthcare professionals.',
    ),
    FaqItem(
      category: 'Medical',
      question: 'What should I do in an acute emergency?',
      answer:
          'If your child experiences breathing distress, turning blue, seizures, or acute trauma, immediately call your local emergency services (911 or local emergency number). Loving Brain is not an emergency monitoring service.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FaqItem> get _filteredFaqs {
    final String query = _searchController.text.trim().toLowerCase();
    return _allFaqs.where((FaqItem item) {
      final bool matchesCategory =
          _selectedCategory == 'All' ||
          item.category.toLowerCase() == _selectedCategory.toLowerCase();
      final bool matchesQuery =
          query.isEmpty ||
          item.question.toLowerCase().contains(query) ||
          item.answer.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _toggleExpanded(int index) {
    setState(() {
      if (_expandedIndices.contains(index)) {
        _expandedIndices.remove(index);
      } else {
        _expandedIndices.add(index);
      }
    });
  }

  Future<void> _contactSupport() async {
    final Uri uri = Uri.parse(
      'mailto:support@lovingbrain.com?subject=FAQ Support Question',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final List<FaqItem> faqs = _filteredFaqs;

    return Scaffold(
      backgroundColor: const Color(0xFFFEF8F4),
      body: Stack(
        children: <Widget>[
          // Top Left Ambient Glow
          Positioned(
            left: -150.w,
            top: -150.h,
            child: Container(
              width: 400.w,
              height: 400.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    const Color(0xFFFFD4C8).withValues(alpha: 0.8),
                    const Color(0xFFFFD4C8).withValues(alpha: 0.0),
                  ],
                  stops: const <double>[0.0, 1.0],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Top bar with back button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 8.h,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        color: Colors.transparent,
                        child: Ink(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(24.r),
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding: EdgeInsets.all(8.r),
                              child: Icon(
                                Icons.arrow_back,
                                color: darkBlue,
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 40.h),
                      children: <Widget>[
                        'Frequently asked questions'.appText(
                          fontSize: 28.sp,
                          color: greyColor9,
                          fraunces: true,
                          textAlign: TextAlign.start,
                        ),
                        6.spaceH,
                        'Find clear answers to common questions about sleep forecasting, tantrums, family sharing, and billing.'
                            .appText(
                              fontSize: 13.sp,
                              color: greyColor6,
                              textAlign: TextAlign.start,
                            ),
                        16.spaceH,
                        // Search bar
                        AppTextField(
                          controller: _searchController,
                          hint: 'Search questions or keywords...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: greyColor4,
                            size: 20.sp,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: greyColor4,
                                    size: 18.sp,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                    });
                                  },
                                )
                              : null,
                          onChanged: (_) => setState(() {}),
                        ),
                        14.spaceH,
                        // Category Pills
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: _categories.map((String cat) {
                              final bool isSelected = _selectedCategory == cat;
                              return Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20.r),
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory = cat;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 14.w,
                                      vertical: 7.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? primaryColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(
                                        color: isSelected
                                            ? primaryColor
                                            : greyColor2,
                                        width: 1,
                                      ),
                                    ),
                                    child: cat.appText(
                                      fontSize: 12.sp,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : greyColor9,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        18.spaceH,
                        // FAQ List
                        if (faqs.isEmpty) ...<Widget>[
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(28.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: greyColor2),
                            ),
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.help_outline_rounded,
                                  size: 40.sp,
                                  color: greyColor4,
                                ),
                                12.spaceH,
                                'No matching questions found'.appText(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: greyColor9,
                                ),
                                6.spaceH,
                                'Try another search term or select "All" categories.'
                                    .appText(
                                      fontSize: 13.sp,
                                      color: greyColor6,
                                      textAlign: TextAlign.center,
                                    ),
                              ],
                            ),
                          ),
                        ] else ...<Widget>[
                          ...List<Widget>.generate(faqs.length, (int index) {
                            final FaqItem item = faqs[index];
                            final bool isExpanded = _expandedIndices.contains(
                              index,
                            );

                            return Container(
                              margin: EdgeInsets.only(bottom: 12.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18.r),
                                border: Border.all(
                                  color: isExpanded
                                      ? primaryColor.withValues(alpha: 0.35)
                                      : const Color(0xFFF0ECE9),
                                  width: 1,
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18.r),
                                onTap: () => _toggleExpanded(index),
                                child: Padding(
                                  padding: EdgeInsets.all(18.r),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8.w,
                                                    vertical: 3.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: orangeLightColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8.r,
                                                        ),
                                                  ),
                                                  child: item.category.appText(
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                                8.spaceH,
                                                item.question.appText(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: greyColor9,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ],
                                            ),
                                          ),
                                          8.spaceW,
                                          AnimatedRotation(
                                            turns: isExpanded ? 0.5 : 0.0,
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            child: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: isExpanded
                                                  ? primaryColor
                                                  : greyColor4,
                                              size: 24.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (isExpanded) ...<Widget>[
                                        12.spaceH,
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(top: 10.h),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                color: Color(0xFFF5EFEA),
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          child: item.answer.appText(
                                            fontSize: 13.sp,
                                            color: greyColor,
                                            textAlign: TextAlign.start,
                                            height: 1.45,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                        24.spaceH,
                        // Still Need Help card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20.r),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[
                                Color(0xFFFFEDE6),
                                Color(0xFFFFF6F0),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              'Still have questions?'.appText(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: darkBlue,
                                fraunces: true,
                              ),
                              6.spaceH,
                              'Our team is here to support you and your family. Reach out directly anytime.'
                                  .appText(
                                    fontSize: 12.sp,
                                    color: greyColor,
                                    textAlign: TextAlign.start,
                                  ),
                              16.spaceH,
                              AppButton(
                                title: 'Contact support',
                                backgroundColor: primaryColor,
                                textColor: Colors.white,
                                onTap: _contactSupport,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
