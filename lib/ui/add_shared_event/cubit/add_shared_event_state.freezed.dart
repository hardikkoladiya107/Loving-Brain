// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_shared_event_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddSharedEventState {

 UserModel? get userModel; String get title; String get note; DateTime? get selectedDate; DateTime? get startTime; DateTime? get endTime; String get titleError; String get noteError; String get dateError; String get startTimeError; String get endTimeError; bool get requiredApproval; String get selectedChildError; String get assignedToError; String get locationText; String get locationError; List<UserModel> get coParentList; List<ChildModel> get children; List<ChildModel> get selectedChildren; List<UserModel> get selectedCoParentList; List<String> get documentsList; ApiResultStatus get requestApprovalApiResultStatus; ApiResultStatus get getChildApiResultStatus; ApiResultStatus get getCoParentApiResultStatus; ApiResultStatus get uploadDocumentApiResultStatus;
/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddSharedEventStateCopyWith<AddSharedEventState> get copyWith => _$AddSharedEventStateCopyWithImpl<AddSharedEventState>(this as AddSharedEventState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddSharedEventState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.titleError, titleError) || other.titleError == titleError)&&(identical(other.noteError, noteError) || other.noteError == noteError)&&(identical(other.dateError, dateError) || other.dateError == dateError)&&(identical(other.startTimeError, startTimeError) || other.startTimeError == startTimeError)&&(identical(other.endTimeError, endTimeError) || other.endTimeError == endTimeError)&&(identical(other.requiredApproval, requiredApproval) || other.requiredApproval == requiredApproval)&&(identical(other.selectedChildError, selectedChildError) || other.selectedChildError == selectedChildError)&&(identical(other.assignedToError, assignedToError) || other.assignedToError == assignedToError)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.locationError, locationError) || other.locationError == locationError)&&const DeepCollectionEquality().equals(other.coParentList, coParentList)&&const DeepCollectionEquality().equals(other.children, children)&&const DeepCollectionEquality().equals(other.selectedChildren, selectedChildren)&&const DeepCollectionEquality().equals(other.selectedCoParentList, selectedCoParentList)&&const DeepCollectionEquality().equals(other.documentsList, documentsList)&&(identical(other.requestApprovalApiResultStatus, requestApprovalApiResultStatus) || other.requestApprovalApiResultStatus == requestApprovalApiResultStatus)&&(identical(other.getChildApiResultStatus, getChildApiResultStatus) || other.getChildApiResultStatus == getChildApiResultStatus)&&(identical(other.getCoParentApiResultStatus, getCoParentApiResultStatus) || other.getCoParentApiResultStatus == getCoParentApiResultStatus)&&(identical(other.uploadDocumentApiResultStatus, uploadDocumentApiResultStatus) || other.uploadDocumentApiResultStatus == uploadDocumentApiResultStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,userModel,title,note,selectedDate,startTime,endTime,titleError,noteError,dateError,startTimeError,endTimeError,requiredApproval,selectedChildError,assignedToError,locationText,locationError,const DeepCollectionEquality().hash(coParentList),const DeepCollectionEquality().hash(children),const DeepCollectionEquality().hash(selectedChildren),const DeepCollectionEquality().hash(selectedCoParentList),const DeepCollectionEquality().hash(documentsList),requestApprovalApiResultStatus,getChildApiResultStatus,getCoParentApiResultStatus,uploadDocumentApiResultStatus]);

@override
String toString() {
  return 'AddSharedEventState(userModel: $userModel, title: $title, note: $note, selectedDate: $selectedDate, startTime: $startTime, endTime: $endTime, titleError: $titleError, noteError: $noteError, dateError: $dateError, startTimeError: $startTimeError, endTimeError: $endTimeError, requiredApproval: $requiredApproval, selectedChildError: $selectedChildError, assignedToError: $assignedToError, locationText: $locationText, locationError: $locationError, coParentList: $coParentList, children: $children, selectedChildren: $selectedChildren, selectedCoParentList: $selectedCoParentList, documentsList: $documentsList, requestApprovalApiResultStatus: $requestApprovalApiResultStatus, getChildApiResultStatus: $getChildApiResultStatus, getCoParentApiResultStatus: $getCoParentApiResultStatus, uploadDocumentApiResultStatus: $uploadDocumentApiResultStatus)';
}


}

/// @nodoc
abstract mixin class $AddSharedEventStateCopyWith<$Res>  {
  factory $AddSharedEventStateCopyWith(AddSharedEventState value, $Res Function(AddSharedEventState) _then) = _$AddSharedEventStateCopyWithImpl;
@useResult
$Res call({
 UserModel? userModel, String title, String note, DateTime? selectedDate, DateTime? startTime, DateTime? endTime, String titleError, String noteError, String dateError, String startTimeError, String endTimeError, bool requiredApproval, String selectedChildError, String assignedToError, String locationText, String locationError, List<UserModel> coParentList, List<ChildModel> children, List<ChildModel> selectedChildren, List<UserModel> selectedCoParentList, List<String> documentsList, ApiResultStatus requestApprovalApiResultStatus, ApiResultStatus getChildApiResultStatus, ApiResultStatus getCoParentApiResultStatus, ApiResultStatus uploadDocumentApiResultStatus
});


$ApiResultStatusCopyWith<dynamic, $Res> get requestApprovalApiResultStatus;$ApiResultStatusCopyWith<dynamic, $Res> get getChildApiResultStatus;$ApiResultStatusCopyWith<dynamic, $Res> get getCoParentApiResultStatus;$ApiResultStatusCopyWith<dynamic, $Res> get uploadDocumentApiResultStatus;

}
/// @nodoc
class _$AddSharedEventStateCopyWithImpl<$Res>
    implements $AddSharedEventStateCopyWith<$Res> {
  _$AddSharedEventStateCopyWithImpl(this._self, this._then);

  final AddSharedEventState _self;
  final $Res Function(AddSharedEventState) _then;

/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userModel = freezed,Object? title = null,Object? note = null,Object? selectedDate = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? titleError = null,Object? noteError = null,Object? dateError = null,Object? startTimeError = null,Object? endTimeError = null,Object? requiredApproval = null,Object? selectedChildError = null,Object? assignedToError = null,Object? locationText = null,Object? locationError = null,Object? coParentList = null,Object? children = null,Object? selectedChildren = null,Object? selectedCoParentList = null,Object? documentsList = null,Object? requestApprovalApiResultStatus = null,Object? getChildApiResultStatus = null,Object? getCoParentApiResultStatus = null,Object? uploadDocumentApiResultStatus = null,}) {
  return _then(_self.copyWith(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,titleError: null == titleError ? _self.titleError : titleError // ignore: cast_nullable_to_non_nullable
as String,noteError: null == noteError ? _self.noteError : noteError // ignore: cast_nullable_to_non_nullable
as String,dateError: null == dateError ? _self.dateError : dateError // ignore: cast_nullable_to_non_nullable
as String,startTimeError: null == startTimeError ? _self.startTimeError : startTimeError // ignore: cast_nullable_to_non_nullable
as String,endTimeError: null == endTimeError ? _self.endTimeError : endTimeError // ignore: cast_nullable_to_non_nullable
as String,requiredApproval: null == requiredApproval ? _self.requiredApproval : requiredApproval // ignore: cast_nullable_to_non_nullable
as bool,selectedChildError: null == selectedChildError ? _self.selectedChildError : selectedChildError // ignore: cast_nullable_to_non_nullable
as String,assignedToError: null == assignedToError ? _self.assignedToError : assignedToError // ignore: cast_nullable_to_non_nullable
as String,locationText: null == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String,locationError: null == locationError ? _self.locationError : locationError // ignore: cast_nullable_to_non_nullable
as String,coParentList: null == coParentList ? _self.coParentList : coParentList // ignore: cast_nullable_to_non_nullable
as List<UserModel>,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,selectedChildren: null == selectedChildren ? _self.selectedChildren : selectedChildren // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,selectedCoParentList: null == selectedCoParentList ? _self.selectedCoParentList : selectedCoParentList // ignore: cast_nullable_to_non_nullable
as List<UserModel>,documentsList: null == documentsList ? _self.documentsList : documentsList // ignore: cast_nullable_to_non_nullable
as List<String>,requestApprovalApiResultStatus: null == requestApprovalApiResultStatus ? _self.requestApprovalApiResultStatus : requestApprovalApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getChildApiResultStatus: null == getChildApiResultStatus ? _self.getChildApiResultStatus : getChildApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getCoParentApiResultStatus: null == getCoParentApiResultStatus ? _self.getCoParentApiResultStatus : getCoParentApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,uploadDocumentApiResultStatus: null == uploadDocumentApiResultStatus ? _self.uploadDocumentApiResultStatus : uploadDocumentApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}
/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get requestApprovalApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.requestApprovalApiResultStatus, (value) {
    return _then(_self.copyWith(requestApprovalApiResultStatus: value));
  });
}/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getChildApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getChildApiResultStatus, (value) {
    return _then(_self.copyWith(getChildApiResultStatus: value));
  });
}/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getCoParentApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getCoParentApiResultStatus, (value) {
    return _then(_self.copyWith(getCoParentApiResultStatus: value));
  });
}/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get uploadDocumentApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.uploadDocumentApiResultStatus, (value) {
    return _then(_self.copyWith(uploadDocumentApiResultStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [AddSharedEventState].
extension AddSharedEventStatePatterns on AddSharedEventState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddSharedEventState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddSharedEventState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddSharedEventState value)  $default,){
final _that = this;
switch (_that) {
case _AddSharedEventState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddSharedEventState value)?  $default,){
final _that = this;
switch (_that) {
case _AddSharedEventState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel? userModel,  String title,  String note,  DateTime? selectedDate,  DateTime? startTime,  DateTime? endTime,  String titleError,  String noteError,  String dateError,  String startTimeError,  String endTimeError,  bool requiredApproval,  String selectedChildError,  String assignedToError,  String locationText,  String locationError,  List<UserModel> coParentList,  List<ChildModel> children,  List<ChildModel> selectedChildren,  List<UserModel> selectedCoParentList,  List<String> documentsList,  ApiResultStatus requestApprovalApiResultStatus,  ApiResultStatus getChildApiResultStatus,  ApiResultStatus getCoParentApiResultStatus,  ApiResultStatus uploadDocumentApiResultStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddSharedEventState() when $default != null:
return $default(_that.userModel,_that.title,_that.note,_that.selectedDate,_that.startTime,_that.endTime,_that.titleError,_that.noteError,_that.dateError,_that.startTimeError,_that.endTimeError,_that.requiredApproval,_that.selectedChildError,_that.assignedToError,_that.locationText,_that.locationError,_that.coParentList,_that.children,_that.selectedChildren,_that.selectedCoParentList,_that.documentsList,_that.requestApprovalApiResultStatus,_that.getChildApiResultStatus,_that.getCoParentApiResultStatus,_that.uploadDocumentApiResultStatus);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel? userModel,  String title,  String note,  DateTime? selectedDate,  DateTime? startTime,  DateTime? endTime,  String titleError,  String noteError,  String dateError,  String startTimeError,  String endTimeError,  bool requiredApproval,  String selectedChildError,  String assignedToError,  String locationText,  String locationError,  List<UserModel> coParentList,  List<ChildModel> children,  List<ChildModel> selectedChildren,  List<UserModel> selectedCoParentList,  List<String> documentsList,  ApiResultStatus requestApprovalApiResultStatus,  ApiResultStatus getChildApiResultStatus,  ApiResultStatus getCoParentApiResultStatus,  ApiResultStatus uploadDocumentApiResultStatus)  $default,) {final _that = this;
switch (_that) {
case _AddSharedEventState():
return $default(_that.userModel,_that.title,_that.note,_that.selectedDate,_that.startTime,_that.endTime,_that.titleError,_that.noteError,_that.dateError,_that.startTimeError,_that.endTimeError,_that.requiredApproval,_that.selectedChildError,_that.assignedToError,_that.locationText,_that.locationError,_that.coParentList,_that.children,_that.selectedChildren,_that.selectedCoParentList,_that.documentsList,_that.requestApprovalApiResultStatus,_that.getChildApiResultStatus,_that.getCoParentApiResultStatus,_that.uploadDocumentApiResultStatus);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel? userModel,  String title,  String note,  DateTime? selectedDate,  DateTime? startTime,  DateTime? endTime,  String titleError,  String noteError,  String dateError,  String startTimeError,  String endTimeError,  bool requiredApproval,  String selectedChildError,  String assignedToError,  String locationText,  String locationError,  List<UserModel> coParentList,  List<ChildModel> children,  List<ChildModel> selectedChildren,  List<UserModel> selectedCoParentList,  List<String> documentsList,  ApiResultStatus requestApprovalApiResultStatus,  ApiResultStatus getChildApiResultStatus,  ApiResultStatus getCoParentApiResultStatus,  ApiResultStatus uploadDocumentApiResultStatus)?  $default,) {final _that = this;
switch (_that) {
case _AddSharedEventState() when $default != null:
return $default(_that.userModel,_that.title,_that.note,_that.selectedDate,_that.startTime,_that.endTime,_that.titleError,_that.noteError,_that.dateError,_that.startTimeError,_that.endTimeError,_that.requiredApproval,_that.selectedChildError,_that.assignedToError,_that.locationText,_that.locationError,_that.coParentList,_that.children,_that.selectedChildren,_that.selectedCoParentList,_that.documentsList,_that.requestApprovalApiResultStatus,_that.getChildApiResultStatus,_that.getCoParentApiResultStatus,_that.uploadDocumentApiResultStatus);case _:
  return null;

}
}

}

/// @nodoc


class _AddSharedEventState implements AddSharedEventState {
  const _AddSharedEventState({this.userModel, this.title = "", this.note = "", this.selectedDate, this.startTime, this.endTime, this.titleError = "", this.noteError = "", this.dateError = "", this.startTimeError = "", this.endTimeError = "", this.requiredApproval = false, this.selectedChildError = "", this.assignedToError = "", this.locationText = "", this.locationError = "", final  List<UserModel> coParentList = const [], final  List<ChildModel> children = const [], final  List<ChildModel> selectedChildren = const [], final  List<UserModel> selectedCoParentList = const [], final  List<String> documentsList = const [], this.requestApprovalApiResultStatus = const ApiResultStatus.initial(), this.getChildApiResultStatus = const ApiResultStatus.initial(), this.getCoParentApiResultStatus = const ApiResultStatus.initial(), this.uploadDocumentApiResultStatus = const ApiResultStatus.initial()}): _coParentList = coParentList,_children = children,_selectedChildren = selectedChildren,_selectedCoParentList = selectedCoParentList,_documentsList = documentsList;
  

@override final  UserModel? userModel;
@override@JsonKey() final  String title;
@override@JsonKey() final  String note;
@override final  DateTime? selectedDate;
@override final  DateTime? startTime;
@override final  DateTime? endTime;
@override@JsonKey() final  String titleError;
@override@JsonKey() final  String noteError;
@override@JsonKey() final  String dateError;
@override@JsonKey() final  String startTimeError;
@override@JsonKey() final  String endTimeError;
@override@JsonKey() final  bool requiredApproval;
@override@JsonKey() final  String selectedChildError;
@override@JsonKey() final  String assignedToError;
@override@JsonKey() final  String locationText;
@override@JsonKey() final  String locationError;
 final  List<UserModel> _coParentList;
@override@JsonKey() List<UserModel> get coParentList {
  if (_coParentList is EqualUnmodifiableListView) return _coParentList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coParentList);
}

 final  List<ChildModel> _children;
@override@JsonKey() List<ChildModel> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

 final  List<ChildModel> _selectedChildren;
@override@JsonKey() List<ChildModel> get selectedChildren {
  if (_selectedChildren is EqualUnmodifiableListView) return _selectedChildren;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedChildren);
}

 final  List<UserModel> _selectedCoParentList;
@override@JsonKey() List<UserModel> get selectedCoParentList {
  if (_selectedCoParentList is EqualUnmodifiableListView) return _selectedCoParentList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedCoParentList);
}

 final  List<String> _documentsList;
@override@JsonKey() List<String> get documentsList {
  if (_documentsList is EqualUnmodifiableListView) return _documentsList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_documentsList);
}

@override@JsonKey() final  ApiResultStatus requestApprovalApiResultStatus;
@override@JsonKey() final  ApiResultStatus getChildApiResultStatus;
@override@JsonKey() final  ApiResultStatus getCoParentApiResultStatus;
@override@JsonKey() final  ApiResultStatus uploadDocumentApiResultStatus;

/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddSharedEventStateCopyWith<_AddSharedEventState> get copyWith => __$AddSharedEventStateCopyWithImpl<_AddSharedEventState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddSharedEventState&&(identical(other.userModel, userModel) || other.userModel == userModel)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&(identical(other.selectedDate, selectedDate) || other.selectedDate == selectedDate)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.titleError, titleError) || other.titleError == titleError)&&(identical(other.noteError, noteError) || other.noteError == noteError)&&(identical(other.dateError, dateError) || other.dateError == dateError)&&(identical(other.startTimeError, startTimeError) || other.startTimeError == startTimeError)&&(identical(other.endTimeError, endTimeError) || other.endTimeError == endTimeError)&&(identical(other.requiredApproval, requiredApproval) || other.requiredApproval == requiredApproval)&&(identical(other.selectedChildError, selectedChildError) || other.selectedChildError == selectedChildError)&&(identical(other.assignedToError, assignedToError) || other.assignedToError == assignedToError)&&(identical(other.locationText, locationText) || other.locationText == locationText)&&(identical(other.locationError, locationError) || other.locationError == locationError)&&const DeepCollectionEquality().equals(other._coParentList, _coParentList)&&const DeepCollectionEquality().equals(other._children, _children)&&const DeepCollectionEquality().equals(other._selectedChildren, _selectedChildren)&&const DeepCollectionEquality().equals(other._selectedCoParentList, _selectedCoParentList)&&const DeepCollectionEquality().equals(other._documentsList, _documentsList)&&(identical(other.requestApprovalApiResultStatus, requestApprovalApiResultStatus) || other.requestApprovalApiResultStatus == requestApprovalApiResultStatus)&&(identical(other.getChildApiResultStatus, getChildApiResultStatus) || other.getChildApiResultStatus == getChildApiResultStatus)&&(identical(other.getCoParentApiResultStatus, getCoParentApiResultStatus) || other.getCoParentApiResultStatus == getCoParentApiResultStatus)&&(identical(other.uploadDocumentApiResultStatus, uploadDocumentApiResultStatus) || other.uploadDocumentApiResultStatus == uploadDocumentApiResultStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,userModel,title,note,selectedDate,startTime,endTime,titleError,noteError,dateError,startTimeError,endTimeError,requiredApproval,selectedChildError,assignedToError,locationText,locationError,const DeepCollectionEquality().hash(_coParentList),const DeepCollectionEquality().hash(_children),const DeepCollectionEquality().hash(_selectedChildren),const DeepCollectionEquality().hash(_selectedCoParentList),const DeepCollectionEquality().hash(_documentsList),requestApprovalApiResultStatus,getChildApiResultStatus,getCoParentApiResultStatus,uploadDocumentApiResultStatus]);

@override
String toString() {
  return 'AddSharedEventState(userModel: $userModel, title: $title, note: $note, selectedDate: $selectedDate, startTime: $startTime, endTime: $endTime, titleError: $titleError, noteError: $noteError, dateError: $dateError, startTimeError: $startTimeError, endTimeError: $endTimeError, requiredApproval: $requiredApproval, selectedChildError: $selectedChildError, assignedToError: $assignedToError, locationText: $locationText, locationError: $locationError, coParentList: $coParentList, children: $children, selectedChildren: $selectedChildren, selectedCoParentList: $selectedCoParentList, documentsList: $documentsList, requestApprovalApiResultStatus: $requestApprovalApiResultStatus, getChildApiResultStatus: $getChildApiResultStatus, getCoParentApiResultStatus: $getCoParentApiResultStatus, uploadDocumentApiResultStatus: $uploadDocumentApiResultStatus)';
}


}

/// @nodoc
abstract mixin class _$AddSharedEventStateCopyWith<$Res> implements $AddSharedEventStateCopyWith<$Res> {
  factory _$AddSharedEventStateCopyWith(_AddSharedEventState value, $Res Function(_AddSharedEventState) _then) = __$AddSharedEventStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? userModel, String title, String note, DateTime? selectedDate, DateTime? startTime, DateTime? endTime, String titleError, String noteError, String dateError, String startTimeError, String endTimeError, bool requiredApproval, String selectedChildError, String assignedToError, String locationText, String locationError, List<UserModel> coParentList, List<ChildModel> children, List<ChildModel> selectedChildren, List<UserModel> selectedCoParentList, List<String> documentsList, ApiResultStatus requestApprovalApiResultStatus, ApiResultStatus getChildApiResultStatus, ApiResultStatus getCoParentApiResultStatus, ApiResultStatus uploadDocumentApiResultStatus
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get requestApprovalApiResultStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get getChildApiResultStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get getCoParentApiResultStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get uploadDocumentApiResultStatus;

}
/// @nodoc
class __$AddSharedEventStateCopyWithImpl<$Res>
    implements _$AddSharedEventStateCopyWith<$Res> {
  __$AddSharedEventStateCopyWithImpl(this._self, this._then);

  final _AddSharedEventState _self;
  final $Res Function(_AddSharedEventState) _then;

/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userModel = freezed,Object? title = null,Object? note = null,Object? selectedDate = freezed,Object? startTime = freezed,Object? endTime = freezed,Object? titleError = null,Object? noteError = null,Object? dateError = null,Object? startTimeError = null,Object? endTimeError = null,Object? requiredApproval = null,Object? selectedChildError = null,Object? assignedToError = null,Object? locationText = null,Object? locationError = null,Object? coParentList = null,Object? children = null,Object? selectedChildren = null,Object? selectedCoParentList = null,Object? documentsList = null,Object? requestApprovalApiResultStatus = null,Object? getChildApiResultStatus = null,Object? getCoParentApiResultStatus = null,Object? uploadDocumentApiResultStatus = null,}) {
  return _then(_AddSharedEventState(
userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,selectedDate: freezed == selectedDate ? _self.selectedDate : selectedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,titleError: null == titleError ? _self.titleError : titleError // ignore: cast_nullable_to_non_nullable
as String,noteError: null == noteError ? _self.noteError : noteError // ignore: cast_nullable_to_non_nullable
as String,dateError: null == dateError ? _self.dateError : dateError // ignore: cast_nullable_to_non_nullable
as String,startTimeError: null == startTimeError ? _self.startTimeError : startTimeError // ignore: cast_nullable_to_non_nullable
as String,endTimeError: null == endTimeError ? _self.endTimeError : endTimeError // ignore: cast_nullable_to_non_nullable
as String,requiredApproval: null == requiredApproval ? _self.requiredApproval : requiredApproval // ignore: cast_nullable_to_non_nullable
as bool,selectedChildError: null == selectedChildError ? _self.selectedChildError : selectedChildError // ignore: cast_nullable_to_non_nullable
as String,assignedToError: null == assignedToError ? _self.assignedToError : assignedToError // ignore: cast_nullable_to_non_nullable
as String,locationText: null == locationText ? _self.locationText : locationText // ignore: cast_nullable_to_non_nullable
as String,locationError: null == locationError ? _self.locationError : locationError // ignore: cast_nullable_to_non_nullable
as String,coParentList: null == coParentList ? _self._coParentList : coParentList // ignore: cast_nullable_to_non_nullable
as List<UserModel>,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,selectedChildren: null == selectedChildren ? _self._selectedChildren : selectedChildren // ignore: cast_nullable_to_non_nullable
as List<ChildModel>,selectedCoParentList: null == selectedCoParentList ? _self._selectedCoParentList : selectedCoParentList // ignore: cast_nullable_to_non_nullable
as List<UserModel>,documentsList: null == documentsList ? _self._documentsList : documentsList // ignore: cast_nullable_to_non_nullable
as List<String>,requestApprovalApiResultStatus: null == requestApprovalApiResultStatus ? _self.requestApprovalApiResultStatus : requestApprovalApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getChildApiResultStatus: null == getChildApiResultStatus ? _self.getChildApiResultStatus : getChildApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,getCoParentApiResultStatus: null == getCoParentApiResultStatus ? _self.getCoParentApiResultStatus : getCoParentApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,uploadDocumentApiResultStatus: null == uploadDocumentApiResultStatus ? _self.uploadDocumentApiResultStatus : uploadDocumentApiResultStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus,
  ));
}

/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get requestApprovalApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.requestApprovalApiResultStatus, (value) {
    return _then(_self.copyWith(requestApprovalApiResultStatus: value));
  });
}/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getChildApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getChildApiResultStatus, (value) {
    return _then(_self.copyWith(getChildApiResultStatus: value));
  });
}/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get getCoParentApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.getCoParentApiResultStatus, (value) {
    return _then(_self.copyWith(getCoParentApiResultStatus: value));
  });
}/// Create a copy of AddSharedEventState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get uploadDocumentApiResultStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.uploadDocumentApiResultStatus, (value) {
    return _then(_self.copyWith(uploadDocumentApiResultStatus: value));
  });
}
}

// dart format on
