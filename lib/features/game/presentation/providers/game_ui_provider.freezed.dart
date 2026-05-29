// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_ui_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameUIState {

 List<PlayingCard> get selectedCards; Rank? get selectedRank; bool get isAnimating; bool get isResolvingChallenge; List<PlayingCard> get challengedCards;
/// Create a copy of GameUIState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameUIStateCopyWith<GameUIState> get copyWith => _$GameUIStateCopyWithImpl<GameUIState>(this as GameUIState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameUIState&&const DeepCollectionEquality().equals(other.selectedCards, selectedCards)&&(identical(other.selectedRank, selectedRank) || other.selectedRank == selectedRank)&&(identical(other.isAnimating, isAnimating) || other.isAnimating == isAnimating)&&(identical(other.isResolvingChallenge, isResolvingChallenge) || other.isResolvingChallenge == isResolvingChallenge)&&const DeepCollectionEquality().equals(other.challengedCards, challengedCards));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(selectedCards),selectedRank,isAnimating,isResolvingChallenge,const DeepCollectionEquality().hash(challengedCards));

@override
String toString() {
  return 'GameUIState(selectedCards: $selectedCards, selectedRank: $selectedRank, isAnimating: $isAnimating, isResolvingChallenge: $isResolvingChallenge, challengedCards: $challengedCards)';
}


}

/// @nodoc
abstract mixin class $GameUIStateCopyWith<$Res>  {
  factory $GameUIStateCopyWith(GameUIState value, $Res Function(GameUIState) _then) = _$GameUIStateCopyWithImpl;
@useResult
$Res call({
 List<PlayingCard> selectedCards, Rank? selectedRank, bool isAnimating, bool isResolvingChallenge, List<PlayingCard> challengedCards
});




}
/// @nodoc
class _$GameUIStateCopyWithImpl<$Res>
    implements $GameUIStateCopyWith<$Res> {
  _$GameUIStateCopyWithImpl(this._self, this._then);

  final GameUIState _self;
  final $Res Function(GameUIState) _then;

/// Create a copy of GameUIState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedCards = null,Object? selectedRank = freezed,Object? isAnimating = null,Object? isResolvingChallenge = null,Object? challengedCards = null,}) {
  return _then(_self.copyWith(
selectedCards: null == selectedCards ? _self.selectedCards : selectedCards // ignore: cast_nullable_to_non_nullable
as List<PlayingCard>,selectedRank: freezed == selectedRank ? _self.selectedRank : selectedRank // ignore: cast_nullable_to_non_nullable
as Rank?,isAnimating: null == isAnimating ? _self.isAnimating : isAnimating // ignore: cast_nullable_to_non_nullable
as bool,isResolvingChallenge: null == isResolvingChallenge ? _self.isResolvingChallenge : isResolvingChallenge // ignore: cast_nullable_to_non_nullable
as bool,challengedCards: null == challengedCards ? _self.challengedCards : challengedCards // ignore: cast_nullable_to_non_nullable
as List<PlayingCard>,
  ));
}

}


/// Adds pattern-matching-related methods to [GameUIState].
extension GameUIStatePatterns on GameUIState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameUIState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameUIState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameUIState value)  $default,){
final _that = this;
switch (_that) {
case _GameUIState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameUIState value)?  $default,){
final _that = this;
switch (_that) {
case _GameUIState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PlayingCard> selectedCards,  Rank? selectedRank,  bool isAnimating,  bool isResolvingChallenge,  List<PlayingCard> challengedCards)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameUIState() when $default != null:
return $default(_that.selectedCards,_that.selectedRank,_that.isAnimating,_that.isResolvingChallenge,_that.challengedCards);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PlayingCard> selectedCards,  Rank? selectedRank,  bool isAnimating,  bool isResolvingChallenge,  List<PlayingCard> challengedCards)  $default,) {final _that = this;
switch (_that) {
case _GameUIState():
return $default(_that.selectedCards,_that.selectedRank,_that.isAnimating,_that.isResolvingChallenge,_that.challengedCards);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PlayingCard> selectedCards,  Rank? selectedRank,  bool isAnimating,  bool isResolvingChallenge,  List<PlayingCard> challengedCards)?  $default,) {final _that = this;
switch (_that) {
case _GameUIState() when $default != null:
return $default(_that.selectedCards,_that.selectedRank,_that.isAnimating,_that.isResolvingChallenge,_that.challengedCards);case _:
  return null;

}
}

}

/// @nodoc


class _GameUIState implements GameUIState {
  const _GameUIState({final  List<PlayingCard> selectedCards = const [], this.selectedRank, this.isAnimating = false, this.isResolvingChallenge = false, final  List<PlayingCard> challengedCards = const []}): _selectedCards = selectedCards,_challengedCards = challengedCards;
  

 final  List<PlayingCard> _selectedCards;
@override@JsonKey() List<PlayingCard> get selectedCards {
  if (_selectedCards is EqualUnmodifiableListView) return _selectedCards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedCards);
}

@override final  Rank? selectedRank;
@override@JsonKey() final  bool isAnimating;
@override@JsonKey() final  bool isResolvingChallenge;
 final  List<PlayingCard> _challengedCards;
@override@JsonKey() List<PlayingCard> get challengedCards {
  if (_challengedCards is EqualUnmodifiableListView) return _challengedCards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_challengedCards);
}


/// Create a copy of GameUIState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameUIStateCopyWith<_GameUIState> get copyWith => __$GameUIStateCopyWithImpl<_GameUIState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameUIState&&const DeepCollectionEquality().equals(other._selectedCards, _selectedCards)&&(identical(other.selectedRank, selectedRank) || other.selectedRank == selectedRank)&&(identical(other.isAnimating, isAnimating) || other.isAnimating == isAnimating)&&(identical(other.isResolvingChallenge, isResolvingChallenge) || other.isResolvingChallenge == isResolvingChallenge)&&const DeepCollectionEquality().equals(other._challengedCards, _challengedCards));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_selectedCards),selectedRank,isAnimating,isResolvingChallenge,const DeepCollectionEquality().hash(_challengedCards));

@override
String toString() {
  return 'GameUIState(selectedCards: $selectedCards, selectedRank: $selectedRank, isAnimating: $isAnimating, isResolvingChallenge: $isResolvingChallenge, challengedCards: $challengedCards)';
}


}

/// @nodoc
abstract mixin class _$GameUIStateCopyWith<$Res> implements $GameUIStateCopyWith<$Res> {
  factory _$GameUIStateCopyWith(_GameUIState value, $Res Function(_GameUIState) _then) = __$GameUIStateCopyWithImpl;
@override @useResult
$Res call({
 List<PlayingCard> selectedCards, Rank? selectedRank, bool isAnimating, bool isResolvingChallenge, List<PlayingCard> challengedCards
});




}
/// @nodoc
class __$GameUIStateCopyWithImpl<$Res>
    implements _$GameUIStateCopyWith<$Res> {
  __$GameUIStateCopyWithImpl(this._self, this._then);

  final _GameUIState _self;
  final $Res Function(_GameUIState) _then;

/// Create a copy of GameUIState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedCards = null,Object? selectedRank = freezed,Object? isAnimating = null,Object? isResolvingChallenge = null,Object? challengedCards = null,}) {
  return _then(_GameUIState(
selectedCards: null == selectedCards ? _self._selectedCards : selectedCards // ignore: cast_nullable_to_non_nullable
as List<PlayingCard>,selectedRank: freezed == selectedRank ? _self.selectedRank : selectedRank // ignore: cast_nullable_to_non_nullable
as Rank?,isAnimating: null == isAnimating ? _self.isAnimating : isAnimating // ignore: cast_nullable_to_non_nullable
as bool,isResolvingChallenge: null == isResolvingChallenge ? _self.isResolvingChallenge : isResolvingChallenge // ignore: cast_nullable_to_non_nullable
as bool,challengedCards: null == challengedCards ? _self._challengedCards : challengedCards // ignore: cast_nullable_to_non_nullable
as List<PlayingCard>,
  ));
}


}

// dart format on
