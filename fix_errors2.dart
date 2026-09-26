import 'dart:io';

void main() {
  final file = File('lib/ui/onboarding/onboarding_screen.dart');
  var content = file.readAsStringSync();
  
  // 3. Location Container
  content = content.replaceFirst(
    '''
            GestureDetector(
              onTap: () => _showChangeLocationSheet(context, state.location),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.r),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: greyColor2),
                  color: const Color(0xFFF8F9FA),
                ),
''',
    '''
            GestureDetector(
              onTap: () { 
                _showChangeLocationSheet(context, state.location);
                if (_locationError.isNotEmpty) setState(() => _locationError = "");
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.r),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: _locationError.isNotEmpty ? Colors.redAccent : greyColor2),
                  color: const Color(0xFFF8F9FA),
                ),
'''
  );

  content = content.replaceFirst(
    '''
                    const Icon(Icons.arrow_forward_ios, size: 16, color: greyColor),
                  ],
                ),
              ),
            ),
''',
    '''
                    const Icon(Icons.arrow_forward_ios, size: 16, color: greyColor),
                  ],
                ),
              ),
            ),
            if (_locationError.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 36.r, top: 6.h, right: 20.r),
                child: _locationError.appText(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                  textAlign: TextAlign.start,
                ),
              ),
'''
  );

  // 4. DOB Container
  content = content.replaceFirst(
    '''
            GestureDetector(
              onTap: () => _pickDate(context, context.read<OnboardingCubit>()),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.r),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: greyColor2),
                  color: const Color(0xFFF8F9FA),
                ),
''',
    '''
            GestureDetector(
              onTap: () {
                _pickDate(context, context.read<OnboardingCubit>());
                if (_childDobError.isNotEmpty) setState(() => _childDobError = "");
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.r),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: _childDobError.isNotEmpty ? Colors.redAccent : greyColor2),
                  color: const Color(0xFFF8F9FA),
                ),
'''
  );

  content = content.replaceFirst(
    '''
                    // TODO: Add calendar icon here
                    const Icon(Icons.calendar_today_outlined,
                        size: 20, color: greyColor),
                  ],
                ),
              ),
            ),
''',
    '''
                    // TODO: Add calendar icon here
                    const Icon(Icons.calendar_today_outlined,
                        size: 20, color: greyColor),
                  ],
                ),
              ),
            ),
            if (_childDobError.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 36.r, top: 6.h, right: 20.r),
                child: _childDobError.appText(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                  textAlign: TextAlign.start,
                ),
              ),
'''
  );

  // 5. Wake Time Container
  content = content.replaceFirst(
    '''
                        GestureDetector(
                          onTap: () => _pickTime(
                              context, context.read<OnboardingCubit>(), true),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: greyColor2),
                              color: const Color(0xFFF8F9FA),
                            ),
''',
    '''
                        GestureDetector(
                          onTap: () {
                            _pickTime(context, context.read<OnboardingCubit>(), true);
                            if (_wakeTimeError.isNotEmpty) setState(() => _wakeTimeError = "");
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: _wakeTimeError.isNotEmpty ? Colors.redAccent : greyColor2),
                              color: const Color(0xFFF8F9FA),
                            ),
'''
  );

  content = content.replaceFirst(
    '''
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
''',
    '''
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (_wakeTimeError.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(left: 16.w, top: 6.h),
                            child: _wakeTimeError.appText(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                              textAlign: TextAlign.start,
                            ),
                          ),
'''
  );

  // 6. Bedtime Container
  content = content.replaceFirst(
    '''
                        GestureDetector(
                          onTap: () => _pickTime(
                              context, context.read<OnboardingCubit>(), false),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: greyColor2),
                              color: const Color(0xFFF8F9FA),
                            ),
''',
    '''
                        GestureDetector(
                          onTap: () {
                            _pickTime(context, context.read<OnboardingCubit>(), false);
                            if (_bedTimeError.isNotEmpty) setState(() => _bedTimeError = "");
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: _bedTimeError.isNotEmpty ? Colors.redAccent : greyColor2),
                              color: const Color(0xFFF8F9FA),
                            ),
'''
  );

  content = content.replaceFirst(
    '''
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
''',
    '''
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (_bedTimeError.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(left: 16.w, top: 6.h),
                            child: _bedTimeError.appText(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                              textAlign: TextAlign.start,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
'''
  );

  file.writeAsStringSync(content);
}
