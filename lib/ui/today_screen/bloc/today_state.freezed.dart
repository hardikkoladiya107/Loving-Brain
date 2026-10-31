// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'today_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TodayState {

 bool get isLoading; bool get isSuccess; ApiResultStatus<dynamic> get saveStatus; String get activeChildId; TodayMode get mode; String get childName; String get parentName; String get timeOfDayGreeting; String get sleepForecastStart; String get sleepForecastEnd; String get bedtimeEstimate; String get forecastSubtitle; String get confidenceLevel; int get confidenceDots; String get sleepForecastReason; bool get hasSleepLogs; bool get hasMultiDayPatterns; bool get hasAnyLogs; int get loggedDaysCount; bool get didForecastChangeSignificantly; String get forecastChangeReason; SleepLogModel? get duplicateSleepLogDetected; bool get showHealthHeadsUp; String get healthHeadsUpTitle; String get healthHeadsUpSubtitle; bool get showBehaviourHeadsUp; String get headsUpHeadline; String get headsUpReason; String get headsUpWindowStart; String get headsUpWindowEnd; bool get showNiceWork; String get niceWorkTitle; String get niceWorkSubtitle; bool get showNoticed; String get noticedTitle; TodayNoticedDestination get noticedDestination; bool get showSupportOffer; int get supportInconsistentDays; String get onboardingFocusLine; bool get prioritiseSleepFirst; String get instantResultTitle; String get instantResultAction; String get instantResultActionSubtitle; String? get fellAsleepTime; String? get wokeUpTime; bool get includeNaps; List<NapDraft> get napDrafts; bool get showSleepUpdateErrors; int get selectedChildMoodIndex; String get selectedParentMood; bool get showMoodUpdateErrors; String get tantrumWhatHappened; String? get tantrumTime; double get tantrumIntensity; List<String> get selectedTantrumTriggers; String get tantrumWhatHelped; bool get showTantrumUpdateErrors; List<String> get selectedHealthIssues; String get healthNotes; bool get showHealthUpdateErrors; bool get isNightWaking; int get sleepQualityIndex; String get quickNoteText; bool get showNotesUpdateErrors;
/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayStateCopyWith<TodayState> get copyWith => _$TodayStateCopyWithImpl<TodayState>(this as TodayState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TodayState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isSuccess, _this.isSuccess) || other.isSuccess == _this.isSuccess)&&(identical(other.saveStatus, _this.saveStatus) || other.saveStatus == _this.saveStatus)&&(identical(other.activeChildId, _this.activeChildId) || other.activeChildId == _this.activeChildId)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.childName, _this.childName) || other.childName == _this.childName)&&(identical(other.parentName, _this.parentName) || other.parentName == _this.parentName)&&(identical(other.timeOfDayGreeting, _this.timeOfDayGreeting) || other.timeOfDayGreeting == _this.timeOfDayGreeting)&&(identical(other.sleepForecastStart, _this.sleepForecastStart) || other.sleepForecastStart == _this.sleepForecastStart)&&(identical(other.sleepForecastEnd, _this.sleepForecastEnd) || other.sleepForecastEnd == _this.sleepForecastEnd)&&(identical(other.bedtimeEstimate, _this.bedtimeEstimate) || other.bedtimeEstimate == _this.bedtimeEstimate)&&(identical(other.forecastSubtitle, _this.forecastSubtitle) || other.forecastSubtitle == _this.forecastSubtitle)&&(identical(other.confidenceLevel, _this.confidenceLevel) || other.confidenceLevel == _this.confidenceLevel)&&(identical(other.confidenceDots, _this.confidenceDots) || other.confidenceDots == _this.confidenceDots)&&(identical(other.sleepForecastReason, _this.sleepForecastReason) || other.sleepForecastReason == _this.sleepForecastReason)&&(identical(other.hasSleepLogs, _this.hasSleepLogs) || other.hasSleepLogs == _this.hasSleepLogs)&&(identical(other.hasMultiDayPatterns, _this.hasMultiDayPatterns) || other.hasMultiDayPatterns == _this.hasMultiDayPatterns)&&(identical(other.hasAnyLogs, _this.hasAnyLogs) || other.hasAnyLogs == _this.hasAnyLogs)&&(identical(other.loggedDaysCount, _this.loggedDaysCount) || other.loggedDaysCount == _this.loggedDaysCount)&&(identical(other.didForecastChangeSignificantly, _this.didForecastChangeSignificantly) || other.didForecastChangeSignificantly == _this.didForecastChangeSignificantly)&&(identical(other.forecastChangeReason, _this.forecastChangeReason) || other.forecastChangeReason == _this.forecastChangeReason)&&(identical(other.duplicateSleepLogDetected, _this.duplicateSleepLogDetected) || other.duplicateSleepLogDetected == _this.duplicateSleepLogDetected)&&(identical(other.showHealthHeadsUp, _this.showHealthHeadsUp) || other.showHealthHeadsUp == _this.showHealthHeadsUp)&&(identical(other.healthHeadsUpTitle, _this.healthHeadsUpTitle) || other.healthHeadsUpTitle == _this.healthHeadsUpTitle)&&(identical(other.healthHeadsUpSubtitle, _this.healthHeadsUpSubtitle) || other.healthHeadsUpSubtitle == _this.healthHeadsUpSubtitle)&&(identical(other.showBehaviourHeadsUp, _this.showBehaviourHeadsUp) || other.showBehaviourHeadsUp == _this.showBehaviourHeadsUp)&&(identical(other.headsUpHeadline, _this.headsUpHeadline) || other.headsUpHeadline == _this.headsUpHeadline)&&(identical(other.headsUpReason, _this.headsUpReason) || other.headsUpReason == _this.headsUpReason)&&(identical(other.headsUpWindowStart, _this.headsUpWindowStart) || other.headsUpWindowStart == _this.headsUpWindowStart)&&(identical(other.headsUpWindowEnd, _this.headsUpWindowEnd) || other.headsUpWindowEnd == _this.headsUpWindowEnd)&&(identical(other.showNiceWork, _this.showNiceWork) || other.showNiceWork == _this.showNiceWork)&&(identical(other.niceWorkTitle, _this.niceWorkTitle) || other.niceWorkTitle == _this.niceWorkTitle)&&(identical(other.niceWorkSubtitle, _this.niceWorkSubtitle) || other.niceWorkSubtitle == _this.niceWorkSubtitle)&&(identical(other.showNoticed, _this.showNoticed) || other.showNoticed == _this.showNoticed)&&(identical(other.noticedTitle, _this.noticedTitle) || other.noticedTitle == _this.noticedTitle)&&(identical(other.noticedDestination, _this.noticedDestination) || other.noticedDestination == _this.noticedDestination)&&(identical(other.showSupportOffer, _this.showSupportOffer) || other.showSupportOffer == _this.showSupportOffer)&&(identical(other.supportInconsistentDays, _this.supportInconsistentDays) || other.supportInconsistentDays == _this.supportInconsistentDays)&&(identical(other.onboardingFocusLine, _this.onboardingFocusLine) || other.onboardingFocusLine == _this.onboardingFocusLine)&&(identical(other.prioritiseSleepFirst, _this.prioritiseSleepFirst) || other.prioritiseSleepFirst == _this.prioritiseSleepFirst)&&(identical(other.instantResultTitle, _this.instantResultTitle) || other.instantResultTitle == _this.instantResultTitle)&&(identical(other.instantResultAction, _this.instantResultAction) || other.instantResultAction == _this.instantResultAction)&&(identical(other.instantResultActionSubtitle, _this.instantResultActionSubtitle) || other.instantResultActionSubtitle == _this.instantResultActionSubtitle)&&(identical(other.fellAsleepTime, _this.fellAsleepTime) || other.fellAsleepTime == _this.fellAsleepTime)&&(identical(other.wokeUpTime, _this.wokeUpTime) || other.wokeUpTime == _this.wokeUpTime)&&(identical(other.includeNaps, _this.includeNaps) || other.includeNaps == _this.includeNaps)&&const DeepCollectionEquality().equals(other.napDrafts, _this.napDrafts)&&(identical(other.showSleepUpdateErrors, _this.showSleepUpdateErrors) || other.showSleepUpdateErrors == _this.showSleepUpdateErrors)&&(identical(other.selectedChildMoodIndex, _this.selectedChildMoodIndex) || other.selectedChildMoodIndex == _this.selectedChildMoodIndex)&&(identical(other.selectedParentMood, _this.selectedParentMood) || other.selectedParentMood == _this.selectedParentMood)&&(identical(other.showMoodUpdateErrors, _this.showMoodUpdateErrors) || other.showMoodUpdateErrors == _this.showMoodUpdateErrors)&&(identical(other.tantrumWhatHappened, _this.tantrumWhatHappened) || other.tantrumWhatHappened == _this.tantrumWhatHappened)&&(identical(other.tantrumTime, _this.tantrumTime) || other.tantrumTime == _this.tantrumTime)&&(identical(other.tantrumIntensity, _this.tantrumIntensity) || other.tantrumIntensity == _this.tantrumIntensity)&&const DeepCollectionEquality().equals(other.selectedTantrumTriggers, _this.selectedTantrumTriggers)&&(identical(other.tantrumWhatHelped, _this.tantrumWhatHelped) || other.tantrumWhatHelped == _this.tantrumWhatHelped)&&(identical(other.showTantrumUpdateErrors, _this.showTantrumUpdateErrors) || other.showTantrumUpdateErrors == _this.showTantrumUpdateErrors)&&const DeepCollectionEquality().equals(other.selectedHealthIssues, _this.selectedHealthIssues)&&(identical(other.healthNotes, _this.healthNotes) || other.healthNotes == _this.healthNotes)&&(identical(other.showHealthUpdateErrors, _this.showHealthUpdateErrors) || other.showHealthUpdateErrors == _this.showHealthUpdateErrors)&&(identical(other.isNightWaking, _this.isNightWaking) || other.isNightWaking == _this.isNightWaking)&&(identical(other.sleepQualityIndex, _this.sleepQualityIndex) || other.sleepQualityIndex == _this.sleepQualityIndex)&&(identical(other.quickNoteText, _this.quickNoteText) || other.quickNoteText == _this.quickNoteText)&&(identical(other.showNotesUpdateErrors, _this.showNotesUpdateErrors) || other.showNotesUpdateErrors == _this.showNotesUpdateErrors));
}


@override
int get hashCode {
  final _this = this as TodayState;
  return Object.hashAll([runtimeType,_this.isLoading,_this.isSuccess,_this.saveStatus,_this.activeChildId,_this.mode,_this.childName,_this.parentName,_this.timeOfDayGreeting,_this.sleepForecastStart,_this.sleepForecastEnd,_this.bedtimeEstimate,_this.forecastSubtitle,_this.confidenceLevel,_this.confidenceDots,_this.sleepForecastReason,_this.hasSleepLogs,_this.hasMultiDayPatterns,_this.hasAnyLogs,_this.loggedDaysCount,_this.didForecastChangeSignificantly,_this.forecastChangeReason,_this.duplicateSleepLogDetected,_this.showHealthHeadsUp,_this.healthHeadsUpTitle,_this.healthHeadsUpSubtitle,_this.showBehaviourHeadsUp,_this.headsUpHeadline,_this.headsUpReason,_this.headsUpWindowStart,_this.headsUpWindowEnd,_this.showNiceWork,_this.niceWorkTitle,_this.niceWorkSubtitle,_this.showNoticed,_this.noticedTitle,_this.noticedDestination,_this.showSupportOffer,_this.supportInconsistentDays,_this.onboardingFocusLine,_this.prioritiseSleepFirst,_this.instantResultTitle,_this.instantResultAction,_this.instantResultActionSubtitle,_this.fellAsleepTime,_this.wokeUpTime,_this.includeNaps,const DeepCollectionEquality().hash(_this.napDrafts),_this.showSleepUpdateErrors,_this.selectedChildMoodIndex,_this.selectedParentMood,_this.showMoodUpdateErrors,_this.tantrumWhatHappened,_this.tantrumTime,_this.tantrumIntensity,const DeepCollectionEquality().hash(_this.selectedTantrumTriggers),_this.tantrumWhatHelped,_this.showTantrumUpdateErrors,const DeepCollectionEquality().hash(_this.selectedHealthIssues),_this.healthNotes,_this.showHealthUpdateErrors,_this.isNightWaking,_this.sleepQualityIndex,_this.quickNoteText,_this.showNotesUpdateErrors]);
}

@override
String toString() {
  final _this = this as TodayState;
  return 'TodayState(isLoading: ${_this.isLoading}, isSuccess: ${_this.isSuccess}, saveStatus: ${_this.saveStatus}, activeChildId: ${_this.activeChildId}, mode: ${_this.mode}, childName: ${_this.childName}, parentName: ${_this.parentName}, timeOfDayGreeting: ${_this.timeOfDayGreeting}, sleepForecastStart: ${_this.sleepForecastStart}, sleepForecastEnd: ${_this.sleepForecastEnd}, bedtimeEstimate: ${_this.bedtimeEstimate}, forecastSubtitle: ${_this.forecastSubtitle}, confidenceLevel: ${_this.confidenceLevel}, confidenceDots: ${_this.confidenceDots}, sleepForecastReason: ${_this.sleepForecastReason}, hasSleepLogs: ${_this.hasSleepLogs}, hasMultiDayPatterns: ${_this.hasMultiDayPatterns}, hasAnyLogs: ${_this.hasAnyLogs}, loggedDaysCount: ${_this.loggedDaysCount}, didForecastChangeSignificantly: ${_this.didForecastChangeSignificantly}, forecastChangeReason: ${_this.forecastChangeReason}, duplicateSleepLogDetected: ${_this.duplicateSleepLogDetected}, showHealthHeadsUp: ${_this.showHealthHeadsUp}, healthHeadsUpTitle: ${_this.healthHeadsUpTitle}, healthHeadsUpSubtitle: ${_this.healthHeadsUpSubtitle}, showBehaviourHeadsUp: ${_this.showBehaviourHeadsUp}, headsUpHeadline: ${_this.headsUpHeadline}, headsUpReason: ${_this.headsUpReason}, headsUpWindowStart: ${_this.headsUpWindowStart}, headsUpWindowEnd: ${_this.headsUpWindowEnd}, showNiceWork: ${_this.showNiceWork}, niceWorkTitle: ${_this.niceWorkTitle}, niceWorkSubtitle: ${_this.niceWorkSubtitle}, showNoticed: ${_this.showNoticed}, noticedTitle: ${_this.noticedTitle}, noticedDestination: ${_this.noticedDestination}, showSupportOffer: ${_this.showSupportOffer}, supportInconsistentDays: ${_this.supportInconsistentDays}, onboardingFocusLine: ${_this.onboardingFocusLine}, prioritiseSleepFirst: ${_this.prioritiseSleepFirst}, instantResultTitle: ${_this.instantResultTitle}, instantResultAction: ${_this.instantResultAction}, instantResultActionSubtitle: ${_this.instantResultActionSubtitle}, fellAsleepTime: ${_this.fellAsleepTime}, wokeUpTime: ${_this.wokeUpTime}, includeNaps: ${_this.includeNaps}, napDrafts: ${_this.napDrafts}, showSleepUpdateErrors: ${_this.showSleepUpdateErrors}, selectedChildMoodIndex: ${_this.selectedChildMoodIndex}, selectedParentMood: ${_this.selectedParentMood}, showMoodUpdateErrors: ${_this.showMoodUpdateErrors}, tantrumWhatHappened: ${_this.tantrumWhatHappened}, tantrumTime: ${_this.tantrumTime}, tantrumIntensity: ${_this.tantrumIntensity}, selectedTantrumTriggers: ${_this.selectedTantrumTriggers}, tantrumWhatHelped: ${_this.tantrumWhatHelped}, showTantrumUpdateErrors: ${_this.showTantrumUpdateErrors}, selectedHealthIssues: ${_this.selectedHealthIssues}, healthNotes: ${_this.healthNotes}, showHealthUpdateErrors: ${_this.showHealthUpdateErrors}, isNightWaking: ${_this.isNightWaking}, sleepQualityIndex: ${_this.sleepQualityIndex}, quickNoteText: ${_this.quickNoteText}, showNotesUpdateErrors: ${_this.showNotesUpdateErrors})';
}


}

/// @nodoc
abstract mixin class $TodayStateCopyWith<$Res>  {
  factory $TodayStateCopyWith(TodayState value, $Res Function(TodayState) _then) = _$TodayStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isSuccess, ApiResultStatus<dynamic> saveStatus, String activeChildId, TodayMode mode, String childName, String parentName, String timeOfDayGreeting, String sleepForecastStart, String sleepForecastEnd, String bedtimeEstimate, String forecastSubtitle, String confidenceLevel, int confidenceDots, String sleepForecastReason, bool hasSleepLogs, bool hasMultiDayPatterns, bool hasAnyLogs, int loggedDaysCount, bool didForecastChangeSignificantly, String forecastChangeReason, SleepLogModel? duplicateSleepLogDetected, bool showHealthHeadsUp, String healthHeadsUpTitle, String healthHeadsUpSubtitle, bool showBehaviourHeadsUp, String headsUpHeadline, String headsUpReason, String headsUpWindowStart, String headsUpWindowEnd, bool showNiceWork, String niceWorkTitle, String niceWorkSubtitle, bool showNoticed, String noticedTitle, TodayNoticedDestination noticedDestination, bool showSupportOffer, int supportInconsistentDays, String onboardingFocusLine, bool prioritiseSleepFirst, String instantResultTitle, String instantResultAction, String instantResultActionSubtitle, String? fellAsleepTime, String? wokeUpTime, bool includeNaps, List<NapDraft> napDrafts, bool showSleepUpdateErrors, int selectedChildMoodIndex, String selectedParentMood, bool showMoodUpdateErrors, String tantrumWhatHappened, String? tantrumTime, double tantrumIntensity, List<String> selectedTantrumTriggers, String tantrumWhatHelped, bool showTantrumUpdateErrors, List<String> selectedHealthIssues, String healthNotes, bool showHealthUpdateErrors, bool isNightWaking, int sleepQualityIndex, String quickNoteText, bool showNotesUpdateErrors
});


$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus;

}
/// @nodoc
class _$TodayStateCopyWithImpl<$Res>
    implements $TodayStateCopyWith<$Res> {
  _$TodayStateCopyWithImpl(this._self, this._then);

  final TodayState _self;
  final $Res Function(TodayState) _then;

/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isSuccess = null,Object? saveStatus = null,Object? activeChildId = null,Object? mode = null,Object? childName = null,Object? parentName = null,Object? timeOfDayGreeting = null,Object? sleepForecastStart = null,Object? sleepForecastEnd = null,Object? bedtimeEstimate = null,Object? forecastSubtitle = null,Object? confidenceLevel = null,Object? confidenceDots = null,Object? sleepForecastReason = null,Object? hasSleepLogs = null,Object? hasMultiDayPatterns = null,Object? hasAnyLogs = null,Object? loggedDaysCount = null,Object? didForecastChangeSignificantly = null,Object? forecastChangeReason = null,Object? duplicateSleepLogDetected = freezed,Object? showHealthHeadsUp = null,Object? healthHeadsUpTitle = null,Object? healthHeadsUpSubtitle = null,Object? showBehaviourHeadsUp = null,Object? headsUpHeadline = null,Object? headsUpReason = null,Object? headsUpWindowStart = null,Object? headsUpWindowEnd = null,Object? showNiceWork = null,Object? niceWorkTitle = null,Object? niceWorkSubtitle = null,Object? showNoticed = null,Object? noticedTitle = null,Object? noticedDestination = null,Object? showSupportOffer = null,Object? supportInconsistentDays = null,Object? onboardingFocusLine = null,Object? prioritiseSleepFirst = null,Object? instantResultTitle = null,Object? instantResultAction = null,Object? instantResultActionSubtitle = null,Object? fellAsleepTime = freezed,Object? wokeUpTime = freezed,Object? includeNaps = null,Object? napDrafts = null,Object? showSleepUpdateErrors = null,Object? selectedChildMoodIndex = null,Object? selectedParentMood = null,Object? showMoodUpdateErrors = null,Object? tantrumWhatHappened = null,Object? tantrumTime = freezed,Object? tantrumIntensity = null,Object? selectedTantrumTriggers = null,Object? tantrumWhatHelped = null,Object? showTantrumUpdateErrors = null,Object? selectedHealthIssues = null,Object? healthNotes = null,Object? showHealthUpdateErrors = null,Object? isNightWaking = null,Object? sleepQualityIndex = null,Object? quickNoteText = null,Object? showNotesUpdateErrors = null,}) {
  return _then(TodayState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,activeChildId: null == activeChildId ? _self.activeChildId : activeChildId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TodayMode,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,parentName: null == parentName ? _self.parentName : parentName // ignore: cast_nullable_to_non_nullable
as String,timeOfDayGreeting: null == timeOfDayGreeting ? _self.timeOfDayGreeting : timeOfDayGreeting // ignore: cast_nullable_to_non_nullable
as String,sleepForecastStart: null == sleepForecastStart ? _self.sleepForecastStart : sleepForecastStart // ignore: cast_nullable_to_non_nullable
as String,sleepForecastEnd: null == sleepForecastEnd ? _self.sleepForecastEnd : sleepForecastEnd // ignore: cast_nullable_to_non_nullable
as String,bedtimeEstimate: null == bedtimeEstimate ? _self.bedtimeEstimate : bedtimeEstimate // ignore: cast_nullable_to_non_nullable
as String,forecastSubtitle: null == forecastSubtitle ? _self.forecastSubtitle : forecastSubtitle // ignore: cast_nullable_to_non_nullable
as String,confidenceLevel: null == confidenceLevel ? _self.confidenceLevel : confidenceLevel // ignore: cast_nullable_to_non_nullable
as String,confidenceDots: null == confidenceDots ? _self.confidenceDots : confidenceDots // ignore: cast_nullable_to_non_nullable
as int,sleepForecastReason: null == sleepForecastReason ? _self.sleepForecastReason : sleepForecastReason // ignore: cast_nullable_to_non_nullable
as String,hasSleepLogs: null == hasSleepLogs ? _self.hasSleepLogs : hasSleepLogs // ignore: cast_nullable_to_non_nullable
as bool,hasMultiDayPatterns: null == hasMultiDayPatterns ? _self.hasMultiDayPatterns : hasMultiDayPatterns // ignore: cast_nullable_to_non_nullable
as bool,hasAnyLogs: null == hasAnyLogs ? _self.hasAnyLogs : hasAnyLogs // ignore: cast_nullable_to_non_nullable
as bool,loggedDaysCount: null == loggedDaysCount ? _self.loggedDaysCount : loggedDaysCount // ignore: cast_nullable_to_non_nullable
as int,didForecastChangeSignificantly: null == didForecastChangeSignificantly ? _self.didForecastChangeSignificantly : didForecastChangeSignificantly // ignore: cast_nullable_to_non_nullable
as bool,forecastChangeReason: null == forecastChangeReason ? _self.forecastChangeReason : forecastChangeReason // ignore: cast_nullable_to_non_nullable
as String,duplicateSleepLogDetected: freezed == duplicateSleepLogDetected ? _self.duplicateSleepLogDetected : duplicateSleepLogDetected // ignore: cast_nullable_to_non_nullable
as SleepLogModel?,showHealthHeadsUp: null == showHealthHeadsUp ? _self.showHealthHeadsUp : showHealthHeadsUp // ignore: cast_nullable_to_non_nullable
as bool,healthHeadsUpTitle: null == healthHeadsUpTitle ? _self.healthHeadsUpTitle : healthHeadsUpTitle // ignore: cast_nullable_to_non_nullable
as String,healthHeadsUpSubtitle: null == healthHeadsUpSubtitle ? _self.healthHeadsUpSubtitle : healthHeadsUpSubtitle // ignore: cast_nullable_to_non_nullable
as String,showBehaviourHeadsUp: null == showBehaviourHeadsUp ? _self.showBehaviourHeadsUp : showBehaviourHeadsUp // ignore: cast_nullable_to_non_nullable
as bool,headsUpHeadline: null == headsUpHeadline ? _self.headsUpHeadline : headsUpHeadline // ignore: cast_nullable_to_non_nullable
as String,headsUpReason: null == headsUpReason ? _self.headsUpReason : headsUpReason // ignore: cast_nullable_to_non_nullable
as String,headsUpWindowStart: null == headsUpWindowStart ? _self.headsUpWindowStart : headsUpWindowStart // ignore: cast_nullable_to_non_nullable
as String,headsUpWindowEnd: null == headsUpWindowEnd ? _self.headsUpWindowEnd : headsUpWindowEnd // ignore: cast_nullable_to_non_nullable
as String,showNiceWork: null == showNiceWork ? _self.showNiceWork : showNiceWork // ignore: cast_nullable_to_non_nullable
as bool,niceWorkTitle: null == niceWorkTitle ? _self.niceWorkTitle : niceWorkTitle // ignore: cast_nullable_to_non_nullable
as String,niceWorkSubtitle: null == niceWorkSubtitle ? _self.niceWorkSubtitle : niceWorkSubtitle // ignore: cast_nullable_to_non_nullable
as String,showNoticed: null == showNoticed ? _self.showNoticed : showNoticed // ignore: cast_nullable_to_non_nullable
as bool,noticedTitle: null == noticedTitle ? _self.noticedTitle : noticedTitle // ignore: cast_nullable_to_non_nullable
as String,noticedDestination: null == noticedDestination ? _self.noticedDestination : noticedDestination // ignore: cast_nullable_to_non_nullable
as TodayNoticedDestination,showSupportOffer: null == showSupportOffer ? _self.showSupportOffer : showSupportOffer // ignore: cast_nullable_to_non_nullable
as bool,supportInconsistentDays: null == supportInconsistentDays ? _self.supportInconsistentDays : supportInconsistentDays // ignore: cast_nullable_to_non_nullable
as int,onboardingFocusLine: null == onboardingFocusLine ? _self.onboardingFocusLine : onboardingFocusLine // ignore: cast_nullable_to_non_nullable
as String,prioritiseSleepFirst: null == prioritiseSleepFirst ? _self.prioritiseSleepFirst : prioritiseSleepFirst // ignore: cast_nullable_to_non_nullable
as bool,instantResultTitle: null == instantResultTitle ? _self.instantResultTitle : instantResultTitle // ignore: cast_nullable_to_non_nullable
as String,instantResultAction: null == instantResultAction ? _self.instantResultAction : instantResultAction // ignore: cast_nullable_to_non_nullable
as String,instantResultActionSubtitle: null == instantResultActionSubtitle ? _self.instantResultActionSubtitle : instantResultActionSubtitle // ignore: cast_nullable_to_non_nullable
as String,fellAsleepTime: freezed == fellAsleepTime ? _self.fellAsleepTime : fellAsleepTime // ignore: cast_nullable_to_non_nullable
as String?,wokeUpTime: freezed == wokeUpTime ? _self.wokeUpTime : wokeUpTime // ignore: cast_nullable_to_non_nullable
as String?,includeNaps: null == includeNaps ? _self.includeNaps : includeNaps // ignore: cast_nullable_to_non_nullable
as bool,napDrafts: null == napDrafts ? _self.napDrafts : napDrafts // ignore: cast_nullable_to_non_nullable
as List<NapDraft>,showSleepUpdateErrors: null == showSleepUpdateErrors ? _self.showSleepUpdateErrors : showSleepUpdateErrors // ignore: cast_nullable_to_non_nullable
as bool,selectedChildMoodIndex: null == selectedChildMoodIndex ? _self.selectedChildMoodIndex : selectedChildMoodIndex // ignore: cast_nullable_to_non_nullable
as int,selectedParentMood: null == selectedParentMood ? _self.selectedParentMood : selectedParentMood // ignore: cast_nullable_to_non_nullable
as String,showMoodUpdateErrors: null == showMoodUpdateErrors ? _self.showMoodUpdateErrors : showMoodUpdateErrors // ignore: cast_nullable_to_non_nullable
as bool,tantrumWhatHappened: null == tantrumWhatHappened ? _self.tantrumWhatHappened : tantrumWhatHappened // ignore: cast_nullable_to_non_nullable
as String,tantrumTime: freezed == tantrumTime ? _self.tantrumTime : tantrumTime // ignore: cast_nullable_to_non_nullable
as String?,tantrumIntensity: null == tantrumIntensity ? _self.tantrumIntensity : tantrumIntensity // ignore: cast_nullable_to_non_nullable
as double,selectedTantrumTriggers: null == selectedTantrumTriggers ? _self.selectedTantrumTriggers : selectedTantrumTriggers // ignore: cast_nullable_to_non_nullable
as List<String>,tantrumWhatHelped: null == tantrumWhatHelped ? _self.tantrumWhatHelped : tantrumWhatHelped // ignore: cast_nullable_to_non_nullable
as String,showTantrumUpdateErrors: null == showTantrumUpdateErrors ? _self.showTantrumUpdateErrors : showTantrumUpdateErrors // ignore: cast_nullable_to_non_nullable
as bool,selectedHealthIssues: null == selectedHealthIssues ? _self.selectedHealthIssues : selectedHealthIssues // ignore: cast_nullable_to_non_nullable
as List<String>,healthNotes: null == healthNotes ? _self.healthNotes : healthNotes // ignore: cast_nullable_to_non_nullable
as String,showHealthUpdateErrors: null == showHealthUpdateErrors ? _self.showHealthUpdateErrors : showHealthUpdateErrors // ignore: cast_nullable_to_non_nullable
as bool,isNightWaking: null == isNightWaking ? _self.isNightWaking : isNightWaking // ignore: cast_nullable_to_non_nullable
as bool,sleepQualityIndex: null == sleepQualityIndex ? _self.sleepQualityIndex : sleepQualityIndex // ignore: cast_nullable_to_non_nullable
as int,quickNoteText: null == quickNoteText ? _self.quickNoteText : quickNoteText // ignore: cast_nullable_to_non_nullable
as String,showNotesUpdateErrors: null == showNotesUpdateErrors ? _self.showNotesUpdateErrors : showNotesUpdateErrors // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveStatus, (value) {
    return _then(_self.copyWith(saveStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [TodayState].
extension TodayStatePatterns on TodayState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodayState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodayState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodayState value)  $default,){
final _that = this;
switch (_that) {
case _TodayState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodayState value)?  $default,){
final _that = this;
switch (_that) {
case _TodayState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isSuccess,  ApiResultStatus<dynamic> saveStatus,  String activeChildId,  TodayMode mode,  String childName,  String parentName,  String timeOfDayGreeting,  String sleepForecastStart,  String sleepForecastEnd,  String bedtimeEstimate,  String forecastSubtitle,  String confidenceLevel,  int confidenceDots,  String sleepForecastReason,  bool hasSleepLogs,  bool hasMultiDayPatterns,  bool hasAnyLogs,  int loggedDaysCount,  bool didForecastChangeSignificantly,  String forecastChangeReason,  SleepLogModel? duplicateSleepLogDetected,  bool showHealthHeadsUp,  String healthHeadsUpTitle,  String healthHeadsUpSubtitle,  bool showBehaviourHeadsUp,  String headsUpHeadline,  String headsUpReason,  String headsUpWindowStart,  String headsUpWindowEnd,  bool showNiceWork,  String niceWorkTitle,  String niceWorkSubtitle,  bool showNoticed,  String noticedTitle,  TodayNoticedDestination noticedDestination,  bool showSupportOffer,  int supportInconsistentDays,  String onboardingFocusLine,  bool prioritiseSleepFirst,  String instantResultTitle,  String instantResultAction,  String instantResultActionSubtitle,  String? fellAsleepTime,  String? wokeUpTime,  bool includeNaps,  List<NapDraft> napDrafts,  bool showSleepUpdateErrors,  int selectedChildMoodIndex,  String selectedParentMood,  bool showMoodUpdateErrors,  String tantrumWhatHappened,  String? tantrumTime,  double tantrumIntensity,  List<String> selectedTantrumTriggers,  String tantrumWhatHelped,  bool showTantrumUpdateErrors,  List<String> selectedHealthIssues,  String healthNotes,  bool showHealthUpdateErrors,  bool isNightWaking,  int sleepQualityIndex,  String quickNoteText,  bool showNotesUpdateErrors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodayState() when $default != null:
return $default(_that.isLoading,_that.isSuccess,_that.saveStatus,_that.activeChildId,_that.mode,_that.childName,_that.parentName,_that.timeOfDayGreeting,_that.sleepForecastStart,_that.sleepForecastEnd,_that.bedtimeEstimate,_that.forecastSubtitle,_that.confidenceLevel,_that.confidenceDots,_that.sleepForecastReason,_that.hasSleepLogs,_that.hasMultiDayPatterns,_that.hasAnyLogs,_that.loggedDaysCount,_that.didForecastChangeSignificantly,_that.forecastChangeReason,_that.duplicateSleepLogDetected,_that.showHealthHeadsUp,_that.healthHeadsUpTitle,_that.healthHeadsUpSubtitle,_that.showBehaviourHeadsUp,_that.headsUpHeadline,_that.headsUpReason,_that.headsUpWindowStart,_that.headsUpWindowEnd,_that.showNiceWork,_that.niceWorkTitle,_that.niceWorkSubtitle,_that.showNoticed,_that.noticedTitle,_that.noticedDestination,_that.showSupportOffer,_that.supportInconsistentDays,_that.onboardingFocusLine,_that.prioritiseSleepFirst,_that.instantResultTitle,_that.instantResultAction,_that.instantResultActionSubtitle,_that.fellAsleepTime,_that.wokeUpTime,_that.includeNaps,_that.napDrafts,_that.showSleepUpdateErrors,_that.selectedChildMoodIndex,_that.selectedParentMood,_that.showMoodUpdateErrors,_that.tantrumWhatHappened,_that.tantrumTime,_that.tantrumIntensity,_that.selectedTantrumTriggers,_that.tantrumWhatHelped,_that.showTantrumUpdateErrors,_that.selectedHealthIssues,_that.healthNotes,_that.showHealthUpdateErrors,_that.isNightWaking,_that.sleepQualityIndex,_that.quickNoteText,_that.showNotesUpdateErrors);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isSuccess,  ApiResultStatus<dynamic> saveStatus,  String activeChildId,  TodayMode mode,  String childName,  String parentName,  String timeOfDayGreeting,  String sleepForecastStart,  String sleepForecastEnd,  String bedtimeEstimate,  String forecastSubtitle,  String confidenceLevel,  int confidenceDots,  String sleepForecastReason,  bool hasSleepLogs,  bool hasMultiDayPatterns,  bool hasAnyLogs,  int loggedDaysCount,  bool didForecastChangeSignificantly,  String forecastChangeReason,  SleepLogModel? duplicateSleepLogDetected,  bool showHealthHeadsUp,  String healthHeadsUpTitle,  String healthHeadsUpSubtitle,  bool showBehaviourHeadsUp,  String headsUpHeadline,  String headsUpReason,  String headsUpWindowStart,  String headsUpWindowEnd,  bool showNiceWork,  String niceWorkTitle,  String niceWorkSubtitle,  bool showNoticed,  String noticedTitle,  TodayNoticedDestination noticedDestination,  bool showSupportOffer,  int supportInconsistentDays,  String onboardingFocusLine,  bool prioritiseSleepFirst,  String instantResultTitle,  String instantResultAction,  String instantResultActionSubtitle,  String? fellAsleepTime,  String? wokeUpTime,  bool includeNaps,  List<NapDraft> napDrafts,  bool showSleepUpdateErrors,  int selectedChildMoodIndex,  String selectedParentMood,  bool showMoodUpdateErrors,  String tantrumWhatHappened,  String? tantrumTime,  double tantrumIntensity,  List<String> selectedTantrumTriggers,  String tantrumWhatHelped,  bool showTantrumUpdateErrors,  List<String> selectedHealthIssues,  String healthNotes,  bool showHealthUpdateErrors,  bool isNightWaking,  int sleepQualityIndex,  String quickNoteText,  bool showNotesUpdateErrors)  $default,) {final _that = this;
switch (_that) {
case _TodayState():
return $default(_that.isLoading,_that.isSuccess,_that.saveStatus,_that.activeChildId,_that.mode,_that.childName,_that.parentName,_that.timeOfDayGreeting,_that.sleepForecastStart,_that.sleepForecastEnd,_that.bedtimeEstimate,_that.forecastSubtitle,_that.confidenceLevel,_that.confidenceDots,_that.sleepForecastReason,_that.hasSleepLogs,_that.hasMultiDayPatterns,_that.hasAnyLogs,_that.loggedDaysCount,_that.didForecastChangeSignificantly,_that.forecastChangeReason,_that.duplicateSleepLogDetected,_that.showHealthHeadsUp,_that.healthHeadsUpTitle,_that.healthHeadsUpSubtitle,_that.showBehaviourHeadsUp,_that.headsUpHeadline,_that.headsUpReason,_that.headsUpWindowStart,_that.headsUpWindowEnd,_that.showNiceWork,_that.niceWorkTitle,_that.niceWorkSubtitle,_that.showNoticed,_that.noticedTitle,_that.noticedDestination,_that.showSupportOffer,_that.supportInconsistentDays,_that.onboardingFocusLine,_that.prioritiseSleepFirst,_that.instantResultTitle,_that.instantResultAction,_that.instantResultActionSubtitle,_that.fellAsleepTime,_that.wokeUpTime,_that.includeNaps,_that.napDrafts,_that.showSleepUpdateErrors,_that.selectedChildMoodIndex,_that.selectedParentMood,_that.showMoodUpdateErrors,_that.tantrumWhatHappened,_that.tantrumTime,_that.tantrumIntensity,_that.selectedTantrumTriggers,_that.tantrumWhatHelped,_that.showTantrumUpdateErrors,_that.selectedHealthIssues,_that.healthNotes,_that.showHealthUpdateErrors,_that.isNightWaking,_that.sleepQualityIndex,_that.quickNoteText,_that.showNotesUpdateErrors);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isSuccess,  ApiResultStatus<dynamic> saveStatus,  String activeChildId,  TodayMode mode,  String childName,  String parentName,  String timeOfDayGreeting,  String sleepForecastStart,  String sleepForecastEnd,  String bedtimeEstimate,  String forecastSubtitle,  String confidenceLevel,  int confidenceDots,  String sleepForecastReason,  bool hasSleepLogs,  bool hasMultiDayPatterns,  bool hasAnyLogs,  int loggedDaysCount,  bool didForecastChangeSignificantly,  String forecastChangeReason,  SleepLogModel? duplicateSleepLogDetected,  bool showHealthHeadsUp,  String healthHeadsUpTitle,  String healthHeadsUpSubtitle,  bool showBehaviourHeadsUp,  String headsUpHeadline,  String headsUpReason,  String headsUpWindowStart,  String headsUpWindowEnd,  bool showNiceWork,  String niceWorkTitle,  String niceWorkSubtitle,  bool showNoticed,  String noticedTitle,  TodayNoticedDestination noticedDestination,  bool showSupportOffer,  int supportInconsistentDays,  String onboardingFocusLine,  bool prioritiseSleepFirst,  String instantResultTitle,  String instantResultAction,  String instantResultActionSubtitle,  String? fellAsleepTime,  String? wokeUpTime,  bool includeNaps,  List<NapDraft> napDrafts,  bool showSleepUpdateErrors,  int selectedChildMoodIndex,  String selectedParentMood,  bool showMoodUpdateErrors,  String tantrumWhatHappened,  String? tantrumTime,  double tantrumIntensity,  List<String> selectedTantrumTriggers,  String tantrumWhatHelped,  bool showTantrumUpdateErrors,  List<String> selectedHealthIssues,  String healthNotes,  bool showHealthUpdateErrors,  bool isNightWaking,  int sleepQualityIndex,  String quickNoteText,  bool showNotesUpdateErrors)?  $default,) {final _that = this;
switch (_that) {
case _TodayState() when $default != null:
return $default(_that.isLoading,_that.isSuccess,_that.saveStatus,_that.activeChildId,_that.mode,_that.childName,_that.parentName,_that.timeOfDayGreeting,_that.sleepForecastStart,_that.sleepForecastEnd,_that.bedtimeEstimate,_that.forecastSubtitle,_that.confidenceLevel,_that.confidenceDots,_that.sleepForecastReason,_that.hasSleepLogs,_that.hasMultiDayPatterns,_that.hasAnyLogs,_that.loggedDaysCount,_that.didForecastChangeSignificantly,_that.forecastChangeReason,_that.duplicateSleepLogDetected,_that.showHealthHeadsUp,_that.healthHeadsUpTitle,_that.healthHeadsUpSubtitle,_that.showBehaviourHeadsUp,_that.headsUpHeadline,_that.headsUpReason,_that.headsUpWindowStart,_that.headsUpWindowEnd,_that.showNiceWork,_that.niceWorkTitle,_that.niceWorkSubtitle,_that.showNoticed,_that.noticedTitle,_that.noticedDestination,_that.showSupportOffer,_that.supportInconsistentDays,_that.onboardingFocusLine,_that.prioritiseSleepFirst,_that.instantResultTitle,_that.instantResultAction,_that.instantResultActionSubtitle,_that.fellAsleepTime,_that.wokeUpTime,_that.includeNaps,_that.napDrafts,_that.showSleepUpdateErrors,_that.selectedChildMoodIndex,_that.selectedParentMood,_that.showMoodUpdateErrors,_that.tantrumWhatHappened,_that.tantrumTime,_that.tantrumIntensity,_that.selectedTantrumTriggers,_that.tantrumWhatHelped,_that.showTantrumUpdateErrors,_that.selectedHealthIssues,_that.healthNotes,_that.showHealthUpdateErrors,_that.isNightWaking,_that.sleepQualityIndex,_that.quickNoteText,_that.showNotesUpdateErrors);case _:
  return null;

}
}

}

/// @nodoc


class _TodayState implements TodayState {
  const _TodayState({this.isLoading = false, this.isSuccess = false, this.saveStatus = const ApiResultStatus.initial(), this.activeChildId = '', this.mode = TodayMode.newParent, this.childName = '', this.parentName = '', this.timeOfDayGreeting = 'GOOD EVENING', this.sleepForecastStart = '--:--', this.sleepForecastEnd = '--:--', this.bedtimeEstimate = '--:--', this.forecastSubtitle = 'Log sleep updates to view personalised forecasts.', this.confidenceLevel = 'none', this.confidenceDots = 0, this.sleepForecastReason = '', this.hasSleepLogs = false, this.hasMultiDayPatterns = false, this.hasAnyLogs = false, this.loggedDaysCount = 0, this.didForecastChangeSignificantly = false, this.forecastChangeReason = '', this.duplicateSleepLogDetected = null, this.showHealthHeadsUp = false, this.healthHeadsUpTitle = '', this.healthHeadsUpSubtitle = '', this.showBehaviourHeadsUp = false, this.headsUpHeadline = '', this.headsUpReason = '', this.headsUpWindowStart = '', this.headsUpWindowEnd = '', this.showNiceWork = false, this.niceWorkTitle = '', this.niceWorkSubtitle = '', this.showNoticed = false, this.noticedTitle = '', this.noticedDestination = TodayNoticedDestination.none, this.showSupportOffer = false, this.supportInconsistentDays = 0, this.onboardingFocusLine = '', this.prioritiseSleepFirst = true, this.instantResultTitle = '', this.instantResultAction = '', this.instantResultActionSubtitle = '', this.fellAsleepTime = null, this.wokeUpTime = null, this.includeNaps = false,  List<NapDraft> napDrafts = const <NapDraft>[], this.showSleepUpdateErrors = false, this.selectedChildMoodIndex = -1, this.selectedParentMood = '', this.showMoodUpdateErrors = false, this.tantrumWhatHappened = '', this.tantrumTime = null, this.tantrumIntensity = 0.5,  List<String> selectedTantrumTriggers = const [], this.tantrumWhatHelped = '', this.showTantrumUpdateErrors = false,  List<String> selectedHealthIssues = const [], this.healthNotes = '', this.showHealthUpdateErrors = false, this.isNightWaking = false, this.sleepQualityIndex = -1, this.quickNoteText = '', this.showNotesUpdateErrors = false}): _napDrafts = napDrafts,_selectedTantrumTriggers = selectedTantrumTriggers,_selectedHealthIssues = selectedHealthIssues;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSuccess;
@override@JsonKey() final  ApiResultStatus<dynamic> saveStatus;
@override@JsonKey() final  String activeChildId;
@override@JsonKey() final  TodayMode mode;
@override@JsonKey() final  String childName;
@override@JsonKey() final  String parentName;
@override@JsonKey() final  String timeOfDayGreeting;
@override@JsonKey() final  String sleepForecastStart;
@override@JsonKey() final  String sleepForecastEnd;
@override@JsonKey() final  String bedtimeEstimate;
@override@JsonKey() final  String forecastSubtitle;
@override@JsonKey() final  String confidenceLevel;
@override@JsonKey() final  int confidenceDots;
@override@JsonKey() final  String sleepForecastReason;
@override@JsonKey() final  bool hasSleepLogs;
@override@JsonKey() final  bool hasMultiDayPatterns;
@override@JsonKey() final  bool hasAnyLogs;
@override@JsonKey() final  int loggedDaysCount;
@override@JsonKey() final  bool didForecastChangeSignificantly;
@override@JsonKey() final  String forecastChangeReason;
@override@JsonKey() final  SleepLogModel? duplicateSleepLogDetected;
@override@JsonKey() final  bool showHealthHeadsUp;
@override@JsonKey() final  String healthHeadsUpTitle;
@override@JsonKey() final  String healthHeadsUpSubtitle;
@override@JsonKey() final  bool showBehaviourHeadsUp;
@override@JsonKey() final  String headsUpHeadline;
@override@JsonKey() final  String headsUpReason;
@override@JsonKey() final  String headsUpWindowStart;
@override@JsonKey() final  String headsUpWindowEnd;
@override@JsonKey() final  bool showNiceWork;
@override@JsonKey() final  String niceWorkTitle;
@override@JsonKey() final  String niceWorkSubtitle;
@override@JsonKey() final  bool showNoticed;
@override@JsonKey() final  String noticedTitle;
@override@JsonKey() final  TodayNoticedDestination noticedDestination;
@override@JsonKey() final  bool showSupportOffer;
@override@JsonKey() final  int supportInconsistentDays;
@override@JsonKey() final  String onboardingFocusLine;
@override@JsonKey() final  bool prioritiseSleepFirst;
@override@JsonKey() final  String instantResultTitle;
@override@JsonKey() final  String instantResultAction;
@override@JsonKey() final  String instantResultActionSubtitle;
@override@JsonKey() final  String? fellAsleepTime;
@override@JsonKey() final  String? wokeUpTime;
@override@JsonKey() final  bool includeNaps;
 final  List<NapDraft> _napDrafts;
@override@JsonKey() List<NapDraft> get napDrafts {
  if (_napDrafts is EqualUnmodifiableListView) return _napDrafts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_napDrafts);
}

@override@JsonKey() final  bool showSleepUpdateErrors;
@override@JsonKey() final  int selectedChildMoodIndex;
@override@JsonKey() final  String selectedParentMood;
@override@JsonKey() final  bool showMoodUpdateErrors;
@override@JsonKey() final  String tantrumWhatHappened;
@override@JsonKey() final  String? tantrumTime;
@override@JsonKey() final  double tantrumIntensity;
 final  List<String> _selectedTantrumTriggers;
@override@JsonKey() List<String> get selectedTantrumTriggers {
  if (_selectedTantrumTriggers is EqualUnmodifiableListView) return _selectedTantrumTriggers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedTantrumTriggers);
}

@override@JsonKey() final  String tantrumWhatHelped;
@override@JsonKey() final  bool showTantrumUpdateErrors;
 final  List<String> _selectedHealthIssues;
@override@JsonKey() List<String> get selectedHealthIssues {
  if (_selectedHealthIssues is EqualUnmodifiableListView) return _selectedHealthIssues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedHealthIssues);
}

@override@JsonKey() final  String healthNotes;
@override@JsonKey() final  bool showHealthUpdateErrors;
@override@JsonKey() final  bool isNightWaking;
@override@JsonKey() final  int sleepQualityIndex;
@override@JsonKey() final  String quickNoteText;
@override@JsonKey() final  bool showNotesUpdateErrors;

/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodayStateCopyWith<_TodayState> get copyWith => __$TodayStateCopyWithImpl<_TodayState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodayState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSuccess, isSuccess) || other.isSuccess == isSuccess)&&(identical(other.saveStatus, saveStatus) || other.saveStatus == saveStatus)&&(identical(other.activeChildId, activeChildId) || other.activeChildId == activeChildId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.parentName, parentName) || other.parentName == parentName)&&(identical(other.timeOfDayGreeting, timeOfDayGreeting) || other.timeOfDayGreeting == timeOfDayGreeting)&&(identical(other.sleepForecastStart, sleepForecastStart) || other.sleepForecastStart == sleepForecastStart)&&(identical(other.sleepForecastEnd, sleepForecastEnd) || other.sleepForecastEnd == sleepForecastEnd)&&(identical(other.bedtimeEstimate, bedtimeEstimate) || other.bedtimeEstimate == bedtimeEstimate)&&(identical(other.forecastSubtitle, forecastSubtitle) || other.forecastSubtitle == forecastSubtitle)&&(identical(other.confidenceLevel, confidenceLevel) || other.confidenceLevel == confidenceLevel)&&(identical(other.confidenceDots, confidenceDots) || other.confidenceDots == confidenceDots)&&(identical(other.sleepForecastReason, sleepForecastReason) || other.sleepForecastReason == sleepForecastReason)&&(identical(other.hasSleepLogs, hasSleepLogs) || other.hasSleepLogs == hasSleepLogs)&&(identical(other.hasMultiDayPatterns, hasMultiDayPatterns) || other.hasMultiDayPatterns == hasMultiDayPatterns)&&(identical(other.hasAnyLogs, hasAnyLogs) || other.hasAnyLogs == hasAnyLogs)&&(identical(other.loggedDaysCount, loggedDaysCount) || other.loggedDaysCount == loggedDaysCount)&&(identical(other.didForecastChangeSignificantly, didForecastChangeSignificantly) || other.didForecastChangeSignificantly == didForecastChangeSignificantly)&&(identical(other.forecastChangeReason, forecastChangeReason) || other.forecastChangeReason == forecastChangeReason)&&(identical(other.duplicateSleepLogDetected, duplicateSleepLogDetected) || other.duplicateSleepLogDetected == duplicateSleepLogDetected)&&(identical(other.showHealthHeadsUp, showHealthHeadsUp) || other.showHealthHeadsUp == showHealthHeadsUp)&&(identical(other.healthHeadsUpTitle, healthHeadsUpTitle) || other.healthHeadsUpTitle == healthHeadsUpTitle)&&(identical(other.healthHeadsUpSubtitle, healthHeadsUpSubtitle) || other.healthHeadsUpSubtitle == healthHeadsUpSubtitle)&&(identical(other.showBehaviourHeadsUp, showBehaviourHeadsUp) || other.showBehaviourHeadsUp == showBehaviourHeadsUp)&&(identical(other.headsUpHeadline, headsUpHeadline) || other.headsUpHeadline == headsUpHeadline)&&(identical(other.headsUpReason, headsUpReason) || other.headsUpReason == headsUpReason)&&(identical(other.headsUpWindowStart, headsUpWindowStart) || other.headsUpWindowStart == headsUpWindowStart)&&(identical(other.headsUpWindowEnd, headsUpWindowEnd) || other.headsUpWindowEnd == headsUpWindowEnd)&&(identical(other.showNiceWork, showNiceWork) || other.showNiceWork == showNiceWork)&&(identical(other.niceWorkTitle, niceWorkTitle) || other.niceWorkTitle == niceWorkTitle)&&(identical(other.niceWorkSubtitle, niceWorkSubtitle) || other.niceWorkSubtitle == niceWorkSubtitle)&&(identical(other.showNoticed, showNoticed) || other.showNoticed == showNoticed)&&(identical(other.noticedTitle, noticedTitle) || other.noticedTitle == noticedTitle)&&(identical(other.noticedDestination, noticedDestination) || other.noticedDestination == noticedDestination)&&(identical(other.showSupportOffer, showSupportOffer) || other.showSupportOffer == showSupportOffer)&&(identical(other.supportInconsistentDays, supportInconsistentDays) || other.supportInconsistentDays == supportInconsistentDays)&&(identical(other.onboardingFocusLine, onboardingFocusLine) || other.onboardingFocusLine == onboardingFocusLine)&&(identical(other.prioritiseSleepFirst, prioritiseSleepFirst) || other.prioritiseSleepFirst == prioritiseSleepFirst)&&(identical(other.instantResultTitle, instantResultTitle) || other.instantResultTitle == instantResultTitle)&&(identical(other.instantResultAction, instantResultAction) || other.instantResultAction == instantResultAction)&&(identical(other.instantResultActionSubtitle, instantResultActionSubtitle) || other.instantResultActionSubtitle == instantResultActionSubtitle)&&(identical(other.fellAsleepTime, fellAsleepTime) || other.fellAsleepTime == fellAsleepTime)&&(identical(other.wokeUpTime, wokeUpTime) || other.wokeUpTime == wokeUpTime)&&(identical(other.includeNaps, includeNaps) || other.includeNaps == includeNaps)&&const DeepCollectionEquality().equals(other.napDrafts, _napDrafts)&&(identical(other.showSleepUpdateErrors, showSleepUpdateErrors) || other.showSleepUpdateErrors == showSleepUpdateErrors)&&(identical(other.selectedChildMoodIndex, selectedChildMoodIndex) || other.selectedChildMoodIndex == selectedChildMoodIndex)&&(identical(other.selectedParentMood, selectedParentMood) || other.selectedParentMood == selectedParentMood)&&(identical(other.showMoodUpdateErrors, showMoodUpdateErrors) || other.showMoodUpdateErrors == showMoodUpdateErrors)&&(identical(other.tantrumWhatHappened, tantrumWhatHappened) || other.tantrumWhatHappened == tantrumWhatHappened)&&(identical(other.tantrumTime, tantrumTime) || other.tantrumTime == tantrumTime)&&(identical(other.tantrumIntensity, tantrumIntensity) || other.tantrumIntensity == tantrumIntensity)&&const DeepCollectionEquality().equals(other.selectedTantrumTriggers, _selectedTantrumTriggers)&&(identical(other.tantrumWhatHelped, tantrumWhatHelped) || other.tantrumWhatHelped == tantrumWhatHelped)&&(identical(other.showTantrumUpdateErrors, showTantrumUpdateErrors) || other.showTantrumUpdateErrors == showTantrumUpdateErrors)&&const DeepCollectionEquality().equals(other.selectedHealthIssues, _selectedHealthIssues)&&(identical(other.healthNotes, healthNotes) || other.healthNotes == healthNotes)&&(identical(other.showHealthUpdateErrors, showHealthUpdateErrors) || other.showHealthUpdateErrors == showHealthUpdateErrors)&&(identical(other.isNightWaking, isNightWaking) || other.isNightWaking == isNightWaking)&&(identical(other.sleepQualityIndex, sleepQualityIndex) || other.sleepQualityIndex == sleepQualityIndex)&&(identical(other.quickNoteText, quickNoteText) || other.quickNoteText == quickNoteText)&&(identical(other.showNotesUpdateErrors, showNotesUpdateErrors) || other.showNotesUpdateErrors == showNotesUpdateErrors));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,isLoading,isSuccess,saveStatus,activeChildId,mode,childName,parentName,timeOfDayGreeting,sleepForecastStart,sleepForecastEnd,bedtimeEstimate,forecastSubtitle,confidenceLevel,confidenceDots,sleepForecastReason,hasSleepLogs,hasMultiDayPatterns,hasAnyLogs,loggedDaysCount,didForecastChangeSignificantly,forecastChangeReason,duplicateSleepLogDetected,showHealthHeadsUp,healthHeadsUpTitle,healthHeadsUpSubtitle,showBehaviourHeadsUp,headsUpHeadline,headsUpReason,headsUpWindowStart,headsUpWindowEnd,showNiceWork,niceWorkTitle,niceWorkSubtitle,showNoticed,noticedTitle,noticedDestination,showSupportOffer,supportInconsistentDays,onboardingFocusLine,prioritiseSleepFirst,instantResultTitle,instantResultAction,instantResultActionSubtitle,fellAsleepTime,wokeUpTime,includeNaps,const DeepCollectionEquality().hash(_napDrafts),showSleepUpdateErrors,selectedChildMoodIndex,selectedParentMood,showMoodUpdateErrors,tantrumWhatHappened,tantrumTime,tantrumIntensity,const DeepCollectionEquality().hash(_selectedTantrumTriggers),tantrumWhatHelped,showTantrumUpdateErrors,const DeepCollectionEquality().hash(_selectedHealthIssues),healthNotes,showHealthUpdateErrors,isNightWaking,sleepQualityIndex,quickNoteText,showNotesUpdateErrors]);
}

@override
String toString() {
    return 'TodayState(isLoading: $isLoading, isSuccess: $isSuccess, saveStatus: $saveStatus, activeChildId: $activeChildId, mode: $mode, childName: $childName, parentName: $parentName, timeOfDayGreeting: $timeOfDayGreeting, sleepForecastStart: $sleepForecastStart, sleepForecastEnd: $sleepForecastEnd, bedtimeEstimate: $bedtimeEstimate, forecastSubtitle: $forecastSubtitle, confidenceLevel: $confidenceLevel, confidenceDots: $confidenceDots, sleepForecastReason: $sleepForecastReason, hasSleepLogs: $hasSleepLogs, hasMultiDayPatterns: $hasMultiDayPatterns, hasAnyLogs: $hasAnyLogs, loggedDaysCount: $loggedDaysCount, didForecastChangeSignificantly: $didForecastChangeSignificantly, forecastChangeReason: $forecastChangeReason, duplicateSleepLogDetected: $duplicateSleepLogDetected, showHealthHeadsUp: $showHealthHeadsUp, healthHeadsUpTitle: $healthHeadsUpTitle, healthHeadsUpSubtitle: $healthHeadsUpSubtitle, showBehaviourHeadsUp: $showBehaviourHeadsUp, headsUpHeadline: $headsUpHeadline, headsUpReason: $headsUpReason, headsUpWindowStart: $headsUpWindowStart, headsUpWindowEnd: $headsUpWindowEnd, showNiceWork: $showNiceWork, niceWorkTitle: $niceWorkTitle, niceWorkSubtitle: $niceWorkSubtitle, showNoticed: $showNoticed, noticedTitle: $noticedTitle, noticedDestination: $noticedDestination, showSupportOffer: $showSupportOffer, supportInconsistentDays: $supportInconsistentDays, onboardingFocusLine: $onboardingFocusLine, prioritiseSleepFirst: $prioritiseSleepFirst, instantResultTitle: $instantResultTitle, instantResultAction: $instantResultAction, instantResultActionSubtitle: $instantResultActionSubtitle, fellAsleepTime: $fellAsleepTime, wokeUpTime: $wokeUpTime, includeNaps: $includeNaps, napDrafts: $napDrafts, showSleepUpdateErrors: $showSleepUpdateErrors, selectedChildMoodIndex: $selectedChildMoodIndex, selectedParentMood: $selectedParentMood, showMoodUpdateErrors: $showMoodUpdateErrors, tantrumWhatHappened: $tantrumWhatHappened, tantrumTime: $tantrumTime, tantrumIntensity: $tantrumIntensity, selectedTantrumTriggers: $selectedTantrumTriggers, tantrumWhatHelped: $tantrumWhatHelped, showTantrumUpdateErrors: $showTantrumUpdateErrors, selectedHealthIssues: $selectedHealthIssues, healthNotes: $healthNotes, showHealthUpdateErrors: $showHealthUpdateErrors, isNightWaking: $isNightWaking, sleepQualityIndex: $sleepQualityIndex, quickNoteText: $quickNoteText, showNotesUpdateErrors: $showNotesUpdateErrors)';
}


}

/// @nodoc
abstract mixin class _$TodayStateCopyWith<$Res> implements $TodayStateCopyWith<$Res> {
  factory _$TodayStateCopyWith(_TodayState value, $Res Function(_TodayState) _then) = __$TodayStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isSuccess, ApiResultStatus<dynamic> saveStatus, String activeChildId, TodayMode mode, String childName, String parentName, String timeOfDayGreeting, String sleepForecastStart, String sleepForecastEnd, String bedtimeEstimate, String forecastSubtitle, String confidenceLevel, int confidenceDots, String sleepForecastReason, bool hasSleepLogs, bool hasMultiDayPatterns, bool hasAnyLogs, int loggedDaysCount, bool didForecastChangeSignificantly, String forecastChangeReason, SleepLogModel? duplicateSleepLogDetected, bool showHealthHeadsUp, String healthHeadsUpTitle, String healthHeadsUpSubtitle, bool showBehaviourHeadsUp, String headsUpHeadline, String headsUpReason, String headsUpWindowStart, String headsUpWindowEnd, bool showNiceWork, String niceWorkTitle, String niceWorkSubtitle, bool showNoticed, String noticedTitle, TodayNoticedDestination noticedDestination, bool showSupportOffer, int supportInconsistentDays, String onboardingFocusLine, bool prioritiseSleepFirst, String instantResultTitle, String instantResultAction, String instantResultActionSubtitle, String? fellAsleepTime, String? wokeUpTime, bool includeNaps, List<NapDraft> napDrafts, bool showSleepUpdateErrors, int selectedChildMoodIndex, String selectedParentMood, bool showMoodUpdateErrors, String tantrumWhatHappened, String? tantrumTime, double tantrumIntensity, List<String> selectedTantrumTriggers, String tantrumWhatHelped, bool showTantrumUpdateErrors, List<String> selectedHealthIssues, String healthNotes, bool showHealthUpdateErrors, bool isNightWaking, int sleepQualityIndex, String quickNoteText, bool showNotesUpdateErrors
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get saveStatus;

}
/// @nodoc
class __$TodayStateCopyWithImpl<$Res>
    implements _$TodayStateCopyWith<$Res> {
  __$TodayStateCopyWithImpl(this._self, this._then);

  final _TodayState _self;
  final $Res Function(_TodayState) _then;

/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isSuccess = null,Object? saveStatus = null,Object? activeChildId = null,Object? mode = null,Object? childName = null,Object? parentName = null,Object? timeOfDayGreeting = null,Object? sleepForecastStart = null,Object? sleepForecastEnd = null,Object? bedtimeEstimate = null,Object? forecastSubtitle = null,Object? confidenceLevel = null,Object? confidenceDots = null,Object? sleepForecastReason = null,Object? hasSleepLogs = null,Object? hasMultiDayPatterns = null,Object? hasAnyLogs = null,Object? loggedDaysCount = null,Object? didForecastChangeSignificantly = null,Object? forecastChangeReason = null,Object? duplicateSleepLogDetected = freezed,Object? showHealthHeadsUp = null,Object? healthHeadsUpTitle = null,Object? healthHeadsUpSubtitle = null,Object? showBehaviourHeadsUp = null,Object? headsUpHeadline = null,Object? headsUpReason = null,Object? headsUpWindowStart = null,Object? headsUpWindowEnd = null,Object? showNiceWork = null,Object? niceWorkTitle = null,Object? niceWorkSubtitle = null,Object? showNoticed = null,Object? noticedTitle = null,Object? noticedDestination = null,Object? showSupportOffer = null,Object? supportInconsistentDays = null,Object? onboardingFocusLine = null,Object? prioritiseSleepFirst = null,Object? instantResultTitle = null,Object? instantResultAction = null,Object? instantResultActionSubtitle = null,Object? fellAsleepTime = freezed,Object? wokeUpTime = freezed,Object? includeNaps = null,Object? napDrafts = null,Object? showSleepUpdateErrors = null,Object? selectedChildMoodIndex = null,Object? selectedParentMood = null,Object? showMoodUpdateErrors = null,Object? tantrumWhatHappened = null,Object? tantrumTime = freezed,Object? tantrumIntensity = null,Object? selectedTantrumTriggers = null,Object? tantrumWhatHelped = null,Object? showTantrumUpdateErrors = null,Object? selectedHealthIssues = null,Object? healthNotes = null,Object? showHealthUpdateErrors = null,Object? isNightWaking = null,Object? sleepQualityIndex = null,Object? quickNoteText = null,Object? showNotesUpdateErrors = null,}) {
  return _then(_TodayState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSuccess: null == isSuccess ? _self.isSuccess : isSuccess // ignore: cast_nullable_to_non_nullable
as bool,saveStatus: null == saveStatus ? _self.saveStatus : saveStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,activeChildId: null == activeChildId ? _self.activeChildId : activeChildId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TodayMode,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,parentName: null == parentName ? _self.parentName : parentName // ignore: cast_nullable_to_non_nullable
as String,timeOfDayGreeting: null == timeOfDayGreeting ? _self.timeOfDayGreeting : timeOfDayGreeting // ignore: cast_nullable_to_non_nullable
as String,sleepForecastStart: null == sleepForecastStart ? _self.sleepForecastStart : sleepForecastStart // ignore: cast_nullable_to_non_nullable
as String,sleepForecastEnd: null == sleepForecastEnd ? _self.sleepForecastEnd : sleepForecastEnd // ignore: cast_nullable_to_non_nullable
as String,bedtimeEstimate: null == bedtimeEstimate ? _self.bedtimeEstimate : bedtimeEstimate // ignore: cast_nullable_to_non_nullable
as String,forecastSubtitle: null == forecastSubtitle ? _self.forecastSubtitle : forecastSubtitle // ignore: cast_nullable_to_non_nullable
as String,confidenceLevel: null == confidenceLevel ? _self.confidenceLevel : confidenceLevel // ignore: cast_nullable_to_non_nullable
as String,confidenceDots: null == confidenceDots ? _self.confidenceDots : confidenceDots // ignore: cast_nullable_to_non_nullable
as int,sleepForecastReason: null == sleepForecastReason ? _self.sleepForecastReason : sleepForecastReason // ignore: cast_nullable_to_non_nullable
as String,hasSleepLogs: null == hasSleepLogs ? _self.hasSleepLogs : hasSleepLogs // ignore: cast_nullable_to_non_nullable
as bool,hasMultiDayPatterns: null == hasMultiDayPatterns ? _self.hasMultiDayPatterns : hasMultiDayPatterns // ignore: cast_nullable_to_non_nullable
as bool,hasAnyLogs: null == hasAnyLogs ? _self.hasAnyLogs : hasAnyLogs // ignore: cast_nullable_to_non_nullable
as bool,loggedDaysCount: null == loggedDaysCount ? _self.loggedDaysCount : loggedDaysCount // ignore: cast_nullable_to_non_nullable
as int,didForecastChangeSignificantly: null == didForecastChangeSignificantly ? _self.didForecastChangeSignificantly : didForecastChangeSignificantly // ignore: cast_nullable_to_non_nullable
as bool,forecastChangeReason: null == forecastChangeReason ? _self.forecastChangeReason : forecastChangeReason // ignore: cast_nullable_to_non_nullable
as String,duplicateSleepLogDetected: freezed == duplicateSleepLogDetected ? _self.duplicateSleepLogDetected : duplicateSleepLogDetected // ignore: cast_nullable_to_non_nullable
as SleepLogModel?,showHealthHeadsUp: null == showHealthHeadsUp ? _self.showHealthHeadsUp : showHealthHeadsUp // ignore: cast_nullable_to_non_nullable
as bool,healthHeadsUpTitle: null == healthHeadsUpTitle ? _self.healthHeadsUpTitle : healthHeadsUpTitle // ignore: cast_nullable_to_non_nullable
as String,healthHeadsUpSubtitle: null == healthHeadsUpSubtitle ? _self.healthHeadsUpSubtitle : healthHeadsUpSubtitle // ignore: cast_nullable_to_non_nullable
as String,showBehaviourHeadsUp: null == showBehaviourHeadsUp ? _self.showBehaviourHeadsUp : showBehaviourHeadsUp // ignore: cast_nullable_to_non_nullable
as bool,headsUpHeadline: null == headsUpHeadline ? _self.headsUpHeadline : headsUpHeadline // ignore: cast_nullable_to_non_nullable
as String,headsUpReason: null == headsUpReason ? _self.headsUpReason : headsUpReason // ignore: cast_nullable_to_non_nullable
as String,headsUpWindowStart: null == headsUpWindowStart ? _self.headsUpWindowStart : headsUpWindowStart // ignore: cast_nullable_to_non_nullable
as String,headsUpWindowEnd: null == headsUpWindowEnd ? _self.headsUpWindowEnd : headsUpWindowEnd // ignore: cast_nullable_to_non_nullable
as String,showNiceWork: null == showNiceWork ? _self.showNiceWork : showNiceWork // ignore: cast_nullable_to_non_nullable
as bool,niceWorkTitle: null == niceWorkTitle ? _self.niceWorkTitle : niceWorkTitle // ignore: cast_nullable_to_non_nullable
as String,niceWorkSubtitle: null == niceWorkSubtitle ? _self.niceWorkSubtitle : niceWorkSubtitle // ignore: cast_nullable_to_non_nullable
as String,showNoticed: null == showNoticed ? _self.showNoticed : showNoticed // ignore: cast_nullable_to_non_nullable
as bool,noticedTitle: null == noticedTitle ? _self.noticedTitle : noticedTitle // ignore: cast_nullable_to_non_nullable
as String,noticedDestination: null == noticedDestination ? _self.noticedDestination : noticedDestination // ignore: cast_nullable_to_non_nullable
as TodayNoticedDestination,showSupportOffer: null == showSupportOffer ? _self.showSupportOffer : showSupportOffer // ignore: cast_nullable_to_non_nullable
as bool,supportInconsistentDays: null == supportInconsistentDays ? _self.supportInconsistentDays : supportInconsistentDays // ignore: cast_nullable_to_non_nullable
as int,onboardingFocusLine: null == onboardingFocusLine ? _self.onboardingFocusLine : onboardingFocusLine // ignore: cast_nullable_to_non_nullable
as String,prioritiseSleepFirst: null == prioritiseSleepFirst ? _self.prioritiseSleepFirst : prioritiseSleepFirst // ignore: cast_nullable_to_non_nullable
as bool,instantResultTitle: null == instantResultTitle ? _self.instantResultTitle : instantResultTitle // ignore: cast_nullable_to_non_nullable
as String,instantResultAction: null == instantResultAction ? _self.instantResultAction : instantResultAction // ignore: cast_nullable_to_non_nullable
as String,instantResultActionSubtitle: null == instantResultActionSubtitle ? _self.instantResultActionSubtitle : instantResultActionSubtitle // ignore: cast_nullable_to_non_nullable
as String,fellAsleepTime: freezed == fellAsleepTime ? _self.fellAsleepTime : fellAsleepTime // ignore: cast_nullable_to_non_nullable
as String?,wokeUpTime: freezed == wokeUpTime ? _self.wokeUpTime : wokeUpTime // ignore: cast_nullable_to_non_nullable
as String?,includeNaps: null == includeNaps ? _self.includeNaps : includeNaps // ignore: cast_nullable_to_non_nullable
as bool,napDrafts: null == napDrafts ? _self._napDrafts : napDrafts // ignore: cast_nullable_to_non_nullable
as List<NapDraft>,showSleepUpdateErrors: null == showSleepUpdateErrors ? _self.showSleepUpdateErrors : showSleepUpdateErrors // ignore: cast_nullable_to_non_nullable
as bool,selectedChildMoodIndex: null == selectedChildMoodIndex ? _self.selectedChildMoodIndex : selectedChildMoodIndex // ignore: cast_nullable_to_non_nullable
as int,selectedParentMood: null == selectedParentMood ? _self.selectedParentMood : selectedParentMood // ignore: cast_nullable_to_non_nullable
as String,showMoodUpdateErrors: null == showMoodUpdateErrors ? _self.showMoodUpdateErrors : showMoodUpdateErrors // ignore: cast_nullable_to_non_nullable
as bool,tantrumWhatHappened: null == tantrumWhatHappened ? _self.tantrumWhatHappened : tantrumWhatHappened // ignore: cast_nullable_to_non_nullable
as String,tantrumTime: freezed == tantrumTime ? _self.tantrumTime : tantrumTime // ignore: cast_nullable_to_non_nullable
as String?,tantrumIntensity: null == tantrumIntensity ? _self.tantrumIntensity : tantrumIntensity // ignore: cast_nullable_to_non_nullable
as double,selectedTantrumTriggers: null == selectedTantrumTriggers ? _self._selectedTantrumTriggers : selectedTantrumTriggers // ignore: cast_nullable_to_non_nullable
as List<String>,tantrumWhatHelped: null == tantrumWhatHelped ? _self.tantrumWhatHelped : tantrumWhatHelped // ignore: cast_nullable_to_non_nullable
as String,showTantrumUpdateErrors: null == showTantrumUpdateErrors ? _self.showTantrumUpdateErrors : showTantrumUpdateErrors // ignore: cast_nullable_to_non_nullable
as bool,selectedHealthIssues: null == selectedHealthIssues ? _self._selectedHealthIssues : selectedHealthIssues // ignore: cast_nullable_to_non_nullable
as List<String>,healthNotes: null == healthNotes ? _self.healthNotes : healthNotes // ignore: cast_nullable_to_non_nullable
as String,showHealthUpdateErrors: null == showHealthUpdateErrors ? _self.showHealthUpdateErrors : showHealthUpdateErrors // ignore: cast_nullable_to_non_nullable
as bool,isNightWaking: null == isNightWaking ? _self.isNightWaking : isNightWaking // ignore: cast_nullable_to_non_nullable
as bool,sleepQualityIndex: null == sleepQualityIndex ? _self.sleepQualityIndex : sleepQualityIndex // ignore: cast_nullable_to_non_nullable
as int,quickNoteText: null == quickNoteText ? _self.quickNoteText : quickNoteText // ignore: cast_nullable_to_non_nullable
as String,showNotesUpdateErrors: null == showNotesUpdateErrors ? _self.showNotesUpdateErrors : showNotesUpdateErrors // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TodayState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get saveStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.saveStatus, (value) {
    return _then(_self.copyWith(saveStatus: value));
  });
}
}

// dart format on
