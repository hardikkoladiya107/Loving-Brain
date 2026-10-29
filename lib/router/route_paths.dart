class RoutePaths {
  RoutePaths._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String onboarding = '/onboarding';
  static const String onboardingSnapshot = '/onboarding-snapshot';

  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String terms = '/terms';
  static const String privacy = '/privacy';
  static const String faq = '/faq';
  static const String parentProfile = '/parent-profile';
  static const String childProfile = '/child-profile/:userId';
  static const String base = '/base';

  // Active V2 paths
  static const String subscription = '/subscription';
  static const String essentials = '/essentials';
  static const String allergies = '/allergies';
  static const String medications = '/medications';
  static const String helpProblemSelection = '/help-problem-selection';
  static const String helpGuidance = '/help-guidance';
  static const String successScreen = '/success-screen';
  static const String baseScreen = '/base';
  static const String familySnapshot = '/family-snapshot';
  static const String notificationsPermission = '/permission-notifications';
  static const String microphonePermission = '/permission-microphone';
  static const String tonightsPlan = '/tonights-plan';
  static const String calmPlan = '/calm-plan';
  static const String weeklyReview = '/weekly-review';
  static const String sessionConfirmation = '/session-confirmation';
  static const String quickUpdate = '/quick-update';
  static const String mentorshipLanding = '/mentorship-landing';

  static String childProfilePath(
    String userId, {
    bool fromManageChildren = false,
  }) {
    return '/child-profile/$userId?fromManageChildren=$fromManageChildren';
  }
}
