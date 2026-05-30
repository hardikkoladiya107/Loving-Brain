import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', useConstantCase: true)
abstract class Env {
  @EnviedField(varName: 'BREVO_API_KEY', obfuscate: true)
  static final String brevoApiKey = _Env.brevoApiKey;
}
