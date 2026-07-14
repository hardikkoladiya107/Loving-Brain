import 'package:flutter_test/flutter_test.dart';
import 'package:loving_brain/model/child_state_model.dart';

void main() {
  group('ChildState', () {
    test('insightTextFor interpolates child name for fussy', () {
      expect(
        ChildState.fussy.insightTextFor('Ava'),
        'Ava needs some support right now',
      );
    });

    test('fromKey round-trips keys', () {
      expect(ChildStateExtension.fromKey('high_energy'), ChildState.highEnergy);
      expect(ChildStateExtension.fromKey('calm'), ChildState.calm);
      expect(ChildStateExtension.fromKey(null), isNull);
    });
  });
}
