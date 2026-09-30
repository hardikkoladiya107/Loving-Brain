import 'dart:convert';

import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class LocationDataModel {
  const LocationDataModel({
    required this.city,
    this.state,
    required this.country,
    this.countryCode,
    required this.timezone,
    required this.gmtOffset,
    this.latitude,
    this.longitude,
    required this.formatted,
  });

  final String city;
  final String? state;
  final String country;
  final String? countryCode;
  final String timezone;
  final String gmtOffset;
  final double? latitude;
  final double? longitude;
  final String formatted;

  static bool _tzInitialized = false;

  static void _ensureTimezonesInitialized() {
    if (_tzInitialized) return;
    try {
      tz_data.initializeTimeZones();
      _tzInitialized = true;
    } catch (_) {
      _tzInitialized = true;
    }
  }

  /// Computes a human-readable GMT offset like `"GMT+5:30"` or `"GMT-5"`
  /// from an IANA timezone identifier such as `"Asia/Kolkata"`.
  static String computeGmtOffset(String timezoneId) {
    if (timezoneId.trim().isEmpty) return 'GMT+0';
    _ensureTimezonesInitialized();
    try {
      final tz.Location loc = tz.getLocation(timezoneId.trim());
      final tz.TZDateTime now = tz.TZDateTime.now(loc);
      final Duration offset = now.timeZoneOffset;
      final bool isNegative = offset.isNegative;
      final int totalMinutes = offset.inMinutes.abs();
      final int hours = totalMinutes ~/ 60;
      final int minutes = totalMinutes % 60;
      final String sign = isNegative ? '-' : '+';
      if (minutes == 0) {
        return 'GMT$sign$hours';
      }
      final String minStr = minutes.toString().padLeft(2, '0');
      return 'GMT$sign$hours:$minStr';
    } catch (_) {
      return 'GMT+0';
    }
  }

  /// Subtitle showing state/region, country, and IANA timezone.
  String get subtitle {
    final List<String> parts = <String>[
      if (state != null &&
          state!.trim().isNotEmpty &&
          state!.trim().toLowerCase() != city.trim().toLowerCase())
        state!.trim(),
      if (country.trim().isNotEmpty) country.trim(),
    ];
    final String region = parts.join(', ');
    if (region.isEmpty) return timezone;
    return '$region · $timezone';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'city': city,
      if (state != null && state!.isNotEmpty) 'state': state,
      'country': country,
      if (countryCode != null && countryCode!.isNotEmpty)
        'country_code': countryCode,
      'timezone': timezone,
      'gmt_offset': gmtOffset,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'formatted': formatted,
    };
  }

  factory LocationDataModel.fromJson(Map<String, dynamic> json) {
    final String city = (json['city'] ?? json['name'] ?? '').toString().trim();
    final String? state = json['state']?.toString().trim();
    final String country = (json['country'] ?? '').toString().trim();
    final String? countryCode = json['country_code']?.toString().trim();
    final String timezone = (json['timezone'] ?? 'UTC').toString().trim();
    final String gmtOffset =
        (json['gmt_offset']?.toString().trim().isNotEmpty ?? false)
        ? json['gmt_offset'].toString().trim()
        : computeGmtOffset(timezone);
    final double? latitude = json['latitude'] is num
        ? (json['latitude'] as num).toDouble()
        : double.tryParse(json['latitude']?.toString() ?? '');
    final double? longitude = json['longitude'] is num
        ? (json['longitude'] as num).toDouble()
        : double.tryParse(json['longitude']?.toString() ?? '');

    String formatted = (json['formatted'] ?? '').toString().trim();
    if (formatted.isEmpty) {
      if (city.isNotEmpty && country.isNotEmpty) {
        formatted = '$city, $country · $gmtOffset';
      } else if (city.isNotEmpty) {
        formatted = '$city · $gmtOffset';
      } else {
        formatted = gmtOffset;
      }
    }

    return LocationDataModel(
      city: city.isNotEmpty ? city : formatted.split('·').first.trim(),
      state: (state != null && state.isNotEmpty) ? state : null,
      country: country,
      countryCode: (countryCode != null && countryCode.isNotEmpty)
          ? countryCode
          : null,
      timezone: timezone,
      gmtOffset: gmtOffset,
      latitude: latitude,
      longitude: longitude,
      formatted: formatted,
    );
  }

  factory LocationDataModel.fromOpenMeteoJson(Map<String, dynamic> json) {
    final String city = (json['name'] ?? '').toString().trim();
    final String? admin1 = json['admin1']?.toString().trim();
    final String country = (json['country'] ?? '').toString().trim();
    final String? countryCode = json['country_code']?.toString().trim();
    final String timezone = (json['timezone'] ?? 'UTC').toString().trim();
    final String gmtOffset = computeGmtOffset(timezone);
    final double? latitude = json['latitude'] is num
        ? (json['latitude'] as num).toDouble()
        : null;
    final double? longitude = json['longitude'] is num
        ? (json['longitude'] as num).toDouble()
        : null;

    final String placeLabel = country.isNotEmpty ? '$city, $country' : city;
    final String formatted = '$placeLabel · $gmtOffset';

    return LocationDataModel(
      city: city,
      state: (admin1 != null && admin1.isNotEmpty) ? admin1 : null,
      country: country,
      countryCode: (countryCode != null && countryCode.isNotEmpty)
          ? countryCode
          : null,
      timezone: timezone,
      gmtOffset: gmtOffset,
      latitude: latitude,
      longitude: longitude,
      formatted: formatted,
    );
  }

  /// Parses either a `Map<String, dynamic>`, a JSON string, or a legacy display string.
  static LocationDataModel? tryParse(dynamic raw) {
    if (raw == null) return null;
    if (raw is LocationDataModel) return raw;
    if (raw is Map) {
      return LocationDataModel.fromJson(Map<String, dynamic>.from(raw));
    }
    final String str = raw.toString().trim();
    if (str.isEmpty || str == 'null') return null;

    if (str.startsWith('{') && str.endsWith('}')) {
      try {
        final dynamic decoded = jsonDecode(str);
        if (decoded is Map) {
          return LocationDataModel.fromJson(Map<String, dynamic>.from(decoded));
        }
      } catch (_) {}
    }

    return fromLegacyString(str);
  }

  static LocationDataModel fromLegacyString(String raw) {
    final String trimmed = raw.trim();
    for (final LocationDataModel preset in commonlyUsedLocations) {
      if (preset.formatted.toLowerCase() == trimmed.toLowerCase() ||
          '${preset.city} · ${preset.gmtOffset}'.toLowerCase() ==
              trimmed.toLowerCase() ||
          preset.city.toLowerCase() == trimmed.toLowerCase()) {
        return preset;
      }
    }

    final List<String> parts = trimmed.split('·');
    final String placePart = parts.first.trim();
    final String gmtPart = parts.length > 1 ? parts.last.trim() : 'GMT+0';
    final List<String> placeTokens = placePart
        .split(',')
        .map((String e) => e.trim())
        .where((String e) => e.isNotEmpty)
        .toList();
    final String city = placeTokens.isNotEmpty ? placeTokens.first : trimmed;
    final String country = placeTokens.length > 1 ? placeTokens.last : '';

    return LocationDataModel(
      city: city,
      country: country,
      timezone: 'UTC',
      gmtOffset: gmtPart,
      formatted: trimmed,
    );
  }

  static const List<LocationDataModel> commonlyUsedLocations =
      <LocationDataModel>[
        LocationDataModel(
          city: 'London',
          state: 'England',
          country: 'United Kingdom',
          countryCode: 'GB',
          timezone: 'Europe/London',
          gmtOffset: 'GMT+0',
          latitude: 51.50853,
          longitude: -0.12574,
          formatted: 'London, United Kingdom · GMT+0',
        ),
        LocationDataModel(
          city: 'New York',
          state: 'New York',
          country: 'United States',
          countryCode: 'US',
          timezone: 'America/New_York',
          gmtOffset: 'GMT-5',
          latitude: 40.71427,
          longitude: -74.00597,
          formatted: 'New York, United States · GMT-5',
        ),
        LocationDataModel(
          city: 'Los Angeles',
          state: 'California',
          country: 'United States',
          countryCode: 'US',
          timezone: 'America/Los_Angeles',
          gmtOffset: 'GMT-8',
          latitude: 34.05223,
          longitude: -118.24368,
          formatted: 'Los Angeles, United States · GMT-8',
        ),
        LocationDataModel(
          city: 'Sydney',
          state: 'New South Wales',
          country: 'Australia',
          countryCode: 'AU',
          timezone: 'Australia/Sydney',
          gmtOffset: 'GMT+10',
          latitude: -33.86785,
          longitude: 151.20732,
          formatted: 'Sydney, Australia · GMT+10',
        ),
        LocationDataModel(
          city: 'Toronto',
          state: 'Ontario',
          country: 'Canada',
          countryCode: 'CA',
          timezone: 'America/Toronto',
          gmtOffset: 'GMT-5',
          latitude: 43.70011,
          longitude: -79.4163,
          formatted: 'Toronto, Canada · GMT-5',
        ),
        LocationDataModel(
          city: 'Mumbai',
          state: 'Maharashtra',
          country: 'India',
          countryCode: 'IN',
          timezone: 'Asia/Kolkata',
          gmtOffset: 'GMT+5:30',
          latitude: 19.07283,
          longitude: 72.88261,
          formatted: 'Mumbai, India · GMT+5:30',
        ),
        LocationDataModel(
          city: 'Singapore',
          country: 'Singapore',
          countryCode: 'SG',
          timezone: 'Asia/Singapore',
          gmtOffset: 'GMT+8',
          latitude: 1.28967,
          longitude: 103.85007,
          formatted: 'Singapore · GMT+8',
        ),
        LocationDataModel(
          city: 'Dubai',
          state: 'Dubai',
          country: 'United Arab Emirates',
          countryCode: 'AE',
          timezone: 'Asia/Dubai',
          gmtOffset: 'GMT+4',
          latitude: 25.0657,
          longitude: 55.17128,
          formatted: 'Dubai, United Arab Emirates · GMT+4',
        ),
      ];
}
