import 'dart:io';

void main() {
  var file = File('lib/ui/auth/otp/otp_screen.dart');
  var content = file.readAsStringSync();
  
  content = content.replaceAll(
    '''                          onSuccess: () {
                            context.go(RoutePaths.onboarding);
                          },''',
    '''                          onSuccess: () {
                            final user = preferences.getUserModel();
                            if (user != null && 
                                (user.parentName ?? '').isNotEmpty && 
                                user.defaultChild != null) {
                              preferences.putBool(SharedPreference.isLogin, true);
                              context.go(RoutePaths.base);
                            } else {
                              context.go(RoutePaths.onboarding);
                            }
                          },'''
  );

  file.writeAsStringSync(content);
  print('Patched otp_screen.dart');
}
