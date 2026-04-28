class RoutePaths {
  RoutePaths._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String onboarding1 = '/onboarding-1';
  static const String onboarding2 = '/onboarding-2';
  static const String onboarding3 = '/onboarding-3';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String terms = '/terms';
  static const String privacy = '/privacy';
  static const String parentProfile = '/parent-profile';
  static const String childProfile = '/child-profile/:userId';
  static const String base = '/base';

  static String childProfilePath(
    String userId, {
    bool fromManageChildren = false,
  }) {
    return '/child-profile/$userId?fromManageChildren=$fromManageChildren';
  }
}
