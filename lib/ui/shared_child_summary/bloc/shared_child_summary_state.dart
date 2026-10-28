import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'shared_child_summary_state.freezed.dart';

class HandoverLogItem {
  final String authorName;
  final bool isPartner;
  final String actionDescription;
  final String timeAgo;

  const HandoverLogItem({
    required this.authorName,
    required this.isPartner,
    required this.actionDescription,
    required this.timeAgo,
  });
}

@freezed
abstract class SharedChildSummaryState with _$SharedChildSummaryState {
  const factory SharedChildSummaryState({
    @Default(false) bool isLoading,
    @Default('your child') String childName,
    @Default('Co-Parent') String partnerName,
    @Default('Wind-down at 7:30 PM') String todaysPlanTitle,
    @Default('Sleep window 7:45 – 8:15 PM.') String todaysPlanSubtitle,
    @Default(<HandoverLogItem>[]) List<HandoverLogItem> recentUpdates,
    @Default('Move bedtime 15 minutes earlier and protect calm wind-down.')
    String activeWeeklyFocus,
    @Default(
      'Both seeing the same picture. Health notes and private reflections remain private by default.',
    )
    String handoverNote,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
  }) = _SharedChildSummaryState;
}
