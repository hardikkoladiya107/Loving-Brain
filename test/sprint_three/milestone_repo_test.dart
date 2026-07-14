import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/milestone_model.dart';
import 'package:loving_brain/repo/milestone_repo.dart';

void main() {
  test('unlockedChaptersFrom collects chapter numbers', () {
    final List<MilestoneModel> milestones = <MilestoneModel>[
      MilestoneModel(
        id: '1',
        childId: 'c1',
        milestoneKey: 'first_smile',
        title: 'Smile',
        whatThisMeans: 'Means',
        storyText: 'Story',
        chapter: 1,
        ageInMonths: 7,
        loggedBy: 'u1',
        timestamp: DateTime(2026, 1, 1),
      ),
      MilestoneModel(
        id: '2',
        childId: 'c1',
        milestoneKey: 'first_word',
        title: 'Word',
        whatThisMeans: 'Means',
        storyText: 'Story',
        chapter: 2,
        ageInMonths: 12,
        loggedBy: 'u1',
        timestamp: DateTime(2026, 2, 1),
      ),
    ];
    final Set<int> unlocked = MilestoneRepo.unlockedChaptersFrom(milestones);
    expect(unlocked, {1, 2});
    expect(MilestoneRepo.isExportUnlocked(unlocked), isFalse);
  });

  test('isExportUnlocked requires all five chapters', () {
    final Set<int> allChapters = <int>{1, 2, 3, 4, 5};
    expect(MilestoneRepo.isExportUnlocked(allChapters), isTrue);
  });
}
