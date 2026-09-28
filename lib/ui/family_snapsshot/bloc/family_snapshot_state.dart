class FamilySnapshotState {
  final String childName;
  final String whatWeNoticed;
  final String tryThisFirst;

  const FamilySnapshotState({
    this.childName = 'your child',
    this.whatWeNoticed = 'Evenings look like the hardest stretch',
    this.tryThisFirst = 'Start wind-down 15 minutes earlier',
  });

  FamilySnapshotState copyWith({
    String? childName,
    String? whatWeNoticed,
    String? tryThisFirst,
  }) {
    return FamilySnapshotState(
      childName: childName ?? this.childName,
      whatWeNoticed: whatWeNoticed ?? this.whatWeNoticed,
      tryThisFirst: tryThisFirst ?? this.tryThisFirst,
    );
  }
}
