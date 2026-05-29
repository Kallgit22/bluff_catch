// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Player {

 String get playerId; String get playerName; int get avatarColor; List<PlayingCard> get handCards; int? get rankPosition; bool get isEliminated; bool get currentTurn; bool get hasPassed; bool get hasPendingVictory; int get liesCaught; int get successfulBluffs; int get challengesWon; int get cardsConsumed;
/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerCopyWith<Player> get copyWith => _$PlayerCopyWithImpl<Player>(this as Player, _$identity);

  /// Serializes this Player to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Player&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.avatarColor, avatarColor) || other.avatarColor == avatarColor)&&const DeepCollectionEquality().equals(other.handCards, handCards)&&(identical(other.rankPosition, rankPosition) || other.rankPosition == rankPosition)&&(identical(other.isEliminated, isEliminated) || other.isEliminated == isEliminated)&&(identical(other.currentTurn, currentTurn) || other.currentTurn == currentTurn)&&(identical(other.hasPassed, hasPassed) || other.hasPassed == hasPassed)&&(identical(other.hasPendingVictory, hasPendingVictory) || other.hasPendingVictory == hasPendingVictory)&&(identical(other.liesCaught, liesCaught) || other.liesCaught == liesCaught)&&(identical(other.successfulBluffs, successfulBluffs) || other.successfulBluffs == successfulBluffs)&&(identical(other.challengesWon, challengesWon) || other.challengesWon == challengesWon)&&(identical(other.cardsConsumed, cardsConsumed) || other.cardsConsumed == cardsConsumed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerName,avatarColor,const DeepCollectionEquality().hash(handCards),rankPosition,isEliminated,currentTurn,hasPassed,hasPendingVictory,liesCaught,successfulBluffs,challengesWon,cardsConsumed);

@override
String toString() {
  return 'Player(playerId: $playerId, playerName: $playerName, avatarColor: $avatarColor, handCards: $handCards, rankPosition: $rankPosition, isEliminated: $isEliminated, currentTurn: $currentTurn, hasPassed: $hasPassed, hasPendingVictory: $hasPendingVictory, liesCaught: $liesCaught, successfulBluffs: $successfulBluffs, challengesWon: $challengesWon, cardsConsumed: $cardsConsumed)';
}


}

/// @nodoc
abstract mixin class $PlayerCopyWith<$Res>  {
  factory $PlayerCopyWith(Player value, $Res Function(Player) _then) = _$PlayerCopyWithImpl;
@useResult
$Res call({
 String playerId, String playerName, int avatarColor, List<PlayingCard> handCards, int? rankPosition, bool isEliminated, bool currentTurn, bool hasPassed, bool hasPendingVictory, int liesCaught, int successfulBluffs, int challengesWon, int cardsConsumed
});




}
/// @nodoc
class _$PlayerCopyWithImpl<$Res>
    implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._self, this._then);

  final Player _self;
  final $Res Function(Player) _then;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? playerName = null,Object? avatarColor = null,Object? handCards = null,Object? rankPosition = freezed,Object? isEliminated = null,Object? currentTurn = null,Object? hasPassed = null,Object? hasPendingVictory = null,Object? liesCaught = null,Object? successfulBluffs = null,Object? challengesWon = null,Object? cardsConsumed = null,}) {
  return _then(_self.copyWith(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,avatarColor: null == avatarColor ? _self.avatarColor : avatarColor // ignore: cast_nullable_to_non_nullable
as int,handCards: null == handCards ? _self.handCards : handCards // ignore: cast_nullable_to_non_nullable
as List<PlayingCard>,rankPosition: freezed == rankPosition ? _self.rankPosition : rankPosition // ignore: cast_nullable_to_non_nullable
as int?,isEliminated: null == isEliminated ? _self.isEliminated : isEliminated // ignore: cast_nullable_to_non_nullable
as bool,currentTurn: null == currentTurn ? _self.currentTurn : currentTurn // ignore: cast_nullable_to_non_nullable
as bool,hasPassed: null == hasPassed ? _self.hasPassed : hasPassed // ignore: cast_nullable_to_non_nullable
as bool,hasPendingVictory: null == hasPendingVictory ? _self.hasPendingVictory : hasPendingVictory // ignore: cast_nullable_to_non_nullable
as bool,liesCaught: null == liesCaught ? _self.liesCaught : liesCaught // ignore: cast_nullable_to_non_nullable
as int,successfulBluffs: null == successfulBluffs ? _self.successfulBluffs : successfulBluffs // ignore: cast_nullable_to_non_nullable
as int,challengesWon: null == challengesWon ? _self.challengesWon : challengesWon // ignore: cast_nullable_to_non_nullable
as int,cardsConsumed: null == cardsConsumed ? _self.cardsConsumed : cardsConsumed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Player].
extension PlayerPatterns on Player {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Player value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Player() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Player value)  $default,){
final _that = this;
switch (_that) {
case _Player():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Player value)?  $default,){
final _that = this;
switch (_that) {
case _Player() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String playerId,  String playerName,  int avatarColor,  List<PlayingCard> handCards,  int? rankPosition,  bool isEliminated,  bool currentTurn,  bool hasPassed,  bool hasPendingVictory,  int liesCaught,  int successfulBluffs,  int challengesWon,  int cardsConsumed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that.playerId,_that.playerName,_that.avatarColor,_that.handCards,_that.rankPosition,_that.isEliminated,_that.currentTurn,_that.hasPassed,_that.hasPendingVictory,_that.liesCaught,_that.successfulBluffs,_that.challengesWon,_that.cardsConsumed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String playerId,  String playerName,  int avatarColor,  List<PlayingCard> handCards,  int? rankPosition,  bool isEliminated,  bool currentTurn,  bool hasPassed,  bool hasPendingVictory,  int liesCaught,  int successfulBluffs,  int challengesWon,  int cardsConsumed)  $default,) {final _that = this;
switch (_that) {
case _Player():
return $default(_that.playerId,_that.playerName,_that.avatarColor,_that.handCards,_that.rankPosition,_that.isEliminated,_that.currentTurn,_that.hasPassed,_that.hasPendingVictory,_that.liesCaught,_that.successfulBluffs,_that.challengesWon,_that.cardsConsumed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String playerId,  String playerName,  int avatarColor,  List<PlayingCard> handCards,  int? rankPosition,  bool isEliminated,  bool currentTurn,  bool hasPassed,  bool hasPendingVictory,  int liesCaught,  int successfulBluffs,  int challengesWon,  int cardsConsumed)?  $default,) {final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that.playerId,_that.playerName,_that.avatarColor,_that.handCards,_that.rankPosition,_that.isEliminated,_that.currentTurn,_that.hasPassed,_that.hasPendingVictory,_that.liesCaught,_that.successfulBluffs,_that.challengesWon,_that.cardsConsumed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Player extends Player {
  const _Player({required this.playerId, required this.playerName, required this.avatarColor, final  List<PlayingCard> handCards = const [], this.rankPosition, this.isEliminated = false, this.currentTurn = false, this.hasPassed = false, this.hasPendingVictory = false, this.liesCaught = 0, this.successfulBluffs = 0, this.challengesWon = 0, this.cardsConsumed = 0}): _handCards = handCards,super._();
  factory _Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

@override final  String playerId;
@override final  String playerName;
@override final  int avatarColor;
 final  List<PlayingCard> _handCards;
@override@JsonKey() List<PlayingCard> get handCards {
  if (_handCards is EqualUnmodifiableListView) return _handCards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_handCards);
}

@override final  int? rankPosition;
@override@JsonKey() final  bool isEliminated;
@override@JsonKey() final  bool currentTurn;
@override@JsonKey() final  bool hasPassed;
@override@JsonKey() final  bool hasPendingVictory;
@override@JsonKey() final  int liesCaught;
@override@JsonKey() final  int successfulBluffs;
@override@JsonKey() final  int challengesWon;
@override@JsonKey() final  int cardsConsumed;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerCopyWith<_Player> get copyWith => __$PlayerCopyWithImpl<_Player>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Player&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.avatarColor, avatarColor) || other.avatarColor == avatarColor)&&const DeepCollectionEquality().equals(other._handCards, _handCards)&&(identical(other.rankPosition, rankPosition) || other.rankPosition == rankPosition)&&(identical(other.isEliminated, isEliminated) || other.isEliminated == isEliminated)&&(identical(other.currentTurn, currentTurn) || other.currentTurn == currentTurn)&&(identical(other.hasPassed, hasPassed) || other.hasPassed == hasPassed)&&(identical(other.hasPendingVictory, hasPendingVictory) || other.hasPendingVictory == hasPendingVictory)&&(identical(other.liesCaught, liesCaught) || other.liesCaught == liesCaught)&&(identical(other.successfulBluffs, successfulBluffs) || other.successfulBluffs == successfulBluffs)&&(identical(other.challengesWon, challengesWon) || other.challengesWon == challengesWon)&&(identical(other.cardsConsumed, cardsConsumed) || other.cardsConsumed == cardsConsumed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerName,avatarColor,const DeepCollectionEquality().hash(_handCards),rankPosition,isEliminated,currentTurn,hasPassed,hasPendingVictory,liesCaught,successfulBluffs,challengesWon,cardsConsumed);

@override
String toString() {
  return 'Player(playerId: $playerId, playerName: $playerName, avatarColor: $avatarColor, handCards: $handCards, rankPosition: $rankPosition, isEliminated: $isEliminated, currentTurn: $currentTurn, hasPassed: $hasPassed, hasPendingVictory: $hasPendingVictory, liesCaught: $liesCaught, successfulBluffs: $successfulBluffs, challengesWon: $challengesWon, cardsConsumed: $cardsConsumed)';
}


}

/// @nodoc
abstract mixin class _$PlayerCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$PlayerCopyWith(_Player value, $Res Function(_Player) _then) = __$PlayerCopyWithImpl;
@override @useResult
$Res call({
 String playerId, String playerName, int avatarColor, List<PlayingCard> handCards, int? rankPosition, bool isEliminated, bool currentTurn, bool hasPassed, bool hasPendingVictory, int liesCaught, int successfulBluffs, int challengesWon, int cardsConsumed
});




}
/// @nodoc
class __$PlayerCopyWithImpl<$Res>
    implements _$PlayerCopyWith<$Res> {
  __$PlayerCopyWithImpl(this._self, this._then);

  final _Player _self;
  final $Res Function(_Player) _then;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? playerName = null,Object? avatarColor = null,Object? handCards = null,Object? rankPosition = freezed,Object? isEliminated = null,Object? currentTurn = null,Object? hasPassed = null,Object? hasPendingVictory = null,Object? liesCaught = null,Object? successfulBluffs = null,Object? challengesWon = null,Object? cardsConsumed = null,}) {
  return _then(_Player(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,avatarColor: null == avatarColor ? _self.avatarColor : avatarColor // ignore: cast_nullable_to_non_nullable
as int,handCards: null == handCards ? _self._handCards : handCards // ignore: cast_nullable_to_non_nullable
as List<PlayingCard>,rankPosition: freezed == rankPosition ? _self.rankPosition : rankPosition // ignore: cast_nullable_to_non_nullable
as int?,isEliminated: null == isEliminated ? _self.isEliminated : isEliminated // ignore: cast_nullable_to_non_nullable
as bool,currentTurn: null == currentTurn ? _self.currentTurn : currentTurn // ignore: cast_nullable_to_non_nullable
as bool,hasPassed: null == hasPassed ? _self.hasPassed : hasPassed // ignore: cast_nullable_to_non_nullable
as bool,hasPendingVictory: null == hasPendingVictory ? _self.hasPendingVictory : hasPendingVictory // ignore: cast_nullable_to_non_nullable
as bool,liesCaught: null == liesCaught ? _self.liesCaught : liesCaught // ignore: cast_nullable_to_non_nullable
as int,successfulBluffs: null == successfulBluffs ? _self.successfulBluffs : successfulBluffs // ignore: cast_nullable_to_non_nullable
as int,challengesWon: null == challengesWon ? _self.challengesWon : challengesWon // ignore: cast_nullable_to_non_nullable
as int,cardsConsumed: null == cardsConsumed ? _self.cardsConsumed : cardsConsumed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
