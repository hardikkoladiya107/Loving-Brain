// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'privacy_data_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PrivacyDataState {

 String get childName; bool get isDeletingAccount; bool get isAccountDeleted; int get pendingOfflineUpdatesCount; bool get isSyncing; String get lastSyncedTime; ApiResultStatus<dynamic> get syncStatus; ApiResultStatus<dynamic> get exportStatus; ApiResultStatus<dynamic> get deleteStatus; Map<String, dynamic>? get exportedData;
/// Create a copy of PrivacyDataState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivacyDataStateCopyWith<PrivacyDataState> get copyWith => _$PrivacyDataStateCopyWithImpl<PrivacyDataState>(this as PrivacyDataState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PrivacyDataState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivacyDataState&&(identical(other.childName, _this.childName) || other.childName == _this.childName)&&(identical(other.isDeletingAccount, _this.isDeletingAccount) || other.isDeletingAccount == _this.isDeletingAccount)&&(identical(other.isAccountDeleted, _this.isAccountDeleted) || other.isAccountDeleted == _this.isAccountDeleted)&&(identical(other.pendingOfflineUpdatesCount, _this.pendingOfflineUpdatesCount) || other.pendingOfflineUpdatesCount == _this.pendingOfflineUpdatesCount)&&(identical(other.isSyncing, _this.isSyncing) || other.isSyncing == _this.isSyncing)&&(identical(other.lastSyncedTime, _this.lastSyncedTime) || other.lastSyncedTime == _this.lastSyncedTime)&&(identical(other.syncStatus, _this.syncStatus) || other.syncStatus == _this.syncStatus)&&(identical(other.exportStatus, _this.exportStatus) || other.exportStatus == _this.exportStatus)&&(identical(other.deleteStatus, _this.deleteStatus) || other.deleteStatus == _this.deleteStatus)&&const DeepCollectionEquality().equals(other.exportedData, _this.exportedData));
}


@override
int get hashCode {
  final _this = this as PrivacyDataState;
  return Object.hash(runtimeType,_this.childName,_this.isDeletingAccount,_this.isAccountDeleted,_this.pendingOfflineUpdatesCount,_this.isSyncing,_this.lastSyncedTime,_this.syncStatus,_this.exportStatus,_this.deleteStatus,const DeepCollectionEquality().hash(_this.exportedData));
}

@override
String toString() {
  final _this = this as PrivacyDataState;
  return 'PrivacyDataState(childName: ${_this.childName}, isDeletingAccount: ${_this.isDeletingAccount}, isAccountDeleted: ${_this.isAccountDeleted}, pendingOfflineUpdatesCount: ${_this.pendingOfflineUpdatesCount}, isSyncing: ${_this.isSyncing}, lastSyncedTime: ${_this.lastSyncedTime}, syncStatus: ${_this.syncStatus}, exportStatus: ${_this.exportStatus}, deleteStatus: ${_this.deleteStatus}, exportedData: ${_this.exportedData})';
}


}

/// @nodoc
abstract mixin class $PrivacyDataStateCopyWith<$Res>  {
  factory $PrivacyDataStateCopyWith(PrivacyDataState value, $Res Function(PrivacyDataState) _then) = _$PrivacyDataStateCopyWithImpl;
@useResult
$Res call({
 String childName, bool isDeletingAccount, bool isAccountDeleted, int pendingOfflineUpdatesCount, bool isSyncing, String lastSyncedTime, ApiResultStatus<dynamic> syncStatus, ApiResultStatus<dynamic> exportStatus, ApiResultStatus<dynamic> deleteStatus, Map<String, dynamic>? exportedData
});


$ApiResultStatusCopyWith<dynamic, $Res> get syncStatus;$ApiResultStatusCopyWith<dynamic, $Res> get exportStatus;$ApiResultStatusCopyWith<dynamic, $Res> get deleteStatus;

}
/// @nodoc
class _$PrivacyDataStateCopyWithImpl<$Res>
    implements $PrivacyDataStateCopyWith<$Res> {
  _$PrivacyDataStateCopyWithImpl(this._self, this._then);

  final PrivacyDataState _self;
  final $Res Function(PrivacyDataState) _then;

/// Create a copy of PrivacyDataState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? childName = null,Object? isDeletingAccount = null,Object? isAccountDeleted = null,Object? pendingOfflineUpdatesCount = null,Object? isSyncing = null,Object? lastSyncedTime = null,Object? syncStatus = null,Object? exportStatus = null,Object? deleteStatus = null,Object? exportedData = freezed,}) {
  return _then(PrivacyDataState(
childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,isDeletingAccount: null == isDeletingAccount ? _self.isDeletingAccount : isDeletingAccount // ignore: cast_nullable_to_non_nullable
as bool,isAccountDeleted: null == isAccountDeleted ? _self.isAccountDeleted : isAccountDeleted // ignore: cast_nullable_to_non_nullable
as bool,pendingOfflineUpdatesCount: null == pendingOfflineUpdatesCount ? _self.pendingOfflineUpdatesCount : pendingOfflineUpdatesCount // ignore: cast_nullable_to_non_nullable
as int,isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,lastSyncedTime: null == lastSyncedTime ? _self.lastSyncedTime : lastSyncedTime // ignore: cast_nullable_to_non_nullable
as String,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,exportStatus: null == exportStatus ? _self.exportStatus : exportStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,deleteStatus: null == deleteStatus ? _self.deleteStatus : deleteStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,exportedData: freezed == exportedData ? _self.exportedData : exportedData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}
/// Create a copy of PrivacyDataState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get syncStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.syncStatus, (value) {
    return _then(_self.copyWith(syncStatus: value));
  });
}/// Create a copy of PrivacyDataState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get exportStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.exportStatus, (value) {
    return _then(_self.copyWith(exportStatus: value));
  });
}/// Create a copy of PrivacyDataState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get deleteStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.deleteStatus, (value) {
    return _then(_self.copyWith(deleteStatus: value));
  });
}
}


/// Adds pattern-matching-related methods to [PrivacyDataState].
extension PrivacyDataStatePatterns on PrivacyDataState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivacyDataState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivacyDataState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivacyDataState value)  $default,){
final _that = this;
switch (_that) {
case _PrivacyDataState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivacyDataState value)?  $default,){
final _that = this;
switch (_that) {
case _PrivacyDataState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String childName,  bool isDeletingAccount,  bool isAccountDeleted,  int pendingOfflineUpdatesCount,  bool isSyncing,  String lastSyncedTime,  ApiResultStatus<dynamic> syncStatus,  ApiResultStatus<dynamic> exportStatus,  ApiResultStatus<dynamic> deleteStatus,  Map<String, dynamic>? exportedData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivacyDataState() when $default != null:
return $default(_that.childName,_that.isDeletingAccount,_that.isAccountDeleted,_that.pendingOfflineUpdatesCount,_that.isSyncing,_that.lastSyncedTime,_that.syncStatus,_that.exportStatus,_that.deleteStatus,_that.exportedData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String childName,  bool isDeletingAccount,  bool isAccountDeleted,  int pendingOfflineUpdatesCount,  bool isSyncing,  String lastSyncedTime,  ApiResultStatus<dynamic> syncStatus,  ApiResultStatus<dynamic> exportStatus,  ApiResultStatus<dynamic> deleteStatus,  Map<String, dynamic>? exportedData)  $default,) {final _that = this;
switch (_that) {
case _PrivacyDataState():
return $default(_that.childName,_that.isDeletingAccount,_that.isAccountDeleted,_that.pendingOfflineUpdatesCount,_that.isSyncing,_that.lastSyncedTime,_that.syncStatus,_that.exportStatus,_that.deleteStatus,_that.exportedData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String childName,  bool isDeletingAccount,  bool isAccountDeleted,  int pendingOfflineUpdatesCount,  bool isSyncing,  String lastSyncedTime,  ApiResultStatus<dynamic> syncStatus,  ApiResultStatus<dynamic> exportStatus,  ApiResultStatus<dynamic> deleteStatus,  Map<String, dynamic>? exportedData)?  $default,) {final _that = this;
switch (_that) {
case _PrivacyDataState() when $default != null:
return $default(_that.childName,_that.isDeletingAccount,_that.isAccountDeleted,_that.pendingOfflineUpdatesCount,_that.isSyncing,_that.lastSyncedTime,_that.syncStatus,_that.exportStatus,_that.deleteStatus,_that.exportedData);case _:
  return null;

}
}

}

/// @nodoc


class _PrivacyDataState implements PrivacyDataState {
  const _PrivacyDataState({this.childName = 'your child', this.isDeletingAccount = false, this.isAccountDeleted = false, this.pendingOfflineUpdatesCount = 0, this.isSyncing = false, this.lastSyncedTime = '', this.syncStatus = const ApiResultStatus.initial(), this.exportStatus = const ApiResultStatus.initial(), this.deleteStatus = const ApiResultStatus.initial(),  Map<String, dynamic>? exportedData}): _exportedData = exportedData;
  

@override@JsonKey() final  String childName;
@override@JsonKey() final  bool isDeletingAccount;
@override@JsonKey() final  bool isAccountDeleted;
@override@JsonKey() final  int pendingOfflineUpdatesCount;
@override@JsonKey() final  bool isSyncing;
@override@JsonKey() final  String lastSyncedTime;
@override@JsonKey() final  ApiResultStatus<dynamic> syncStatus;
@override@JsonKey() final  ApiResultStatus<dynamic> exportStatus;
@override@JsonKey() final  ApiResultStatus<dynamic> deleteStatus;
 final  Map<String, dynamic>? _exportedData;
@override Map<String, dynamic>? get exportedData {
  final value = _exportedData;
  if (value == null) return null;
  if (_exportedData is EqualUnmodifiableMapView) return _exportedData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of PrivacyDataState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivacyDataStateCopyWith<_PrivacyDataState> get copyWith => __$PrivacyDataStateCopyWithImpl<_PrivacyDataState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivacyDataState&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.isDeletingAccount, isDeletingAccount) || other.isDeletingAccount == isDeletingAccount)&&(identical(other.isAccountDeleted, isAccountDeleted) || other.isAccountDeleted == isAccountDeleted)&&(identical(other.pendingOfflineUpdatesCount, pendingOfflineUpdatesCount) || other.pendingOfflineUpdatesCount == pendingOfflineUpdatesCount)&&(identical(other.isSyncing, isSyncing) || other.isSyncing == isSyncing)&&(identical(other.lastSyncedTime, lastSyncedTime) || other.lastSyncedTime == lastSyncedTime)&&(identical(other.syncStatus, syncStatus) || other.syncStatus == syncStatus)&&(identical(other.exportStatus, exportStatus) || other.exportStatus == exportStatus)&&(identical(other.deleteStatus, deleteStatus) || other.deleteStatus == deleteStatus)&&const DeepCollectionEquality().equals(other.exportedData, _exportedData));
}


@override
int get hashCode {
    return Object.hash(runtimeType,childName,isDeletingAccount,isAccountDeleted,pendingOfflineUpdatesCount,isSyncing,lastSyncedTime,syncStatus,exportStatus,deleteStatus,const DeepCollectionEquality().hash(_exportedData));
}

@override
String toString() {
    return 'PrivacyDataState(childName: $childName, isDeletingAccount: $isDeletingAccount, isAccountDeleted: $isAccountDeleted, pendingOfflineUpdatesCount: $pendingOfflineUpdatesCount, isSyncing: $isSyncing, lastSyncedTime: $lastSyncedTime, syncStatus: $syncStatus, exportStatus: $exportStatus, deleteStatus: $deleteStatus, exportedData: $exportedData)';
}


}

/// @nodoc
abstract mixin class _$PrivacyDataStateCopyWith<$Res> implements $PrivacyDataStateCopyWith<$Res> {
  factory _$PrivacyDataStateCopyWith(_PrivacyDataState value, $Res Function(_PrivacyDataState) _then) = __$PrivacyDataStateCopyWithImpl;
@override @useResult
$Res call({
 String childName, bool isDeletingAccount, bool isAccountDeleted, int pendingOfflineUpdatesCount, bool isSyncing, String lastSyncedTime, ApiResultStatus<dynamic> syncStatus, ApiResultStatus<dynamic> exportStatus, ApiResultStatus<dynamic> deleteStatus, Map<String, dynamic>? exportedData
});


@override $ApiResultStatusCopyWith<dynamic, $Res> get syncStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get exportStatus;@override $ApiResultStatusCopyWith<dynamic, $Res> get deleteStatus;

}
/// @nodoc
class __$PrivacyDataStateCopyWithImpl<$Res>
    implements _$PrivacyDataStateCopyWith<$Res> {
  __$PrivacyDataStateCopyWithImpl(this._self, this._then);

  final _PrivacyDataState _self;
  final $Res Function(_PrivacyDataState) _then;

/// Create a copy of PrivacyDataState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? childName = null,Object? isDeletingAccount = null,Object? isAccountDeleted = null,Object? pendingOfflineUpdatesCount = null,Object? isSyncing = null,Object? lastSyncedTime = null,Object? syncStatus = null,Object? exportStatus = null,Object? deleteStatus = null,Object? exportedData = freezed,}) {
  return _then(_PrivacyDataState(
childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,isDeletingAccount: null == isDeletingAccount ? _self.isDeletingAccount : isDeletingAccount // ignore: cast_nullable_to_non_nullable
as bool,isAccountDeleted: null == isAccountDeleted ? _self.isAccountDeleted : isAccountDeleted // ignore: cast_nullable_to_non_nullable
as bool,pendingOfflineUpdatesCount: null == pendingOfflineUpdatesCount ? _self.pendingOfflineUpdatesCount : pendingOfflineUpdatesCount // ignore: cast_nullable_to_non_nullable
as int,isSyncing: null == isSyncing ? _self.isSyncing : isSyncing // ignore: cast_nullable_to_non_nullable
as bool,lastSyncedTime: null == lastSyncedTime ? _self.lastSyncedTime : lastSyncedTime // ignore: cast_nullable_to_non_nullable
as String,syncStatus: null == syncStatus ? _self.syncStatus : syncStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,exportStatus: null == exportStatus ? _self.exportStatus : exportStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,deleteStatus: null == deleteStatus ? _self.deleteStatus : deleteStatus // ignore: cast_nullable_to_non_nullable
as ApiResultStatus<dynamic>,exportedData: freezed == exportedData ? _self._exportedData : exportedData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

/// Create a copy of PrivacyDataState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get syncStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.syncStatus, (value) {
    return _then(_self.copyWith(syncStatus: value));
  });
}/// Create a copy of PrivacyDataState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get exportStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.exportStatus, (value) {
    return _then(_self.copyWith(exportStatus: value));
  });
}/// Create a copy of PrivacyDataState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApiResultStatusCopyWith<dynamic, $Res> get deleteStatus {
  
  return $ApiResultStatusCopyWith<dynamic, $Res>(_self.deleteStatus, (value) {
    return _then(_self.copyWith(deleteStatus: value));
  });
}
}

// dart format on
