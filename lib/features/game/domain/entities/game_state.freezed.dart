// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameState {

 List<Player> get players; List<PlayingCard> get pool; List<PlayingCard> get discardPile; Rank? get currentClaimedRank; String? get lastPlayerId; List<PlayingCard> get lastPlayedCards; int get passCount; int get activePlayerIndex; GameStatus get status; AnimationEvent get lastEvent;
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateCopyWith<GameState> get copyWith => _$GameStateCopyWithImpl<GameState>(this as GameState, _$identity);

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameState&&const DeepCollectionEquality().equals(other.players, players)&&const DeepCollectionEquality().equals(other.pool, pool)&&const DeepCollectionEquality().equals(other.discardPile, discardPile)&&(identical(other.currentClaimedRank, currentClaimedRank) || other.currentClaimedRank == currentClaimedRank)&&(identical(other.lastPlayerId, lastPlayerId) || other.lastPlayerId == lastPlayerId)&&const DeepCollectionEquality().equals(other.lastPlayedCards, lastPlayedCards)&&(identical(other.passCount, passCount) || other.passCount == passCount)&&(identical(other.activePlayerIndex, activePlayerIndex) || other.activePlayerIndex == activePlayerIndex)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastEvent, lastEvent) || other.lastEvent == lastEvent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(players),const DeepCollectionEquality().hash(pool),const DeepCollectionEquality().hash(discardPile),currentClaimedRank,lastPlayerId,const DeepCollectionEquality().hash(lastPlayedCards),passCount,activePlayerIndex,status,lastEvent);

@override
String toString() {
  return 'GameState(players: $players, pool: $pool, discardPile: $discardPile, currentClaimedRank: $currentClaimedRank, lastPlayerId: $lastPlayerId, lastPlayedCards: $lastPlayedCards, passCount: $passCount, activePlayerIndex: $activePlayerIndex, status: $status, lastEvent: $lastEvent)';
}


}

/// @nodoc
abstract mixin class $GameStateCopyWith<$Res>  {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) _then) = _$GameStateCopyWithImpl;
@useResult
$Res call({
 List<Player> players, List<PlayingCard> pool, List<PlayingCard> discardPile, Rank? currentClaimedRank, String? lastPlayerId, List<PlayingCard> lastPlayedCards, int passCount, int activePlayerIndex, GameStatus status, AnimationEvent lastEvent
});




}
/// @nodoc
class _$GameStateCopyWithImpl<$Res>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._self, this._then);

  final GameState _self;
  final $Res Function(GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? players = null,Object? pool = null,Object? discardPile = null,Object? currentClaimedRank = freezed,Object? lastPlayerId = freezed,Object? lastPlayedCards = null,Object? passCount = null,Object? activePlayerIndex = null,Object? status = null,Object? lastEvent = null,}) {
  return _then(_self.copyWith(
players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,pool: null == pool ? _self.pool : pool // ignore: cast_nullable_to_non_nullable
as List<PlayingCard>,discardPile: null == discardPile ? _self.discardPile : discardPile // ignore: cast_nullable_to_non_nullable
as List<PlayingCard>,currentClaimedRank: freezed == currentClaimedRank ? _self.currentClaimedRank : currentClaimedRank // ignore: cast_nullable_to_non_nullable
as Rank?,lastPlayerId: freezed == lastPlayerId ? _self.lastPlayerId : lastPlayerId // ignore: cast_nullable_to_non_nullable
as String?,lastPlayedCards: null == lastPlayedCards ? _self.lastPlayedCards : lastPlayedCards // ignore: cast_nullable_to_non_nullable
as List<PlayingCard>,passCount: null == passCount ? _self.passCount : passCount // ignore: cast_nullable_to_non_nullable
as int,activePlayerIndex: null == activePlayerIndex ? _self.activePlayerIndex : activePlayerIndex // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GameStatus,lastEvent: null == lastEvent ? _self.lastEvent : lastEvent // ignore: cast_nullable_to_non_nullable
as AnimationEvent,
  ));
}

}


/// Adds pattern-matching-related methods to [GameState].
extension GameStatePatterns on GameState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameState value)  $default,){
final _that = this;
switch (_that) {
case _GameState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameState value)?  $default,){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Player> players,  List<PlayingCard> pool,  List<PlayingCard> discardPile,  Rank? currentClaimedRank,  String? lastPlayerId,  List<PlayingCard> lastPlayedCards,  int passCount,  int activePlayerIndex,  GameStatus status,  AnimationEvent lastEvent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.players,_that.pool,_that.discardPile,_that.currentClaimedRank,_that.lastPlayerId,_that.lastPlayedCards,_that.passCount,_that.activePlayerIndex,_that.status,_that.lastEvent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Player> players,  List<PlayingCard> pool,  List<PlayingCard> discardPile,  Rank? currentClaimedRank,  String? lastPlayerId,  List<PlayingCard> lastPlayedCards,  int passCount,  int activePlayerIndex,  GameStatus status,  AnimationEvent lastEvent)  $default,) {final _that = this;
switch (_that) {
case _GameState():
return $default(_that.players,_that.pool,_that.discardPile,_that.currentClaimedRank,_that.lastPlayerId,_that.lastPlayedCards,_that.passCount,_that.activePlayerIndex,_that.status,_that.lastEvent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Player> players,  List<PlayingCard> pool,  List<PlayingCard> discardPile,  Rank? currentClaimedRank,  String? lastPlayerId,  List<PlayingCard> lastPlayedCards,  int passCount,  int activePlayerIndex,  GameStatus status,  AnimationEvent lastEvent)?  $default,) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.players,_that.pool,_that.discardPile,_that.currentClaimedRank,_that.lastPlayerId,_that.lastPlayedCards,_that.passCount,_that.activePlayerIndex,_that.status,_that.lastEvent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameState extends GameState {
  const _GameState({final  List<Player> players = const [], final  List<PlayingCard> pool = const [], final  List<PlayingCard> discardPile = const [], this.currentClaimedRank, this.lastPlayerId, final  List<PlayingCard> lastPlayedCards = const [], this.passCount = 0, this.activePlayerIndex = 0, this.status = GameStatus.waiting, this.lastEvent = AnimationEvent.none}): _players = players,_pool = pool,_discardPile = discardPile,_lastPlayedCards = lastPlayedCards,super._();
  factory _GameState.fromJson(Map<String, dynamic> json) => _$GameStateFromJson(json);

 final  List<Player> _players;
@override@JsonKey() List<Player> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

 final  List<PlayingCard> _pool;
@override@JsonKey() List<PlayingCard> get pool {
  if (_pool is EqualUnmodifiableListView) return _pool;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pool);
}

 final  List<PlayingCard> _discardPile;
@override@JsonKey() List<PlayingCard> get discardPile {
  if (_discardPile is EqualUnmodifiableListView) return _discardPile;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_discardPile);
}

@override final  Rank? currentClaimedRank;
@override final  String? lastPlayerId;
 final  List<PlayingCard> _lastPlayedCards;
@override@JsonKey() List<PlayingCard> get lastPlayedCards {
  if (_lastPlayedCards is EqualUnmodifiableListView) return _lastPlayedCards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lastPlayedCards);
}

@override@JsonKey() final  int passCount;
@override@JsonKey() final  int activePlayerIndex;
@override@JsonKey() final  GameStatus status;
@override@JsonKey() final  AnimationEvent lastEvent;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStateCopyWith<_GameState> get copyWith => __$GameStateCopyWithImpl<_GameState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameState&&const DeepCollectionEquality().equals(other._players, _players)&&const DeepCollectionEquality().equals(other._pool, _pool)&&const DeepCollectionEquality().equals(other._discardPile, _discardPile)&&(identical(other.currentClaimedRank, currentClaimedRank) || other.currentClaimedRank == currentClaimedRank)&&(identical(other.lastPlayerId, lastPlayerId) || other.lastPlayerId == lastPlayerId)&&const DeepCollectionEquality().equals(other._lastPlayedCards, _lastPlayedCards)&&(identical(other.passCount, passCount) || other.passCount == passCount)&&(identical(other.activePlayerIndex, activePlayerIndex) || other.activePlayerIndex == activePlayerIndex)&&(identical(other.status, status) || other.status == status)&&(identical(other.lastEvent, lastEvent) || other.lastEvent == lastEvent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_players),const DeepCollectionEquality().hash(_pool),const DeepCollectionEquality().hash(_discardPile),currentClaimedRank,lastPlayerId,const DeepCollectionEquality().hash(_lastPlayedCards),passCount,activePlayerIndex,status,lastEvent);

@override
String toString() {
  return 'GameState(players: $players, pool: $pool, discardPile: $discardPile, currentClaimedRank: $currentClaimedRank, lastPlayerId: $lastPlayerId, lastPlayedCards: $lastPlayedCards, passCount: $passCount, activePlayerIndex: $activePlayerIndex, status: $status, lastEvent: $lastEvent)';
}


}

/// @nodoc
abstract mixin class _$GameStateCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$GameStateCopyWith(_GameState value, $Res Function(_GameState) _then) = __$GameStateCopyWithImpl;
@override @useResult
$Res call({
 List<Player> players, List<PlayingCard> pool, List<PlayingCard> discardPile, Rank? currentClaimedRank, String? lastPlayerId, List<PlayingCard> lastPlayedCards, int passCount, int activePlayerIndex, GameStatus status, AnimationEvent lastEvent
});




}
/// @nodoc
class __$GameStateCopyWithImpl<$Res>
    implements _$GameStateCopyWith<$Res> {
  __$GameStateCopyWithImpl(this._self, this._then);

  final _GameState _self;
  final $Res Function(_GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? players = null,Object? pool = null,Object? discardPile = null,Object? currentClaimedRank = freezed,Object? lastPlayerId = freezed,Object? lastPlayedCards = null,Object? passCount = null,Object? activePlayerIndex = null,Object? status = null,Object? lastEvent = null,}) {
  return _then(_GameState(
players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,pool: null == pool ? _self._pool : pool // ignore: cast_nullable_to_non_nullable
as List<PlayingCard>,discardPile: null == discardPile ? _self._discardPile : discardPile // ignore: cast_nullable_to_non_nullable
as List<PlayingCard>,currentClaimedRank: freezed == currentClaimedRank ? _self.currentClaimedRank : currentClaimedRank // ignore: cast_nullable_to_non_nullable
as Rank?,lastPlayerId: freezed == lastPlayerId ? _self.lastPlayerId : lastPlayerId // ignore: cast_nullable_to_non_nullable
as String?,lastPlayedCards: null == lastPlayedCards ? _self._lastPlayedCards : lastPlayedCards // ignore: cast_nullable_to_non_nullable
as List<PlayingCard>,passCount: null == passCount ? _self.passCount : passCount // ignore: cast_nullable_to_non_nullable
as int,activePlayerIndex: null == activePlayerIndex ? _self.activePlayerIndex : activePlayerIndex // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GameStatus,lastEvent: null == lastEvent ? _self.lastEvent : lastEvent // ignore: cast_nullable_to_non_nullable
as AnimationEvent,
  ));
}


}

// dart format on
