class EnergyBridgeRules {
  EnergyBridgeRules._();

  static bool isHighEnergy(String value) {
    final String normalized = value.trim().toLowerCase();
    return normalized == 'high energy' ||
        normalized == 'high_energy' ||
        normalized == 'hyper' ||
        normalized == 'overactive';
  }

  static bool isResetMood(String value) {
    final String normalized = value.trim().toLowerCase();
    return normalized == 'calm' ||
        normalized == 'fussy' ||
        normalized == 'tired';
  }

  static bool isFeedOrSleep(String value) {
    final String normalized = value.trim().toLowerCase();
    return normalized.contains('feed') || normalized.contains('sleep');
  }
}
