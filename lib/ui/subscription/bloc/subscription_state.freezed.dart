// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubscriptionState {

 bool get isLoading; int get selectedPlan; String get message; List<ProductDetails> get products; List<SubsProductDetails> get subsProductDetails; ProductDetails? get selectedProduct; UserModel? get userModel;
/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionStateCopyWith<SubscriptionState> get copyWith => _$SubscriptionStateCopyWithImpl<SubscriptionState>(this as SubscriptionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.selectedPlan, selectedPlan) || other.selectedPlan == selectedPlan)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.products, products)&&const DeepCollectionEquality().equals(other.subsProductDetails, subsProductDetails)&&(identical(other.selectedProduct, selectedProduct) || other.selectedProduct == selectedProduct)&&(identical(other.userModel, userModel) || other.userModel == userModel));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,selectedPlan,message,const DeepCollectionEquality().hash(products),const DeepCollectionEquality().hash(subsProductDetails),selectedProduct,userModel);

@override
String toString() {
  return 'SubscriptionState(isLoading: $isLoading, selectedPlan: $selectedPlan, message: $message, products: $products, subsProductDetails: $subsProductDetails, selectedProduct: $selectedProduct, userModel: $userModel)';
}


}

/// @nodoc
abstract mixin class $SubscriptionStateCopyWith<$Res>  {
  factory $SubscriptionStateCopyWith(SubscriptionState value, $Res Function(SubscriptionState) _then) = _$SubscriptionStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, int selectedPlan, String message, List<ProductDetails> products, List<SubsProductDetails> subsProductDetails, ProductDetails? selectedProduct, UserModel? userModel
});




}
/// @nodoc
class _$SubscriptionStateCopyWithImpl<$Res>
    implements $SubscriptionStateCopyWith<$Res> {
  _$SubscriptionStateCopyWithImpl(this._self, this._then);

  final SubscriptionState _self;
  final $Res Function(SubscriptionState) _then;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? selectedPlan = null,Object? message = null,Object? products = null,Object? subsProductDetails = null,Object? selectedProduct = freezed,Object? userModel = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,selectedPlan: null == selectedPlan ? _self.selectedPlan : selectedPlan // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<ProductDetails>,subsProductDetails: null == subsProductDetails ? _self.subsProductDetails : subsProductDetails // ignore: cast_nullable_to_non_nullable
as List<SubsProductDetails>,selectedProduct: freezed == selectedProduct ? _self.selectedProduct : selectedProduct // ignore: cast_nullable_to_non_nullable
as ProductDetails?,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubscriptionState].
extension SubscriptionStatePatterns on SubscriptionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubscriptionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubscriptionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubscriptionState value)  $default,){
final _that = this;
switch (_that) {
case _SubscriptionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubscriptionState value)?  $default,){
final _that = this;
switch (_that) {
case _SubscriptionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  int selectedPlan,  String message,  List<ProductDetails> products,  List<SubsProductDetails> subsProductDetails,  ProductDetails? selectedProduct,  UserModel? userModel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubscriptionState() when $default != null:
return $default(_that.isLoading,_that.selectedPlan,_that.message,_that.products,_that.subsProductDetails,_that.selectedProduct,_that.userModel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  int selectedPlan,  String message,  List<ProductDetails> products,  List<SubsProductDetails> subsProductDetails,  ProductDetails? selectedProduct,  UserModel? userModel)  $default,) {final _that = this;
switch (_that) {
case _SubscriptionState():
return $default(_that.isLoading,_that.selectedPlan,_that.message,_that.products,_that.subsProductDetails,_that.selectedProduct,_that.userModel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  int selectedPlan,  String message,  List<ProductDetails> products,  List<SubsProductDetails> subsProductDetails,  ProductDetails? selectedProduct,  UserModel? userModel)?  $default,) {final _that = this;
switch (_that) {
case _SubscriptionState() when $default != null:
return $default(_that.isLoading,_that.selectedPlan,_that.message,_that.products,_that.subsProductDetails,_that.selectedProduct,_that.userModel);case _:
  return null;

}
}

}

/// @nodoc


class _SubscriptionState implements SubscriptionState {
  const _SubscriptionState({this.isLoading = false, this.selectedPlan = 0, this.message = "", final  List<ProductDetails> products = const [], final  List<SubsProductDetails> subsProductDetails = const [], this.selectedProduct, this.userModel}): _products = products,_subsProductDetails = subsProductDetails;
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  int selectedPlan;
@override@JsonKey() final  String message;
 final  List<ProductDetails> _products;
@override@JsonKey() List<ProductDetails> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<SubsProductDetails> _subsProductDetails;
@override@JsonKey() List<SubsProductDetails> get subsProductDetails {
  if (_subsProductDetails is EqualUnmodifiableListView) return _subsProductDetails;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subsProductDetails);
}

@override final  ProductDetails? selectedProduct;
@override final  UserModel? userModel;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionStateCopyWith<_SubscriptionState> get copyWith => __$SubscriptionStateCopyWithImpl<_SubscriptionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubscriptionState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.selectedPlan, selectedPlan) || other.selectedPlan == selectedPlan)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._subsProductDetails, _subsProductDetails)&&(identical(other.selectedProduct, selectedProduct) || other.selectedProduct == selectedProduct)&&(identical(other.userModel, userModel) || other.userModel == userModel));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,selectedPlan,message,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_subsProductDetails),selectedProduct,userModel);

@override
String toString() {
  return 'SubscriptionState(isLoading: $isLoading, selectedPlan: $selectedPlan, message: $message, products: $products, subsProductDetails: $subsProductDetails, selectedProduct: $selectedProduct, userModel: $userModel)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionStateCopyWith<$Res> implements $SubscriptionStateCopyWith<$Res> {
  factory _$SubscriptionStateCopyWith(_SubscriptionState value, $Res Function(_SubscriptionState) _then) = __$SubscriptionStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, int selectedPlan, String message, List<ProductDetails> products, List<SubsProductDetails> subsProductDetails, ProductDetails? selectedProduct, UserModel? userModel
});




}
/// @nodoc
class __$SubscriptionStateCopyWithImpl<$Res>
    implements _$SubscriptionStateCopyWith<$Res> {
  __$SubscriptionStateCopyWithImpl(this._self, this._then);

  final _SubscriptionState _self;
  final $Res Function(_SubscriptionState) _then;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? selectedPlan = null,Object? message = null,Object? products = null,Object? subsProductDetails = null,Object? selectedProduct = freezed,Object? userModel = freezed,}) {
  return _then(_SubscriptionState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,selectedPlan: null == selectedPlan ? _self.selectedPlan : selectedPlan // ignore: cast_nullable_to_non_nullable
as int,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductDetails>,subsProductDetails: null == subsProductDetails ? _self._subsProductDetails : subsProductDetails // ignore: cast_nullable_to_non_nullable
as List<SubsProductDetails>,selectedProduct: freezed == selectedProduct ? _self.selectedProduct : selectedProduct // ignore: cast_nullable_to_non_nullable
as ProductDetails?,userModel: freezed == userModel ? _self.userModel : userModel // ignore: cast_nullable_to_non_nullable
as UserModel?,
  ));
}


}

// dart format on
