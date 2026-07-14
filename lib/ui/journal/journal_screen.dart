import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/generated/locale_keys.g.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/other/snack_bar.dart';
import 'package:loving_brain/ui/journal/bloc/journal_cubit.dart';
import 'package:loving_brain/ui/journal/bloc/journal_state.dart';
import 'package:loving_brain/ui/journal/widgets/chapter_book_tab.dart';
import 'package:loving_brain/ui/journal/widgets/journey_tab.dart';
import 'package:loving_brain/ui/journal/widgets/todays_log_tab.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JournalCubit>().init();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JournalCubit, JournalState>(
      listener: (BuildContext context, JournalState state) {
        state.loadStatus.whenOrNull(
          loading: () => EasyLoading.show(),
          data: (_) => EasyLoading.dismiss(),
          error: (Exception error) {
            EasyLoading.dismiss();
            showSnackBar(
              message: error.toString().replaceAll('Exception: ', ''),
              type: SnackBarType.ERROR,
            );
          },
        );
      },
      builder: (BuildContext context, JournalState state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F7FC),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: const Color(0xFF2F2A44),
            title: LocaleKeys.journal.tr().appText(
              fontWeight: FontWeight.w900,
              fontSize: 20.sp,
              color: const Color(0xFF2F2A44),
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF6A24B8),
              unselectedLabelColor: const Color(0xFF9A8FB8),
              indicatorColor: const Color(0xFF6A24B8),
              labelStyle: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 12.sp,
              ),
              tabs: <Widget>[
                Tab(text: LocaleKeys.journalTodaysLog.tr()),
                Tab(text: LocaleKeys.journalJourney.tr()),
                Tab(text: LocaleKeys.journalBook.tr()),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              TodaysLogTab(state: state),
              JourneyTab(state: state),
              ChapterBookTab(state: state),
            ],
          ),
        );
      },
    );
  }
}
