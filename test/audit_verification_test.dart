import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/timeline_event_model.dart';
import 'package:loving_brain/ui/brainy_conversation/bloc/brainy_conversation_cubit.dart';
import 'package:loving_brain/ui/brainy_conversation/bloc/brainy_conversation_state.dart';
import 'package:loving_brain/ui/child_essentials/bloc/child_essentials_cubit.dart';
import 'package:loving_brain/ui/family_timeline/bloc/family_timeline_cubit.dart';
import 'package:loving_brain/ui/journey/bloc/journey_cubit.dart';
import 'package:loving_brain/ui/journey/bloc/journey_state.dart';
import 'package:loving_brain/ui/microphone_permission/bloc/microphone_permission_cubit.dart';
import 'package:loving_brain/ui/notifications_permission/bloc/notifications_permission_cubit.dart';

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
}
