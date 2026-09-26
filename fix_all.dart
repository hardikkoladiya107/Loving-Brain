import 'dart:io';

void main() {
  final file = File('lib/ui/onboarding/onboarding_screen.dart');
  var content = file.readAsStringSync();
  
  content = content.replaceFirst(
    '''          // Input Field: YOUR NAME
          AppTextField(
            controller: _nameController,
            title: "Your name",
            hint: "Russell Sprout",
            border: Border.all(color: _accentPurple, width: 1.2),
            borderRadius: BorderRadius.circular(24.r),
            onChanged: (String value) {
              context.read<OnboardingCubit>().updateParentName(value);
            },
          ).appPadding(left: 20.r, right: 20.r),''',
    '''          // Input Field: YOUR NAME
          AppTextField(
            controller: _nameController,
            title: "Your name",
            hint: "Russell Sprout",
            showError: state.parentNameError.isNotEmpty,
            error: state.parentNameError,
            border: Border.all(color: state.parentNameError.isNotEmpty ? Colors.redAccent : _accentPurple, width: 1.2),
            borderRadius: BorderRadius.circular(24.r),
            onChanged: (String value) {
              context.read<OnboardingCubit>().updateParentName(value);
            },
          ).appPadding(left: 20.r, right: 20.r),'''
  );

  content = content.replaceFirst(
    '''          // Field 1: CHILD'S NAME
          AppTextField(
            controller: _childNameController,
            title: "Child's name",
            hint: "Ingredia Nutrisha",
            border: Border.all(color: _accentPurple, width: 1.2),
            borderRadius: BorderRadius.circular(24.r),
            onChanged: (String value) {
              context.read<OnboardingCubit>().updateChildName(value);
            },
          ).appPadding(left: 20.r, right: 20.r),''',
    '''          // Field 1: CHILD'S NAME
          AppTextField(
            controller: _childNameController,
            title: "Child's name",
            hint: "Ingredia Nutrisha",
            showError: state.childNameError.isNotEmpty,
            error: state.childNameError,
            border: Border.all(color: state.childNameError.isNotEmpty ? Colors.redAccent : _accentPurple, width: 1.2),
            borderRadius: BorderRadius.circular(24.r),
            onChanged: (String value) {
              context.read<OnboardingCubit>().updateChildName(value);
            },
          ).appPadding(left: 20.r, right: 20.r),'''
  );
  
  // Location Container Fix
  final oldLocation = '''                    const Icon(Icons.arrow_forward_ios, size: 16, color: greyColor),
                  ],
                ),
              ),
            ),''';
  final newLocation = '''                    const Icon(Icons.arrow_forward_ios, size: 16, color: greyColor),
                  ],
                ),
              ),
            ),
            if (state.locationError.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 36.r, top: 6.h, right: 20.r),
                child: state.locationError.appText(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                  textAlign: TextAlign.start,
                ),
              ),''';
  content = content.replaceFirst(oldLocation, newLocation);

  // DOB Container Fix
  final oldDob = '''                    // TODO: Add calendar icon here
                    const Icon(Icons.calendar_today_outlined,
                        size: 20, color: greyColor),
                  ],
                ),
              ),
            ),''';
  final newDob = '''                    // TODO: Add calendar icon here
                    const Icon(Icons.calendar_today_outlined,
                        size: 20, color: greyColor),
                  ],
                ),
              ),
            ),
            if (state.dateOfBirthError.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 36.r, top: 6.h, right: 20.r),
                child: state.dateOfBirthError.appText(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                  textAlign: TextAlign.start,
                ),
              ),''';
  content = content.replaceFirst(oldDob, newDob);

  // Wake Time Container Fix
  final oldWake = '''                        (state.usualWakeTime.isEmpty ? 'Select Time' : state.usualWakeTime).appText(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: state.usualWakeTime.isEmpty ? greyColor : greyColor9,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  10.spaceW,
                  BaseButton(
                    onTap: () =>
                        _pickTime(context, context.read<OnboardingCubit>(), true),
                    child: "Change".appText(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _accentPurple,
                    ),
                  ),
                ],
              ),
            ).appPadding(left: 20.r, right: 20.r),''';
  
  final newWake = oldWake + '''
            if (state.usualWakeTimeError.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 36.r, top: 6.h, right: 20.r),
                child: state.usualWakeTimeError.appText(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                  textAlign: TextAlign.start,
                ),
              ),''';
  content = content.replaceFirst(oldWake, newWake);

  // Bed Time Container Fix
  final oldBed = '''                        (state.usualBedtime.isEmpty ? 'Select Time' : state.usualBedtime).appText(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: state.usualBedtime.isEmpty ? greyColor : greyColor9,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  10.spaceW,
                  BaseButton(
                    onTap: () => _pickTime(
                        context, context.read<OnboardingCubit>(), false),
                    child: "Change".appText(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _accentPurple,
                    ),
                  ),
                ],
              ),
            ).appPadding(left: 20.r, right: 20.r),''';

  final newBed = oldBed + '''
            if (state.usualBedtimeError.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 36.r, top: 6.h, right: 20.r),
                child: state.usualBedtimeError.appText(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                  textAlign: TextAlign.start,
                ),
              ),''';
  content = content.replaceFirst(oldBed, newBed);

  file.writeAsStringSync(content);
}
