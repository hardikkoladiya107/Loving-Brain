class RoutePaths {
  RoutePaths._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String onboarding1 = '/onboarding-1';
  static const String onboarding2 = '/onboarding-2';
  static const String onboarding3 = '/onboarding-3';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String terms = '/terms';
  static const String privacy = '/privacy';
  static const String parentProfile = '/parent-profile';
  static const String childProfile = '/child-profile/:userId';
  static const String base = '/base';

  // New paths
  static const String subscription = '/subscription';
  static const String dailyMoodCheckIn = '/daily-mood-check-in';
  static const String dailyMoodLog = '/daily-mood-log';
  static const String schedule = '/schedule';
  static const String chatList = '/chat-list';
  static const String writeYourThought = '/write-your-thought';
  static const String manageChildren = '/manage-children';
  static const String eventDetail = '/event-detail';
  static const String eventApproval = '/event-approval';
  static const String aiChat = '/ai-chat';
  static const String yourStreak = '/your-streak';
  static const String essentials = '/essentials';
  static const String energyBridge = '/energy-bridge';
  static const String sleepSummary = '/sleep-summary';
  static const String newBehavior = '/new-behavior';
  static const String reflectYourEmotions = '/reflect-your-emotions';
  static const String familyMeterStateDetail = '/family-meter-state-detail';
  static const String familyMeterStatePicker = '/family-meter-state-picker';
  static const String smartMoment = '/smart-moment';
  static const String helpProblemSelection = '/help-problem-selection';
  static const String helpGuidance = '/help-guidance';
  static const String proposeChange = '/propose-change';
  static const String thoughtList = '/thought-list';
  static const String chatDetail = '/chat-detail';
  static const String addSharedEvent = '/add-shared-event';
  static const String linkCoParent = '/link-co-parent';
  static const String successScreen = '/success-screen';
  static const String baseScreen = '/base';
  static const String coParentRegister = '/co-parent-register';
  static const String timeline = '/timeline';
  static const String milestoneStory = '/milestone-story';

  static String childProfilePath(
    String userId, {
    bool fromManageChildren = false,
  }) {
    return '/child-profile/$userId?fromManageChildren=$fromManageChildren';
  }
}
