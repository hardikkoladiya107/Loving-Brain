import 'package:loving_brain/generated/locale_keys.g.dart';

/// Local-time greeting for the home hero card.
///
/// Buckets: morning (05–12), afternoon (12–17), evening (17–21),
/// night (21–05) — late evening and small hours use "Good night".
String homeGreetingLocaleKey(DateTime localNow) {
  final int hour = localNow.hour;
  if (hour >= 5 && hour < 12) {
    return LocaleKeys.homeGreetingGoodMorning;
  }
  if (hour >= 12 && hour < 17) {
    return LocaleKeys.homeGreetingGoodAfternoon;
  }
  if (hour >= 17 && hour < 21) {
    return LocaleKeys.homeGreetingGoodEvening;
  }
  return LocaleKeys.homeGreetingGoodNight;
}
