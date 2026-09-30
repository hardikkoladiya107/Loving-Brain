import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loving_brain/model/location_data_model.dart';
import 'package:loving_brain/other/app_color.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/app_button.dart';
import 'package:loving_brain/ui/widget/app_text_field.dart';
import 'package:loving_brain/ui/widget/base_button.dart';

/// Shows the shared Location & Timezone picker bottom sheet with live API
/// autocomplete suggestions and commonly used quick locations.
Future<LocationDataModel?> showLocationPickerSheet(
  BuildContext context, {
  String? initialLocation,
  LocationDataModel? initialLocationData,
  ValueChanged<LocationDataModel>? onLocationSelected,
}) {
  return showModalBottomSheet<LocationDataModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      return LocationPickerSheet(
        initialLocation: initialLocation,
        initialLocationData: initialLocationData,
        onLocationSelected: onLocationSelected,
      );
    },
  );
}

class LocationPickerSheet extends StatefulWidget {
  const LocationPickerSheet({
    super.key,
    this.initialLocation,
    this.initialLocationData,
    this.onLocationSelected,
  });

  final String? initialLocation;
  final LocationDataModel? initialLocationData;
  final ValueChanged<LocationDataModel>? onLocationSelected;

  @override
  State<LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<LocationPickerSheet> {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
    ),
  );
  late final TextEditingController _searchController;
  Timer? _debounce;
  CancelToken? _cancelToken;

  LocationDataModel? _selectedLocation;
  List<LocationDataModel> _suggestions = const <LocationDataModel>[];
  bool _isSearching = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _selectedLocation =
        widget.initialLocationData ??
        LocationDataModel.tryParse(widget.initialLocation);
    _searchController = TextEditingController(
      text: _selectedLocation?.formatted ?? (widget.initialLocation ?? ''),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _cancelToken?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String rawQuery) {
    final String query = rawQuery.trim();
    setState(() {
      // Typing invalidates the previous selection until a suggestion or chip is chosen
      if (_selectedLocation != null &&
          _selectedLocation!.formatted != rawQuery.trim()) {
        _selectedLocation = null;
      }
      _validationError = null;
    });

    _debounce?.cancel();
    _cancelToken?.cancel();

    if (query.length < 2) {
      setState(() {
        _suggestions = const <LocationDataModel>[];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    _debounce = Timer(const Duration(milliseconds: 320), () {
      _fetchLocationSuggestions(query);
    });
  }

  Future<void> _fetchLocationSuggestions(String query) async {
    _cancelToken?.cancel();
    final CancelToken token = CancelToken();
    _cancelToken = token;

    try {
      final Response<dynamic> response = await _dio.get<dynamic>(
        'https://geocoding-api.open-meteo.com/v1/search',
        queryParameters: <String, dynamic>{
          'name': query,
          'count': 8,
          'language': 'en',
          'format': 'json',
        },
        cancelToken: token,
      );

      if (!mounted || token.isCancelled) return;

      final List<LocationDataModel> parsed = <LocationDataModel>[];
      final Set<String> seenKeys = <String>{};
      final dynamic data = response.data;
      if (data is Map && data['results'] is List) {
        for (final dynamic item in data['results'] as List<dynamic>) {
          if (item is Map) {
            final LocationDataModel loc =
                LocationDataModel.fromOpenMeteoJson(
                  Map<String, dynamic>.from(item),
                );
            final String dedupeKey =
                '${loc.city.toLowerCase()}_${loc.state?.toLowerCase() ?? ''}_${loc.country.toLowerCase()}';
            if (loc.city.isNotEmpty && seenKeys.add(dedupeKey)) {
              parsed.add(loc);
            }
          }
        }
      }

      // Also include any matching commonly used locations if API returned few results
      if (parsed.isEmpty) {
        final String lower = query.toLowerCase();
        for (final LocationDataModel preset
            in LocationDataModel.commonlyUsedLocations) {
          if (preset.city.toLowerCase().contains(lower) ||
              preset.country.toLowerCase().contains(lower) ||
              preset.formatted.toLowerCase().contains(lower)) {
            parsed.add(preset);
          }
        }
      }

      setState(() {
        _suggestions = parsed;
        _isSearching = false;
      });
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        return;
      }
      if (!mounted) return;
      final String lower = query.toLowerCase();
      final List<LocationDataModel> fallback = LocationDataModel
          .commonlyUsedLocations
          .where(
            (LocationDataModel preset) =>
                preset.city.toLowerCase().contains(lower) ||
                preset.country.toLowerCase().contains(lower) ||
                preset.formatted.toLowerCase().contains(lower),
          )
          .toList();
      setState(() {
        _suggestions = fallback;
        _isSearching = false;
      });
    }
  }

  void _selectLocation(LocationDataModel location) {
    FocusScope.of(context).unfocus();
    _debounce?.cancel();
    _cancelToken?.cancel();
    setState(() {
      _selectedLocation = location;
      _searchController.text = location.formatted;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
      _suggestions = const <LocationDataModel>[];
      _isSearching = false;
      _validationError = null;
    });
  }

  void _confirmSelection() {
    if (_selectedLocation == null) {
      setState(() {
        _validationError =
            'Please select a location from the suggestions or commonly used cities.';
      });
      return;
    }
    widget.onLocationSelected?.call(_selectedLocation!);
    Navigator.of(context).pop(_selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 28.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF8F4),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: greyColor2,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              18.spaceH,
              'Location & Timezone'.appText(
                fraunces: true,
                fontSize: 22,
                color: greyColor9,
                textAlign: TextAlign.start,
              ),
              6.spaceH,
              'Type your city and select a suggestion to set your location and timezone.'
                  .appText(
                    fontSize: 13,
                    color: greyColor6,
                    textAlign: TextAlign.start,
                  ),
              16.spaceH,
              AppTextField(
                controller: _searchController,
                title: 'Location & Timezone',
                hint: 'Search city (e.g. London, Mumbai, New York)',
                border: Border.all(
                  color: _validationError != null
                      ? Colors.red
                      : (_selectedLocation != null
                            ? secondaryColor
                            : greyColor2),
                  width: _selectedLocation != null ? 1.5 : 1,
                ),
                error: _validationError,
                onChanged: _onSearchChanged,
                suffixIcon: _isSearching
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: primaryColor,
                        ),
                      )
                    : (_selectedLocation != null
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(4.r),
                                  decoration: const BoxDecoration(
                                    color: secondaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 14.sp,
                                  ),
                                ),
                                6.spaceW,
                                BaseButton(
                                  onTap: () {
                                    setState(() {
                                      _searchController.clear();
                                      _selectedLocation = null;
                                      _suggestions =
                                          const <LocationDataModel>[];
                                      _validationError = null;
                                    });
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: greyColor4,
                                    size: 20.sp,
                                  ),
                                ),
                              ],
                            )
                          : (_searchController.text.isNotEmpty
                                ? BaseButton(
                                    onTap: () {
                                      setState(() {
                                        _searchController.clear();
                                        _selectedLocation = null;
                                        _suggestions =
                                            const <LocationDataModel>[];
                                        _validationError = null;
                                      });
                                    },
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: greyColor4,
                                      size: 20.sp,
                                    ),
                                  )
                                : Icon(
                                    Icons.search_rounded,
                                    color: greyColor4,
                                    size: 20.sp,
                                  ))),
              ),
              if (_suggestions.isNotEmpty) ...<Widget>[
                12.spaceH,
                Container(
                  constraints: BoxConstraints(maxHeight: 220.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: greyColor2),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    itemCount: _suggestions.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 1,
                      color: greyColor2.withValues(alpha: 0.5),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final LocationDataModel item = _suggestions[index];
                      return InkWell(
                        onTap: () => _selectLocation(item),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 10.h,
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 34.r,
                                height: 34.r,
                                decoration: BoxDecoration(
                                  color: softPeachOrange,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: primaryColor,
                                  size: 18.sp,
                                ),
                              ),
                              12.spaceW,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    item.formatted.appText(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: greyColor9,
                                      textAlign: TextAlign.start,
                                    ),
                                    2.spaceH,
                                    item.subtitle.appText(
                                      fontSize: 11,
                                      color: greyColor6,
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ] else if (!_isSearching &&
                  _selectedLocation == null &&
                  _searchController.text.trim().length >= 2) ...<Widget>[
                10.spaceH,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: 'No matching cities found. Try another city name.'
                      .appText(
                        fontSize: 12,
                        color: greyColor6,
                        textAlign: TextAlign.start,
                      ),
                ),
              ],
              16.spaceH,
              'COMMONLY USED'.appText(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: greyColor4,
                letterSpacing: 0.8,
                textAlign: TextAlign.start,
              ),
              10.spaceH,
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: LocationDataModel.commonlyUsedLocations.map((
                  LocationDataModel preset,
                ) {
                  final String chipLabel =
                      '${preset.city} · ${preset.gmtOffset}';
                  final bool isSelected =
                      _selectedLocation != null &&
                      _selectedLocation!.city.toLowerCase() ==
                          preset.city.toLowerCase() &&
                      _selectedLocation!.country.toLowerCase() ==
                          preset.country.toLowerCase();
                  return BaseButton(
                    onTap: () => _selectLocation(preset),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? secondaryColor.withValues(alpha: 0.12)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? secondaryColor : greyColor2,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: chipLabel.appText(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected ? secondaryColor : greyColor9,
                      ),
                    ),
                  );
                }).toList(),
              ),
              22.spaceH,
              AppButton(
                title: 'Save location',
                padding: EdgeInsets.zero,
                onTap: _confirmSelection,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
