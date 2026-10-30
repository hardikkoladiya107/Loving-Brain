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
  static const String sleepForecast = '/sleep-forecast';
  static const String sleepDetails = '/sleep-details';
  static const String consistencyRecognition = '/consistency-recognition';
  static const String addChild = '/add-child';

  // Sprint 3, 4, 5, 6 & V2 Feature paths
  static const String brainyConversation = '/brainy-conversation';
  static const String brainyHistory = '/brainy-history';
  static const String brainySaved = '/brainy-saved';
  static const String helpSafety = '/help-safety';
  static const String behaviourPattern = '/behaviour-pattern';
  static const String calmHeadsUp = '/calm-heads-up';
  static const String afterReflection = '/after-reflection';
  static const String chooseSupportArea = '/choose-support-area';
  static const String guideList = '/guide-list';
  static const String guideProfile = '/guide-profile';
  static const String requestSession = '/request-session';
  static const String parentSuccessGuide = '/parent-success-guide';
  static const String postSessionPlan = '/post-session-plan';
  static const String programmeDetail = '/programme-detail';
  static const String enrolledJourney = '/enrolled-journey';
  static const String programRecommendation = '/program-recommendation';
  static const String mentorshipUnavailable = '/mentorship-unavailable';
  static const String familyTimeline = '/family-timeline';
  static const String familyMenu = '/family-menu';
  static const String permissions = '/permissions';
  static const String inviteCaregiver = '/invite-caregiver';
  static const String invitePending = '/invite-pending';
  static const String inviteAccepted = '/invite-accepted';
  static const String familySharingConsent = '/family-sharing-consent';
  static const String sharedChildSummary = '/shared-child-summary';
  static const String harderWeek = '/harder-week';
  static const String tryingThisWeek = '/trying-this-week';
  static const String sleepPattern = '/sleep-pattern';
  static const String sleepNoData = '/sleep-no-data';
  static const String sleepLowConfidence = '/sleep-low-confidence';
  static const String notifications = '/notifications';
  static const String privacyData = '/privacy-data';
  static const String statesGallery = '/states-gallery';
  static const String loadingSkeleton = '/loading-skeleton';

  static String childProfilePath(
    String userId, {
    bool fromManageChildren = false,
  }) {
    return '/child-profile/$userId?fromManageChildren=$fromManageChildren';
  }
}
