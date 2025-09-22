import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/other/app_extentions.dart';

import '../../generated/locale_keys.g.dart';
import '../../model/journal_model.dart';
import '../../other/extra_methods.dart';
import 'bloc/thought_list_cubit.dart';
import 'bloc/thought_list_state.dart';

class ThoughtListScreen extends StatefulWidget {
  const ThoughtListScreen({super.key});

  @override
  State<ThoughtListScreen> createState() => _ThoughtListScreenState();
}

class _ThoughtListScreenState extends State<ThoughtListScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ThoughtListCubit>().init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThoughtListCubit, ThoughtListState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: LocaleKeys.thoughtsList.tr().appText(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          body: ListView.builder(
            itemCount: state.journalList.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              var journal = state.journalList[index];
              return _pastEntry(
                color: Colors.pink,
                journal: journal,
              ).appPadding(bottom: 10);
            },
          ),
        );
      },
      listener: (context, state) {},
    );
  }

  Widget _pastEntry({required Color color, required JournalModel journal}) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          8.spaceH,
          convertToMMMMDYYYY(
            journal.logTime,
          ).appText(fontWeight: FontWeight.w700, fontSize: 11),
          6.spaceH,
          (journal.thoughtText ?? "").appText(
            fontWeight: FontWeight.w600,
            fontSize: 11,
            textAlign: TextAlign.start,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
          /*8.spaceH,
          "\"Parenting is not about perfection, but connection.\"".appText(
            fontWeight: FontWeight.w800,
            fontSize: 11,
            textAlign: TextAlign.center,
          ),*/
          8.spaceH,
        ],
      ).appPadding(left: 10.w, right: 10.w),
    ).appPadding(left: 20.w, right: 20.w);
  }
}
