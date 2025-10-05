import 'package:freezed_annotation/freezed_annotation.dart';

part 'link_co_parent_state.freezed.dart';

@freezed
abstract class LinkCoParentState with _$LinkCoParentState {
  const factory LinkCoParentState({
    @Default("EMAIL") String selectedTab,
    @Default("") String? coParentEmail,
    @Default(false) bool calenderAndEvent,
    @Default(false) bool childEssentials,
    @Default("") String selectedChild
  }) = _LinkCoParentState;
}
