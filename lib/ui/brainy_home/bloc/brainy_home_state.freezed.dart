// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brainy_home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BrainyHomeState {
  String get selectedTopic;
  String get parentName;
  String get childName;
  String get chatText;
  List<String> get suggestedQuestions;

  /// Create a copy of BrainyHomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BrainyHomeStateCopyWith<BrainyHomeState> get copyWith =>
      _$BrainyHomeStateCopyWithImpl<BrainyHomeState>(
          this as BrainyHomeState, _$identity);

  @override
  bool operator ==(Object other) {
    final _this = this as BrainyHomeState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BrainyHomeState &&
            (identical(other.selectedTopic, _this.selectedTopic) ||
                other.selectedTopic == _this.selectedTopic) &&
            (identical(other.parentName, _this.parentName) ||
                other.parentName == _this.parentName) &&
            (identical(other.childName, _this.childName) ||
                other.childName == _this.childName) &&
            (identical(other.chatText, _this.chatText) ||
                other.chatText == _this.chatText) &&
            const DeepCollectionEquality()
                .equals(other.suggestedQuestions, _this.suggestedQuestions));
  }

  @override
  int get hashCode {
    final _this = this as BrainyHomeState;
    return Object.hash(
        runtimeType,
        _this.selectedTopic,
        _this.parentName,
        _this.childName,
        _this.chatText,
        const DeepCollectionEquality().hash(_this.suggestedQuestions));
  }

  @override
  String toString() {
    final _this = this as BrainyHomeState;
    return 'BrainyHomeState(selectedTopic: ${_this.selectedTopic}, parentName: ${_this.parentName}, childName: ${_this.childName}, chatText: ${_this.chatText}, suggestedQuestions: ${_this.suggestedQuestions})';
  }
}

/// @nodoc
abstract mixin class $BrainyHomeStateCopyWith<$Res> {
  factory $BrainyHomeStateCopyWith(
          BrainyHomeState value, $Res Function(BrainyHomeState) _then) =
      _$BrainyHomeStateCopyWithImpl;
  @useResult
  $Res call(
      {String selectedTopic,
      String parentName,
      String childName,
      String chatText,
      List<String> suggestedQuestions});
}

/// @nodoc
class _$BrainyHomeStateCopyWithImpl<$Res>
    implements $BrainyHomeStateCopyWith<$Res> {
  _$BrainyHomeStateCopyWithImpl(this._self, this._then);

  final BrainyHomeState _self;
  final $Res Function(BrainyHomeState) _then;

  /// Create a copy of BrainyHomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedTopic = null,
    Object? parentName = null,
    Object? childName = null,
    Object? chatText = null,
    Object? suggestedQuestions = null,
  }) {
    return _then(BrainyHomeState(
      selectedTopic: null == selectedTopic
          ? _self.selectedTopic
          : selectedTopic // ignore: cast_nullable_to_non_nullable
              as String,
      parentName: null == parentName
          ? _self.parentName
          : parentName // ignore: cast_nullable_to_non_nullable
              as String,
      childName: null == childName
          ? _self.childName
          : childName // ignore: cast_nullable_to_non_nullable
              as String,
      chatText: null == chatText
          ? _self.chatText
          : chatText // ignore: cast_nullable_to_non_nullable
              as String,
      suggestedQuestions: null == suggestedQuestions
          ? _self.suggestedQuestions
          : suggestedQuestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [BrainyHomeState].
extension BrainyHomeStatePatterns on BrainyHomeState {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BrainyHomeState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BrainyHomeState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BrainyHomeState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BrainyHomeState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BrainyHomeState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BrainyHomeState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String selectedTopic, String parentName, String childName,
            String chatText, List<String> suggestedQuestions)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BrainyHomeState() when $default != null:
        return $default(_that.selectedTopic, _that.parentName, _that.childName,
            _that.chatText, _that.suggestedQuestions);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String selectedTopic, String parentName, String childName,
            String chatText, List<String> suggestedQuestions)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BrainyHomeState():
        return $default(_that.selectedTopic, _that.parentName, _that.childName,
            _that.chatText, _that.suggestedQuestions);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String selectedTopic, String parentName, String childName,
            String chatText, List<String> suggestedQuestions)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BrainyHomeState() when $default != null:
        return $default(_that.selectedTopic, _that.parentName, _that.childName,
            _that.chatText, _that.suggestedQuestions);
      case _:
        return null;
    }
  }
}

/// @nodoc
class _BrainyHomeState implements BrainyHomeState {
  const _BrainyHomeState({
    this.selectedTopic = 'Behaviour',
    this.parentName = 'Parent',
    this.childName = 'your child',
    this.chatText = '',
    final List<String> suggestedQuestions = const [
      'Why is bedtime harder lately?',
      'What can I try tonight?',
    ],
  }) : _suggestedQuestions = suggestedQuestions;

  @override
  @JsonKey()
  final String selectedTopic;
  @override
  @JsonKey()
  final String parentName;
  @override
  @JsonKey()
  final String childName;
  @override
  @JsonKey()
  final String chatText;
  final List<String> _suggestedQuestions;
  @override
  @JsonKey()
  List<String> get suggestedQuestions {
    if (_suggestedQuestions is EqualUnmodifiableListView)
      return _suggestedQuestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestedQuestions);
  }

  /// Create a copy of BrainyHomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BrainyHomeStateCopyWith<_BrainyHomeState> get copyWith =>
      __$BrainyHomeStateCopyWithImpl<_BrainyHomeState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BrainyHomeState &&
            (identical(other.selectedTopic, selectedTopic) ||
                other.selectedTopic == selectedTopic) &&
            (identical(other.parentName, parentName) ||
                other.parentName == parentName) &&
            (identical(other.childName, childName) ||
                other.childName == childName) &&
            (identical(other.chatText, chatText) ||
                other.chatText == chatText) &&
            const DeepCollectionEquality()
                .equals(other._suggestedQuestions, _suggestedQuestions));
  }

  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        selectedTopic,
        parentName,
        childName,
        chatText,
        const DeepCollectionEquality().hash(_suggestedQuestions));
  }

  @override
  String toString() {
    return 'BrainyHomeState(selectedTopic: $selectedTopic, parentName: $parentName, childName: $childName, chatText: $chatText, suggestedQuestions: $suggestedQuestions)';
  }
}

/// @nodoc
abstract mixin class _$BrainyHomeStateCopyWith<$Res>
    implements $BrainyHomeStateCopyWith<$Res> {
  factory _$BrainyHomeStateCopyWith(
          _BrainyHomeState value, $Res Function(_BrainyHomeState) _then) =
      __$BrainyHomeStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String selectedTopic,
      String parentName,
      String childName,
      String chatText,
      List<String> suggestedQuestions});
}

/// @nodoc
class __$BrainyHomeStateCopyWithImpl<$Res>
    implements _$BrainyHomeStateCopyWith<$Res> {
  __$BrainyHomeStateCopyWithImpl(this._self, this._then);

  final _BrainyHomeState _self;
  final $Res Function(_BrainyHomeState) _then;

  /// Create a copy of BrainyHomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? selectedTopic = null,
    Object? parentName = null,
    Object? childName = null,
    Object? chatText = null,
    Object? suggestedQuestions = null,
  }) {
    return _then(_BrainyHomeState(
      selectedTopic: null == selectedTopic
          ? _self.selectedTopic
          : selectedTopic // ignore: cast_nullable_to_non_nullable
              as String,
      parentName: null == parentName
          ? _self.parentName
          : parentName // ignore: cast_nullable_to_non_nullable
              as String,
      childName: null == childName
          ? _self.childName
          : childName // ignore: cast_nullable_to_non_nullable
              as String,
      chatText: null == chatText
          ? _self.chatText
          : chatText // ignore: cast_nullable_to_non_nullable
              as String,
      suggestedQuestions: null == suggestedQuestions
          ? _self._suggestedQuestions
          : suggestedQuestions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
