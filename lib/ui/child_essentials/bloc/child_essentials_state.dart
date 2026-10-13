import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loving_brain/model/api_result_status.dart';

part 'child_essentials_state.freezed.dart';

@freezed
abstract class ChildEssentialsState with _$ChildEssentialsState {
  const factory ChildEssentialsState({
    @Default(false) bool isLoading,
    @Default('your child') String childName,
    @Default(<String>['Peanuts (mild)', 'Dairy sensitivity'])
    List<String> allergies,
    @Default(<String>['Vitamin D drops (daily, 400 IU)'])
    List<String> medications,
    @Default(<String>[
      'Mom: (555) 234-5678',
      'Dad: (555) 876-5432',
      'Poison Control: (800) 222-1222',
    ])
    List<String> emergencyContacts,
    @Default('Dr. Sarah Lin, Willow Pediatrics') String pediatrician,
    @Default(ApiResultStatus.initial()) ApiResultStatus fetchStatus,
  }) = _ChildEssentialsState;
}
