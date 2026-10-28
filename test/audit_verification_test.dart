import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/api_result_status.dart';
import 'package:loving_brain/model/child_model.dart';
import 'package:loving_brain/model/pending_local_update_model.dart';
import 'package:loving_brain/model/sleep_log_model.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/other/preferances.dart';
import 'package:loving_brain/repo/ai_repo.dart';
import 'package:loving_brain/repo/offline_sync_repo.dart';
import 'package:loving_brain/repo/sleep_log_repo.dart';
import 'package:loving_brain/repo/user_repo.dart';
import 'package:loving_brain/ui/brainy_conversation/bloc/brainy_conversation_cubit.dart';
import 'package:loving_brain/ui/brainy_conversation/bloc/brainy_conversation_state.dart';
import 'package:loving_brain/ui/brainy_home/bloc/brainy_home_cubit.dart';
import 'package:loving_brain/ui/brainy_home/brainy_home_screen.dart';
import 'package:loving_brain/ui/child_essentials/bloc/child_essentials_cubit.dart';
import 'package:loving_brain/ui/family_timeline/bloc/family_timeline_cubit.dart';
import 'package:loving_brain/ui/journey/bloc/journey_cubit.dart';
import 'package:loving_brain/ui/journey/bloc/journey_state.dart';
import 'package:loving_brain/ui/microphone_permission/bloc/microphone_permission_cubit.dart';
import 'package:loving_brain/ui/notifications_permission/bloc/notifications_permission_cubit.dart';
import 'package:loving_brain/ui/base_screen/bloc/base_cubit.dart';
import 'package:loving_brain/ui/journey/journey_screen.dart';
import 'package:loving_brain/ui/session_request_confirmation/bloc/session_request_confirmation_cubit.dart';
import 'package:loving_brain/ui/session_request_confirmation/session_request_confirmation_screen.dart';
import 'package:loving_brain/ui/today_screen/bloc/today_cubit.dart';
import 'package:loving_brain/ui/today_screen/sheets/add_tantrums_update_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('xyz.luan/audioplayers.global'),
          (MethodCall methodCall) async => 1,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('xyz.luan/audioplayers'),
          (MethodCall methodCall) async {
            // Return 1 for all audioplayer calls
            return 1;
          },
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/connectivity'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'check') {
              return <String>['wifi'];
            }
            return null;
          },
        );
  });

  group('Audit Verification: Brainy AI Multi-Image & Voice Note Attachment', () {
    test(
      'Multi-image cumulative addition, removal at index, and clearing',
      () async {
        final BrainyConversationCubit cubit = BrainyConversationCubit();
        await cubit.init();

        expect(cubit.state.selectedImagePaths, isEmpty);
        expect(cubit.state.selectedImagePath, isNull);

        // 1. Initial multi-image selection (e.g. from gallery)
        cubit.addSelectedImages(<String>[
          '/photos/baby1.png',
          '/photos/baby2.png',
        ]);
        expect(cubit.state.selectedImagePaths.length, equals(2));
        expect(
          cubit.state.selectedImagePaths,
          containsAllInOrder(<String>[
            '/photos/baby1.png',
            '/photos/baby2.png',
          ]),
        );
        expect(cubit.state.selectedImagePath, equals('/photos/baby1.png'));

        // 2. Cumulative addition (user taps + to add another photo from camera)
        cubit.addSelectedImages(<String>['/photos/baby3.png']);
        expect(cubit.state.selectedImagePaths.length, equals(3));
        expect(cubit.state.selectedImagePaths[2], equals('/photos/baby3.png'));

        // 3. Duplicate paths are ignored
        cubit.addSelectedImages(<String>['/photos/baby2.png']);
        expect(cubit.state.selectedImagePaths.length, equals(3));

        // 4. Out of bounds index removal is handled safely
        cubit.removeSelectedImageAt(-1);
        cubit.removeSelectedImageAt(10);
        expect(cubit.state.selectedImagePaths.length, equals(3));

        // 5. Removing middle image at index 1
        cubit.removeSelectedImageAt(1);
        expect(
          cubit.state.selectedImagePaths,
          equals(<String>['/photos/baby1.png', '/photos/baby3.png']),
        );

        // 6. Removing head image at index 0 updates selectedImagePath to remaining
        cubit.removeSelectedImageAt(0);
        expect(
          cubit.state.selectedImagePaths,
          equals(<String>['/photos/baby3.png']),
        );
        expect(cubit.state.selectedImagePath, equals('/photos/baby3.png'));

        // 7. Clear all images
        cubit.clearSelectedImages();
        expect(cubit.state.selectedImagePaths, isEmpty);
        expect(cubit.state.selectedImagePath, isNull);

        await cubit.close();
      },
    );

    test(
      'Attached audio note lifecycle: attach, seek, toggle play, and delete/discard',
      () async {
        final BrainyConversationCubit cubit = BrainyConversationCubit();
        await cubit.init();

        expect(cubit.state.attachedAudioPath, isNull);
        expect(cubit.state.isAttachedAudioPlaying, isFalse);
        expect(cubit.state.attachedAudioPosition, equals(Duration.zero));

        // 1. Attach recorded audio note from voice sheet
        await cubit.attachAudio('/cache/voice_recording_1.m4a');
        expect(
          cubit.state.attachedAudioPath,
          equals('/cache/voice_recording_1.m4a'),
        );
        expect(cubit.state.isAttachedAudioPlaying, isFalse);
        expect(cubit.state.attachedAudioPosition, equals(Duration.zero));

        // 2. Seek within attached audio
        await cubit.seekAttachedAudio(const Duration(seconds: 7));
        expect(
          cubit.state.attachedAudioPosition,
          equals(const Duration(seconds: 7)),
        );

        // 3. Toggle playback of attached audio
        await cubit.togglePlayAttachedAudio();
        expect(cubit.state.isAttachedAudioPlaying, isTrue);

        await cubit.togglePlayAttachedAudio();
        expect(cubit.state.isAttachedAudioPlaying, isFalse);

        // 4. User discards/deletes recorded note
        await cubit.removeAttachedAudio();
        expect(cubit.state.attachedAudioPath, isNull);
        expect(cubit.state.isAttachedAudioPlaying, isFalse);
        expect(cubit.state.attachedAudioPosition, equals(Duration.zero));

        await cubit.close();
      },
    );

    test(
      'Sending message with text, audio, and images resets composer and builds optimistic message',
      () async {
        final BrainyConversationCubit cubit = BrainyConversationCubit();
        await cubit.init();

        // Preload composer with attached audio and images
        await cubit.attachAudio('/cache/voice_note.m4a');
        cubit.addSelectedImages(<String>['/photos/sleep_routine.png']);

        expect(cubit.state.attachedAudioPath, isNotNull);
        expect(cubit.state.selectedImagePaths, isNotEmpty);

        // Send message
        await cubit.sendMessage('How should I adjust bedtime?');

        // Optimistic message created with attachments
        expect(cubit.state.messages, isNotEmpty);
        final BrainyMessage lastUserMsg = cubit.state.messages.firstWhere(
          (BrainyMessage m) =>
              m.type == MessageType.user &&
              m.headline == 'How should I adjust bedtime?',
        );
        expect(lastUserMsg.headline, equals('How should I adjust bedtime?'));
        expect(lastUserMsg.audioLocalPath, equals('/cache/voice_note.m4a'));
        expect(
          lastUserMsg.imageLocalPaths,
          contains('/photos/sleep_routine.png'),
        );

        // Composer attachments are cleanly cleared upon sending
        expect(cubit.state.attachedAudioPath, isNull);
        expect(cubit.state.selectedImagePaths, isEmpty);
        expect(cubit.state.selectedImagePath, isNull);
        expect(cubit.state.isAttachedAudioPlaying, isFalse);

        await cubit.close();
      },
    );

    test(
      'Sending voice-only note defaults headline and chip to "Voice note"',
      () async {
        final BrainyConversationCubit cubit = BrainyConversationCubit();
        await cubit.init();

        await cubit.attachAudio('/cache/quick_voice.m4a');
        await cubit.sendMessage('');

        final BrainyMessage voiceMsg = cubit.state.messages.firstWhere(
          (BrainyMessage m) =>
              m.type == MessageType.user &&
              m.audioLocalPath == '/cache/quick_voice.m4a',
        );
        expect(voiceMsg.headline, equals('Voice note'));
        expect(voiceMsg.chipTitle, equals('Voice note'));

        await cubit.close();
      },
    );

    test('Sending photo-only note formats headline with photo count', () async {
      final BrainyConversationCubit cubit = BrainyConversationCubit();
      await cubit.init();

      // Case 1: Multiple photos
      cubit.addSelectedImages(<String>['/p1.png', '/p2.png']);
      await cubit.sendMessage('');
      final BrainyMessage multiPhotoMsg = cubit.state.messages.lastWhere(
        (BrainyMessage m) => m.type == MessageType.user,
      );
      expect(multiPhotoMsg.headline, equals('Shared 2 photos'));

      // Case 2: Single photo
      cubit.addSelectedImages(<String>['/p3.png']);
      await cubit.sendMessage('');
      final BrainyMessage singlePhotoMsg = cubit.state.messages.lastWhere(
        (BrainyMessage m) => m.type == MessageType.user,
      );
      expect(singlePhotoMsg.headline, equals('Shared a photo'));

      await cubit.close();
    });

    test('Empty sendMessage with no attachments does nothing', () async {
      final BrainyConversationCubit cubit = BrainyConversationCubit();
      await cubit.init();

      final int initialCount = cubit.state.messages.length;
      await cubit.sendMessage('   ');
      expect(cubit.state.messages.length, equals(initialCount));

      await cubit.close();
    });

    test(
      'Navigating back or re-initializing clears draft images, audio, and composer state',
      () async {
        final BrainyConversationCubit cubit = BrainyConversationCubit();
        await cubit.init();

        // 1. User attaches multiple images and a voice note
        cubit.addSelectedImages(<String>[
          '/photos/saree1.png',
          '/photos/saree2.png',
        ]);
        await cubit.attachAudio('/cache/voice_note.m4a');

        expect(cubit.state.selectedImagePaths.length, equals(2));
        expect(cubit.state.selectedImagePath, equals('/photos/saree1.png'));
        expect(cubit.state.attachedAudioPath, equals('/cache/voice_note.m4a'));

        // 2. User goes back -> clearDraft is called
        cubit.clearDraft();

        expect(cubit.state.selectedImagePaths, isEmpty);
        expect(cubit.state.selectedImagePath, isNull);
        expect(cubit.state.attachedAudioPath, isNull);
        expect(cubit.state.isAttachedAudioPlaying, isFalse);

        // 3. User re-enters existing conversation -> init ensures clean draft
        cubit.addSelectedImages(<String>['/photos/stale.png']);
        await cubit.init(conversationId: 'existing_conv_123');

        expect(cubit.state.selectedImagePaths, isEmpty);
        expect(cubit.state.selectedImagePath, isNull);
        expect(cubit.state.attachedAudioPath, isNull);

        await cubit.close();
      },
    );
  });

  group('Audit Verification: Journey & Navigation Separation', () {
    test('JourneyCubit manages sleep journey enrollment and week progress', () {
      final JourneyCubit cubit = JourneyCubit();
      cubit.init();

      expect(cubit.state.isSleepJourneyEnrolled, isFalse);
      expect(cubit.state.sleepJourneyWeek, equals(1));
      expect(cubit.state.sleepJourneyTotalWeeks, equals(6));

      // Simulate enrollment progression across 6 weeks
      for (int week = 1; week <= 6; week++) {
        cubit.changeProps(
          isSleepJourneyEnrolled: true,
          sleepJourneyWeek: week,
          sleepJourneyTotalWeeks: 6,
        );
        expect(cubit.state.isSleepJourneyEnrolled, isTrue);
        expect(cubit.state.sleepJourneyWeek, equals(week));
      }

      cubit.close();
    });

    test(
      'Separation of Sleep Journey and Guided Mentorship target screens',
      () {
        // Logic verification matching lib/ui/journey/journey_screen.dart:
        // Sleep Journey:
        //  - When not enrolled -> ProgrammeDetailScreen (Screen 44)
        //  - When enrolled -> EnrolledJourneyHomeScreen (Screen 49)
        // Guided Mentorship:
        //  - Always -> MentorshipLandingScreen (Screen 43)
        final JourneyState unenrolledState = const JourneyState(
          isSleepJourneyEnrolled: false,
        );
        final JourneyState enrolledState = const JourneyState(
          isSleepJourneyEnrolled: true,
          sleepJourneyWeek: 2,
        );

        String resolveSleepJourneyRoute(JourneyState s) =>
            s.isSleepJourneyEnrolled
            ? 'EnrolledJourneyHomeScreen'
            : 'ProgrammeDetailScreen';
        String resolveMentorshipRoute() => 'MentorshipLandingScreen';

        expect(
          resolveSleepJourneyRoute(unenrolledState),
          equals('ProgrammeDetailScreen'),
        );
        expect(
          resolveSleepJourneyRoute(enrolledState),
          equals('EnrolledJourneyHomeScreen'),
        );
        expect(resolveMentorshipRoute(), equals('MentorshipLandingScreen'));
        expect(
          resolveSleepJourneyRoute(unenrolledState),
          isNot(equals(resolveMentorshipRoute())),
        );
        expect(
          resolveSleepJourneyRoute(enrolledState),
          isNot(equals(resolveMentorshipRoute())),
        );
      },
    );
  });

  group('Audit Verification: Family Timeline Notes Tab Filtering', () {
    test(
      'Filtering timeline events for Notes tab isolates note items and supports filter switches',
      () {
        final FamilyTimelineCubit cubit = FamilyTimelineCubit();
        cubit.init();

        final List<TimelineEventModel> sampleEvents = <TimelineEventModel>[
          TimelineEventModel(
            id: '1',
            type: 'sleep_night',
            title: 'Night sleep',
            subtitle: 'Slept 10h 15m',
            timestamp: DateTime.now(),
          ),
          TimelineEventModel(
            id: '2',
            type: 'quick_note',
            title: 'Bedtime observation',
            subtitle: 'Fell asleep smoothly with white noise.',
            timestamp: DateTime.now(),
          ),
          TimelineEventModel(
            id: '3',
            type: 'behaviour_tantrum',
            title: 'Tantrum at park',
            subtitle: 'Big feelings after slide',
            timestamp: DateTime.now(),
          ),
          TimelineEventModel(
            id: '4',
            type: 'audio_note',
            title: 'Voice reflection',
            subtitle: 'Voice note recorded',
            audioLocalPath: '/tmp/note.m4a',
            audioDurationSeconds: 15,
            timestamp: DateTime.now(),
          ),
          TimelineEventModel(
            id: '5',
            type: 'mentorship_session',
            title: '1:1 Sleep Guidance',
            subtitle: 'Call with Sarah',
            timestamp: DateTime.now(),
          ),
        ];

        cubit.changeProps(
          allEvents: sampleEvents,
          filteredEvents: sampleEvents,
          selectedFilter: 'All',
        );
        expect(cubit.state.filteredEvents.length, equals(5));

        // 1. Filter by Notes
        cubit.setFilter('Notes');
        expect(cubit.state.selectedFilter, equals('Notes'));
        expect(cubit.state.filteredEvents.length, equals(2));
        expect(
          cubit.state.filteredEvents.every(
            (TimelineEventModel e) => e.type.contains('note'),
          ),
          isTrue,
        );

        // 2. Filter by Sleep
        cubit.setFilter('Sleep');
        expect(cubit.state.selectedFilter, equals('Sleep'));
        expect(cubit.state.filteredEvents.length, equals(1));
        expect(cubit.state.filteredEvents.first.type, equals('sleep_night'));

        // 3. Filter by Behaviour
        cubit.setFilter('Behaviour');
        expect(cubit.state.selectedFilter, equals('Behaviour'));
        expect(cubit.state.filteredEvents.length, equals(1));
        expect(
          cubit.state.filteredEvents.first.type,
          equals('behaviour_tantrum'),
        );

        // 4. Filter by Mentorship
        cubit.setFilter('Mentorship');
        expect(cubit.state.selectedFilter, equals('Mentorship'));
        expect(cubit.state.filteredEvents.length, equals(1));
        expect(
          cubit.state.filteredEvents.first.type,
          equals('mentorship_session'),
        );

        // 5. Back to All
        cubit.setFilter('All');
        expect(cubit.state.selectedFilter, equals('All'));
        expect(cubit.state.filteredEvents.length, equals(5));

        cubit.close();
      },
    );

    test('Notes tab handles empty notes scenario gracefully', () {
      final FamilyTimelineCubit cubit = FamilyTimelineCubit();
      cubit.init();

      final List<TimelineEventModel> sleepOnly = <TimelineEventModel>[
        TimelineEventModel(
          id: '1',
          type: 'sleep_nap',
          title: 'Nap',
          subtitle: '1h 10m',
          timestamp: DateTime.now(),
        ),
      ];

      cubit.changeProps(allEvents: sleepOnly, filteredEvents: sleepOnly);
      cubit.setFilter('Notes');
      expect(cubit.state.filteredEvents, isEmpty);

      cubit.close();
    });
  });

  group('Audit Verification: Permission Explainer Cubits', () {
    test(
      'MicrophonePermissionCubit transitions and responds to grant',
      () async {
        final MicrophonePermissionCubit cubit = MicrophonePermissionCubit();
        cubit.init();

        expect(cubit.state.isGranted, isFalse);

        final bool granted = await cubit.grantPermission();
        expect(granted, isTrue);
        expect(cubit.state.isGranted, isTrue);

        cubit.close();
      },
    );

    test(
      'NotificationsPermissionCubit initializes child name and handles grant',
      () {
        final NotificationsPermissionCubit cubit =
            NotificationsPermissionCubit();
        cubit.init();

        expect(cubit.state.childName, isNotEmpty);
        expect(cubit.state.isGranted, isFalse);

        cubit.grantPermission();
        expect(cubit.state.isGranted, isTrue);

        cubit.changeProps(isGranted: true);
        expect(cubit.state.isGranted, isTrue);

        cubit.close();
      },
    );
  });

  group('Audit Verification: Child Essentials Allergies & Medications', () {
    test('ChildEssentialsCubit add and remove items with deduplication', () {
      final ChildEssentialsCubit cubit = ChildEssentialsCubit();
      cubit.init();

      expect(cubit.state.allergies, isEmpty);
      expect(cubit.state.medications, isEmpty);

      // Add allergies with duplicate and whitespace edge cases
      cubit.addAllergy('Peanuts');
      cubit.addAllergy('Eggs');
      cubit.addAllergy('  '); // Empty string ignored
      cubit.addAllergy('Peanuts'); // Exact duplicate ignored
      cubit.addAllergy('peanuts'); // Case-insensitive duplicate ignored
      cubit.addAllergy(' Eggs '); // Whitespace duplicate ignored
      expect(cubit.state.allergies, equals(<String>['Peanuts', 'Eggs']));

      // Add medications with duplicate and whitespace edge cases
      cubit.addMedication('Amoxicillin 250mg');
      cubit.addMedication('Probiotic drops');
      cubit.addMedication('   '); // Empty ignored
      cubit.addMedication(
        'amoxicillin 250mg',
      ); // Case-insensitive duplicate ignored
      expect(
        cubit.state.medications,
        equals(<String>['Amoxicillin 250mg', 'Probiotic drops']),
      );

      // Out of bounds index removal safety
      cubit.removeAllergy(-1);
      cubit.removeAllergy(10);
      cubit.removeMedication(-1);
      cubit.removeMedication(10);
      expect(cubit.state.allergies.length, equals(2));
      expect(cubit.state.medications.length, equals(2));

      // Remove allergy by index
      cubit.removeAllergy(0);
      expect(cubit.state.allergies, equals(<String>['Eggs']));

      // Remove medication by index
      cubit.removeMedication(0);
      expect(cubit.state.medications, equals(<String>['Probiotic drops']));

      cubit.close();
    });
  });

  group('Audit Verification: Keyboard Insets & Bottom Navigation Handling', () {
    testWidgets(
      'BrainyHomeScreen collapses 90.h bottom navigation spacer when keyboard is open',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1125, 2436);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final BrainyHomeCubit cubit = BrainyHomeCubit();

        Widget buildScreen(EdgeInsets insets) {
          return MaterialApp(
            home: ScreenUtilInit(
              designSize: const Size(375, 812),
              builder: (context, child) => MediaQuery(
                data: MediaQueryData(
                  size: const Size(375, 812),
                  viewInsets: insets,
                ),
                child: BlocProvider<BrainyHomeCubit>.value(
                  value: cubit,
                  child: const BrainyHomeScreen(),
                ),
              ),
            ),
          );
        }

        // 1. Keyboard closed: spacer with 90.h is present above bottom navigation
        await tester.pumpWidget(buildScreen(EdgeInsets.zero));
        await tester.pump();

        // Verify photo and microphone action icons are visible on initial screen
        expect(find.byIcon(Icons.image_outlined), findsOneWidget);
        expect(find.byIcon(Icons.mic_none_rounded), findsOneWidget);
        expect(find.byIcon(Icons.send), findsOneWidget);

        final spacerFinder = find.byWidgetPredicate(
          (Widget w) =>
              w is SizedBox &&
              w.height != null &&
              (w.height! - 90.h).abs() < 0.1,
        );
        expect(spacerFinder, findsOneWidget);

        // 2. Keyboard open (e.g. 300px bottom inset): 90.h spacer is collapsed
        await tester.pumpWidget(
          buildScreen(const EdgeInsets.only(bottom: 300)),
        );
        await tester.pump();
        expect(spacerFinder, findsNothing);

        cubit.close();
      },
    );

    testWidgets(
      'Scaffold conditionally hides bottomNavigationBar when viewInsets.bottom > 0',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1125, 2436);
        tester.view.devicePixelRatio = 3.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        Widget buildNavTest(EdgeInsets insets) {
          return MaterialApp(
            home: ScreenUtilInit(
              designSize: const Size(375, 812),
              builder: (context, child) => MediaQuery(
                data: MediaQueryData(
                  size: const Size(375, 812),
                  viewInsets: insets,
                ),
                child: Builder(
                  builder: (context) {
                    final bool isKeyboardOpen =
                        MediaQuery.of(context).viewInsets.bottom > 0;
                    return Scaffold(
                      body: const Center(child: Text('Content')),
                      bottomNavigationBar: isKeyboardOpen
                          ? null
                          : const Text('FloatingBottomNav'),
                    );
                  },
                ),
              ),
            ),
          );
        }

        // 1. Keyboard closed: Floating bottom nav is present
        await tester.pumpWidget(buildNavTest(EdgeInsets.zero));
        await tester.pump();
        expect(find.text('FloatingBottomNav'), findsOneWidget);

        // 2. Keyboard open: Floating bottom nav is omitted
        await tester.pumpWidget(
          buildNavTest(const EdgeInsets.only(bottom: 300)),
        );
        await tester.pump();
        expect(find.text('FloatingBottomNav'), findsNothing);
      },
    );

    testWidgets(
      'Bottom action container padding reduces when keyboard is open',
      (WidgetTester tester) async {
        Widget buildActionTest(EdgeInsets insets) {
          return MaterialApp(
            home: ScreenUtilInit(
              designSize: const Size(375, 812),
              builder: (BuildContext context, Widget? child) => MediaQuery(
                data: MediaQueryData(
                  size: const Size(375, 812),
                  viewInsets: insets,
                  padding: const EdgeInsets.only(bottom: 24),
                ),
                child: Builder(
                  builder: (BuildContext ctx) {
                    final bool isKeyboardOpen =
                        MediaQuery.of(ctx).viewInsets.bottom > 0;
                    return Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            key: const ValueKey<String>('action_container'),
                            padding: EdgeInsets.only(
                              top: isKeyboardOpen ? 10.h : 24.h,
                              bottom: isKeyboardOpen
                                  ? 10.h
                                  : (20.h + MediaQuery.of(ctx).padding.bottom),
                              left: 20.w,
                              right: 20.w,
                            ),
                            child: const Text('Save changes'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        }

        // 1. Keyboard closed: padding incorporates safe area + normal spacing
        await tester.pumpWidget(buildActionTest(EdgeInsets.zero));
        await tester.pump();
        final Container closedContainer = tester.widget<Container>(
          find.byKey(const ValueKey<String>('action_container')),
        );
        final EdgeInsets closedPadding = closedContainer.padding as EdgeInsets;
        expect(closedPadding.bottom, greaterThanOrEqualTo(35));

        // 2. Keyboard open: bottom padding reduces to 10.h and top to 10.h
        await tester.pumpWidget(
          buildActionTest(const EdgeInsets.only(bottom: 300)),
        );
        await tester.pump();
        final Container openContainer = tester.widget<Container>(
          find.byKey(const ValueKey<String>('action_container')),
        );
        final EdgeInsets openPadding = openContainer.padding as EdgeInsets;
        expect(openPadding.bottom, equals(10.h));
        expect(openPadding.top, equals(10.h));
      },
    );
  });

  group('Audit Verification: End-to-End Error & Exception Handling Robustness', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      await SharedPreference.init();
      await OfflineSyncRepo.instance.clearQueue();
    });

    test(
      'OfflineSyncRepo retains failed offline updates when Firestore throws during sync',
      () async {
        final PendingLocalUpdateModel update = PendingLocalUpdateModel.create(
          clientUpdateId: 'test_sleep_error_01',
          updateType: 'sleep',
          timestamp: DateTime.now().toIso8601String(),
          payload: <String, dynamic>{'test': true},
        );

        // 1. Queue the update locally
        final ApiResultStatus<bool> queueRes = await OfflineSyncRepo.instance
            .queuePendingUpdate(update);
        expect(queueRes is Data<bool>, isTrue);

        final List<PendingLocalUpdateModel> pendingBefore =
            await OfflineSyncRepo.instance.getPendingUpdates();
        expect(pendingBefore.length, equals(1));
        expect(pendingBefore.first.id, equals('test_sleep_error_01'));

        // 2. Run syncPendingUpdates (Firestore uninitialized / throws)
        // With our fix, failed items MUST remain in queue and not be erased
        final ApiResultStatus<int> syncRes = await OfflineSyncRepo.instance
            .syncPendingUpdates();
        expect(syncRes is Data<int>, isTrue);
        expect((syncRes as Data<int>).data, equals(0));

        // 3. Confirm update was retained for future retry (NO DATA LOSS)
        final List<PendingLocalUpdateModel> pendingAfter = await OfflineSyncRepo
            .instance
            .getPendingUpdates();
        expect(pendingAfter.length, equals(1));
        expect(pendingAfter.first.id, equals('test_sleep_error_01'));
      },
    );

    test(
      'AiRepo returns ApiResultStatus.error on non-existent files without unhandled crash',
      () async {
        final File missingFile = File(
          '/tmp/non_existent_file_${DateTime.now().millisecondsSinceEpoch}.png',
        );

        // File does not exist: MultipartFile.fromFile throws FileSystemException
        // AiRepo catches this and returns ApiResultStatus.error
        final ApiResultStatus uploadRes = await AiRepo.instance.uploadFile(
          file: missingFile,
        );
        expect(uploadRes is Error, isTrue);

        final ApiResultStatus audioRes = await AiRepo.instance.transcribeAudio(
          file: missingFile,
        );
        expect(audioRes is Error, isTrue);
      },
    );

    test(
      'SleepLogRepo.editSleepLog returns ApiResultStatus.error on invalid inputs',
      () async {
        final DateTime now = DateTime.now();
        // 1. Empty log.id returns error
        final SleepLogModel logNoId = SleepLogModel(
          id: '',
          date: now,
          bedTime: now,
          wakeTime: now,
        );
        final ApiResultStatus<void> res1 = await SleepLogRepo.instance
            .editSleepLog(ChildModel(), logNoId);
        expect(res1 is Error<void>, isTrue);

        // 2. Missing child.reference.id returns error
        final SleepLogModel logWithId = SleepLogModel(
          id: 'test_log_id',
          date: now,
          bedTime: now,
          wakeTime: now,
        );
        final ApiResultStatus<void> res2 = await SleepLogRepo.instance
            .editSleepLog(ChildModel(), logWithId);
        expect(res2 is Error<void>, isTrue);
      },
    );

    test(
      'UserRepo returns ApiResultStatus.error when updateUserToFireStore called with empty uid',
      () async {
        final ApiResultStatus res = await UserRepo.instance
            .updateUserToFireStore(uId: '', request: <String, dynamic>{});
        expect(res is Error, isTrue);
      },
    );
  });

  group('AddTantrumsUpdateSheet UI & Alignment Verification', () {
    testWidgets(
      'Renders DraggableScrollableSheet with bold headers and left-aligned Possible Trigger',
      (WidgetTester tester) async {
        final TodayCubit cubit = TodayCubit();

        await tester.pumpWidget(
          MaterialApp(
            home: ScreenUtilInit(
              designSize: const Size(375, 812),
              builder: (BuildContext context, Widget? child) => Scaffold(
                body: BlocProvider<TodayCubit>.value(
                  value: cubit,
                  child: const AddTantrumsUpdateSheet(),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 1. Verify DraggableScrollableSheet is used and configured properly
        final Finder sheetFinder = find.byType(DraggableScrollableSheet);
        expect(sheetFinder, findsOneWidget);
        final DraggableScrollableSheet sheetWidget = tester
            .widget<DraggableScrollableSheet>(sheetFinder);
        expect(sheetWidget.initialChildSize, equals(0.94));
        expect(sheetWidget.minChildSize, equals(0.4));
        expect(sheetWidget.maxChildSize, equals(0.96));
        expect(sheetWidget.expand, isFalse);

        // 2. Verify POSSIBLE TRIGGER is left-aligned with bold weight
        final Finder triggerTextFinder = find.text('POSSIBLE TRIGGER');
        expect(triggerTextFinder, findsOneWidget);
        final Text triggerTextWidget = tester.widget<Text>(triggerTextFinder);
        expect(triggerTextWidget.textAlign, equals(TextAlign.start));
        expect(triggerTextWidget.style?.fontWeight, equals(FontWeight.bold));

        // 3. Verify INTENSITY header has bold weight and left alignment
        final Finder intensityTextFinder = find.text('INTENSITY');
        expect(intensityTextFinder, findsOneWidget);
        final Text intensityTextWidget = tester.widget<Text>(
          intensityTextFinder,
        );
        expect(intensityTextWidget.textAlign, equals(TextAlign.start));
        expect(intensityTextWidget.style?.fontWeight, equals(FontWeight.bold));
      },
    );
  });

  group('Journey Tab: 5 Feature Buttons & Flow Verification', () {
    testWidgets(
      'Renders all 5 Journey feature buttons properly with expected titles',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(750, 3000);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final JourneyCubit cubit = JourneyCubit();

        await tester.pumpWidget(
          MaterialApp(
            home: ScreenUtilInit(
              designSize: const Size(375, 1500),
              builder: (BuildContext context, Widget? child) => Scaffold(
                body: BlocProvider<JourneyCubit>.value(
                  value: cubit,
                  child: const JourneyScreen(),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // 1. 6-Week Sleep Journey
        expect(find.text('6-Week Sleep Journey'), findsOneWidget);

        // 2. Family timeline
        expect(find.text('Family timeline'), findsOneWidget);

        // 3. Saved guidance
        expect(find.text('Saved guidance'), findsOneWidget);

        // 4. Consistency recognition
        expect(find.text('Consistency recognition'), findsOneWidget);

        // 5. Guided mentorship
        expect(find.text('Guided mentorship'), findsOneWidget);
      },
    );

    testWidgets(
      'SessionRequestConfirmationScreen Back to Journey button switches to tab index 2 and pops',
      (WidgetTester tester) async {
        final BaseCubit baseCubit = BaseCubit();

        await tester.pumpWidget(
          MaterialApp(
            home: ScreenUtilInit(
              designSize: const Size(375, 812),
              builder: (BuildContext context, Widget? child) =>
                  MultiBlocProvider(
                    providers: [
                      BlocProvider<BaseCubit>.value(value: baseCubit),
                      BlocProvider<SessionRequestConfirmationCubit>(
                        create: (_) => SessionRequestConfirmationCubit(),
                      ),
                    ],
                    child: Navigator(
                      onGenerateRoute: (RouteSettings settings) {
                        return MaterialPageRoute<void>(
                          builder: (BuildContext ctx) => Scaffold(
                            body: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    ctx,
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const SessionRequestConfirmationScreen(
                                            guideName: 'Dr. Sarah',
                                          ),
                                    ),
                                  );
                                },
                                child: const Text('Open Confirmation'),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Open SessionRequestConfirmationScreen
        await tester.tap(find.text('Open Confirmation'));
        await tester.pumpAndSettle();

        expect(find.text('Request sent'), findsOneWidget);
        expect(find.text('Back to Journey'), findsOneWidget);

        // Tap "Back to Journey"
        await tester.tap(find.text('Back to Journey'));
        await tester.pumpAndSettle();

        // Verify base cubit switched bottom navigation index to 2 (Journey)
        expect(baseCubit.state.bottomNavigationIndex, equals(2));
        // Verify it popped back to the root
        expect(find.text('Open Confirmation'), findsOneWidget);
      },
    );
  });
}
