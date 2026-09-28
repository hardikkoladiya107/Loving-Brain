// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brainy_conversation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BrainyConversationState {
  List<BrainyMessage> get messages;
  bool get isTyping;
  String? get conversationId;
  String? get topic;
  String? get selectedImagePath;
  String? get playingMessageId;
  bool get isAudioPlaying;

  /// Create a copy of BrainyConversationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BrainyConversationStateCopyWith<BrainyConversationState> get copyWith =>
      _$BrainyConversationStateCopyWithImpl<BrainyConversationState>(
        this as BrainyConversationState,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    final _this = this as BrainyConversationState;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BrainyConversationState &&
            const DeepCollectionEquality().equals(
              other.messages,
              _this.messages,
            ) &&
            (identical(other.isTyping, _this.isTyping) ||
                other.isTyping == _this.isTyping) &&
            (identical(other.conversationId, _this.conversationId) ||
                other.conversationId == _this.conversationId) &&
            (identical(other.topic, _this.topic) ||
                other.topic == _this.topic) &&
            (identical(other.selectedImagePath, _this.selectedImagePath) ||
                other.selectedImagePath == _this.selectedImagePath) &&
            (identical(other.playingMessageId, _this.playingMessageId) ||
                other.playingMessageId == _this.playingMessageId) &&
            (identical(other.isAudioPlaying, _this.isAudioPlaying) ||
                other.isAudioPlaying == _this.isAudioPlaying));
  }

  @override
  int get hashCode {
    final _this = this as BrainyConversationState;
    return Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_this.messages),
      _this.isTyping,
      _this.conversationId,
      _this.topic,
      _this.selectedImagePath,
      _this.playingMessageId,
      _this.isAudioPlaying,
    );
  }

  @override
  String toString() {
    final _this = this as BrainyConversationState;
    return 'BrainyConversationState(messages: ${_this.messages}, isTyping: ${_this.isTyping}, conversationId: ${_this.conversationId}, topic: ${_this.topic}, selectedImagePath: ${_this.selectedImagePath}, playingMessageId: ${_this.playingMessageId}, isAudioPlaying: ${_this.isAudioPlaying})';
  }
}

/// @nodoc
abstract mixin class $BrainyConversationStateCopyWith<$Res> {
  factory $BrainyConversationStateCopyWith(
    BrainyConversationState value,
    $Res Function(BrainyConversationState) _then,
  ) = _$BrainyConversationStateCopyWithImpl;
  @useResult
  $Res call({
    List<BrainyMessage> messages,
    bool isTyping,
    String? conversationId,
    String? topic,
    String? selectedImagePath,
    String? playingMessageId,
    bool isAudioPlaying,
  });
}

/// @nodoc
class _$BrainyConversationStateCopyWithImpl<$Res>
    implements $BrainyConversationStateCopyWith<$Res> {
  _$BrainyConversationStateCopyWithImpl(this._self, this._then);

  final BrainyConversationState _self;
  final $Res Function(BrainyConversationState) _then;

  /// Create a copy of BrainyConversationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messages = null,
    Object? isTyping = null,
    Object? conversationId = freezed,
    Object? topic = freezed,
    Object? selectedImagePath = freezed,
    Object? playingMessageId = freezed,
    Object? isAudioPlaying = null,
  }) {
    return _then(
      BrainyConversationState(
        messages: null == messages
            ? _self.messages
            : messages // ignore: cast_nullable_to_non_nullable
                  as List<BrainyMessage>,
        isTyping: null == isTyping
            ? _self.isTyping
            : isTyping // ignore: cast_nullable_to_non_nullable
                  as bool,
        conversationId: freezed == conversationId
            ? _self.conversationId
            : conversationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        topic: freezed == topic
            ? _self.topic
            : topic // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedImagePath: freezed == selectedImagePath
            ? _self.selectedImagePath
            : selectedImagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        playingMessageId: freezed == playingMessageId
            ? _self.playingMessageId
            : playingMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isAudioPlaying: null == isAudioPlaying
            ? _self.isAudioPlaying
            : isAudioPlaying // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [BrainyConversationState].
extension BrainyConversationStatePatterns on BrainyConversationState {
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BrainyConversationState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BrainyConversationState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BrainyConversationState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BrainyConversationState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BrainyConversationState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BrainyConversationState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      List<BrainyMessage> messages,
      bool isTyping,
      String? conversationId,
      String? topic,
      String? selectedImagePath,
      String? playingMessageId,
      bool isAudioPlaying,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BrainyConversationState() when $default != null:
        return $default(
          _that.messages,
          _that.isTyping,
          _that.conversationId,
          _that.topic,
          _that.selectedImagePath,
          _that.playingMessageId,
          _that.isAudioPlaying,
        );
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      List<BrainyMessage> messages,
      bool isTyping,
      String? conversationId,
      String? topic,
      String? selectedImagePath,
      String? playingMessageId,
      bool isAudioPlaying,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BrainyConversationState():
        return $default(
          _that.messages,
          _that.isTyping,
          _that.conversationId,
          _that.topic,
          _that.selectedImagePath,
          _that.playingMessageId,
          _that.isAudioPlaying,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      List<BrainyMessage> messages,
      bool isTyping,
      String? conversationId,
      String? topic,
      String? selectedImagePath,
      String? playingMessageId,
      bool isAudioPlaying,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BrainyConversationState() when $default != null:
        return $default(
          _that.messages,
          _that.isTyping,
          _that.conversationId,
          _that.topic,
          _that.selectedImagePath,
          _that.playingMessageId,
          _that.isAudioPlaying,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
class _BrainyConversationState implements BrainyConversationState {
  const _BrainyConversationState({
    List<BrainyMessage> messages = const [],
    this.isTyping = false,
    this.conversationId,
    this.topic,
    this.selectedImagePath,
    this.playingMessageId,
    this.isAudioPlaying = false,
  }) : _messages = messages;

  final List<BrainyMessage> _messages;
  @override
  @JsonKey()
  List<BrainyMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  @JsonKey()
  final bool isTyping;
  @override
  final String? conversationId;
  @override
  final String? topic;
  @override
  final String? selectedImagePath;
  @override
  final String? playingMessageId;
  @override
  @JsonKey()
  final bool isAudioPlaying;

  /// Create a copy of BrainyConversationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BrainyConversationStateCopyWith<_BrainyConversationState> get copyWith =>
      __$BrainyConversationStateCopyWithImpl<_BrainyConversationState>(
        this,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BrainyConversationState &&
            const DeepCollectionEquality().equals(other.messages, _messages) &&
            (identical(other.isTyping, isTyping) ||
                other.isTyping == isTyping) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.selectedImagePath, selectedImagePath) ||
                other.selectedImagePath == selectedImagePath) &&
            (identical(other.playingMessageId, playingMessageId) ||
                other.playingMessageId == playingMessageId) &&
            (identical(other.isAudioPlaying, isAudioPlaying) ||
                other.isAudioPlaying == isAudioPlaying));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_messages),
      isTyping,
      conversationId,
      topic,
      selectedImagePath,
      playingMessageId,
      isAudioPlaying,
    );
  }

  @override
  String toString() {
    return 'BrainyConversationState(messages: $messages, isTyping: $isTyping, conversationId: $conversationId, topic: $topic, selectedImagePath: $selectedImagePath, playingMessageId: $playingMessageId, isAudioPlaying: $isAudioPlaying)';
  }
}

/// @nodoc
abstract mixin class _$BrainyConversationStateCopyWith<$Res>
    implements $BrainyConversationStateCopyWith<$Res> {
  factory _$BrainyConversationStateCopyWith(
    _BrainyConversationState value,
    $Res Function(_BrainyConversationState) _then,
  ) = __$BrainyConversationStateCopyWithImpl;
  @override
  @useResult
  $Res call({
    List<BrainyMessage> messages,
    bool isTyping,
    String? conversationId,
    String? topic,
    String? selectedImagePath,
    String? playingMessageId,
    bool isAudioPlaying,
  });
}

/// @nodoc
class __$BrainyConversationStateCopyWithImpl<$Res>
    implements _$BrainyConversationStateCopyWith<$Res> {
  __$BrainyConversationStateCopyWithImpl(this._self, this._then);

  final _BrainyConversationState _self;
  final $Res Function(_BrainyConversationState) _then;

  /// Create a copy of BrainyConversationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? messages = null,
    Object? isTyping = null,
    Object? conversationId = freezed,
    Object? topic = freezed,
    Object? selectedImagePath = freezed,
    Object? playingMessageId = freezed,
    Object? isAudioPlaying = null,
  }) {
    return _then(
      _BrainyConversationState(
        messages: null == messages
            ? _self._messages
            : messages // ignore: cast_nullable_to_non_nullable
                  as List<BrainyMessage>,
        isTyping: null == isTyping
            ? _self.isTyping
            : isTyping // ignore: cast_nullable_to_non_nullable
                  as bool,
        conversationId: freezed == conversationId
            ? _self.conversationId
            : conversationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        topic: freezed == topic
            ? _self.topic
            : topic // ignore: cast_nullable_to_non_nullable
                  as String?,
        selectedImagePath: freezed == selectedImagePath
            ? _self.selectedImagePath
            : selectedImagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
        playingMessageId: freezed == playingMessageId
            ? _self.playingMessageId
            : playingMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isAudioPlaying: null == isAudioPlaying
            ? _self.isAudioPlaying
            : isAudioPlaying // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

// dart format on
