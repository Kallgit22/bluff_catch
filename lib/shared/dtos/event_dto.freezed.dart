// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
EventDTO _$EventDTOFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'gameStateUpdated':
          return GameStateUpdatedEvent.fromJson(
            json
          );
                case 'matchStarted':
          return MatchStartedEvent.fromJson(
            json
          );
                case 'error':
          return ErrorEvent.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'EventDTO',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$EventDTO {



  /// Serializes this EventDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDTO);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EventDTO()';
}


}

/// @nodoc
class $EventDTOCopyWith<$Res>  {
$EventDTOCopyWith(EventDTO _, $Res Function(EventDTO) __);
}


/// Adds pattern-matching-related methods to [EventDTO].
extension EventDTOPatterns on EventDTO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GameStateUpdatedEvent value)?  gameStateUpdated,TResult Function( MatchStartedEvent value)?  matchStarted,TResult Function( ErrorEvent value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GameStateUpdatedEvent() when gameStateUpdated != null:
return gameStateUpdated(_that);case MatchStartedEvent() when matchStarted != null:
return matchStarted(_that);case ErrorEvent() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GameStateUpdatedEvent value)  gameStateUpdated,required TResult Function( MatchStartedEvent value)  matchStarted,required TResult Function( ErrorEvent value)  error,}){
final _that = this;
switch (_that) {
case GameStateUpdatedEvent():
return gameStateUpdated(_that);case MatchStartedEvent():
return matchStarted(_that);case ErrorEvent():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GameStateUpdatedEvent value)?  gameStateUpdated,TResult? Function( MatchStartedEvent value)?  matchStarted,TResult? Function( ErrorEvent value)?  error,}){
final _that = this;
switch (_that) {
case GameStateUpdatedEvent() when gameStateUpdated != null:
return gameStateUpdated(_that);case MatchStartedEvent() when matchStarted != null:
return matchStarted(_that);case ErrorEvent() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Map<String, dynamic> gameState)?  gameStateUpdated,TResult Function( String matchId,  List<String> playerIds)?  matchStarted,TResult Function( String message,  String code)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GameStateUpdatedEvent() when gameStateUpdated != null:
return gameStateUpdated(_that.gameState);case MatchStartedEvent() when matchStarted != null:
return matchStarted(_that.matchId,_that.playerIds);case ErrorEvent() when error != null:
return error(_that.message,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Map<String, dynamic> gameState)  gameStateUpdated,required TResult Function( String matchId,  List<String> playerIds)  matchStarted,required TResult Function( String message,  String code)  error,}) {final _that = this;
switch (_that) {
case GameStateUpdatedEvent():
return gameStateUpdated(_that.gameState);case MatchStartedEvent():
return matchStarted(_that.matchId,_that.playerIds);case ErrorEvent():
return error(_that.message,_that.code);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Map<String, dynamic> gameState)?  gameStateUpdated,TResult? Function( String matchId,  List<String> playerIds)?  matchStarted,TResult? Function( String message,  String code)?  error,}) {final _that = this;
switch (_that) {
case GameStateUpdatedEvent() when gameStateUpdated != null:
return gameStateUpdated(_that.gameState);case MatchStartedEvent() when matchStarted != null:
return matchStarted(_that.matchId,_that.playerIds);case ErrorEvent() when error != null:
return error(_that.message,_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class GameStateUpdatedEvent implements EventDTO {
  const GameStateUpdatedEvent({required final  Map<String, dynamic> gameState, final  String? $type}): _gameState = gameState,$type = $type ?? 'gameStateUpdated';
  factory GameStateUpdatedEvent.fromJson(Map<String, dynamic> json) => _$GameStateUpdatedEventFromJson(json);

 final  Map<String, dynamic> _gameState;
 Map<String, dynamic> get gameState {
  if (_gameState is EqualUnmodifiableMapView) return _gameState;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_gameState);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of EventDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateUpdatedEventCopyWith<GameStateUpdatedEvent> get copyWith => _$GameStateUpdatedEventCopyWithImpl<GameStateUpdatedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameStateUpdatedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameStateUpdatedEvent&&const DeepCollectionEquality().equals(other._gameState, _gameState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_gameState));

@override
String toString() {
  return 'EventDTO.gameStateUpdated(gameState: $gameState)';
}


}

/// @nodoc
abstract mixin class $GameStateUpdatedEventCopyWith<$Res> implements $EventDTOCopyWith<$Res> {
  factory $GameStateUpdatedEventCopyWith(GameStateUpdatedEvent value, $Res Function(GameStateUpdatedEvent) _then) = _$GameStateUpdatedEventCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> gameState
});




}
/// @nodoc
class _$GameStateUpdatedEventCopyWithImpl<$Res>
    implements $GameStateUpdatedEventCopyWith<$Res> {
  _$GameStateUpdatedEventCopyWithImpl(this._self, this._then);

  final GameStateUpdatedEvent _self;
  final $Res Function(GameStateUpdatedEvent) _then;

/// Create a copy of EventDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? gameState = null,}) {
  return _then(GameStateUpdatedEvent(
gameState: null == gameState ? _self._gameState : gameState // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class MatchStartedEvent implements EventDTO {
  const MatchStartedEvent({required this.matchId, required final  List<String> playerIds, final  String? $type}): _playerIds = playerIds,$type = $type ?? 'matchStarted';
  factory MatchStartedEvent.fromJson(Map<String, dynamic> json) => _$MatchStartedEventFromJson(json);

 final  String matchId;
 final  List<String> _playerIds;
 List<String> get playerIds {
  if (_playerIds is EqualUnmodifiableListView) return _playerIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playerIds);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of EventDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchStartedEventCopyWith<MatchStartedEvent> get copyWith => _$MatchStartedEventCopyWithImpl<MatchStartedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchStartedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchStartedEvent&&(identical(other.matchId, matchId) || other.matchId == matchId)&&const DeepCollectionEquality().equals(other._playerIds, _playerIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,matchId,const DeepCollectionEquality().hash(_playerIds));

@override
String toString() {
  return 'EventDTO.matchStarted(matchId: $matchId, playerIds: $playerIds)';
}


}

/// @nodoc
abstract mixin class $MatchStartedEventCopyWith<$Res> implements $EventDTOCopyWith<$Res> {
  factory $MatchStartedEventCopyWith(MatchStartedEvent value, $Res Function(MatchStartedEvent) _then) = _$MatchStartedEventCopyWithImpl;
@useResult
$Res call({
 String matchId, List<String> playerIds
});




}
/// @nodoc
class _$MatchStartedEventCopyWithImpl<$Res>
    implements $MatchStartedEventCopyWith<$Res> {
  _$MatchStartedEventCopyWithImpl(this._self, this._then);

  final MatchStartedEvent _self;
  final $Res Function(MatchStartedEvent) _then;

/// Create a copy of EventDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? matchId = null,Object? playerIds = null,}) {
  return _then(MatchStartedEvent(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,playerIds: null == playerIds ? _self._playerIds : playerIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ErrorEvent implements EventDTO {
  const ErrorEvent({required this.message, required this.code, final  String? $type}): $type = $type ?? 'error';
  factory ErrorEvent.fromJson(Map<String, dynamic> json) => _$ErrorEventFromJson(json);

 final  String message;
 final  String code;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of EventDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorEventCopyWith<ErrorEvent> get copyWith => _$ErrorEventCopyWithImpl<ErrorEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ErrorEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorEvent&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'EventDTO.error(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $ErrorEventCopyWith<$Res> implements $EventDTOCopyWith<$Res> {
  factory $ErrorEventCopyWith(ErrorEvent value, $Res Function(ErrorEvent) _then) = _$ErrorEventCopyWithImpl;
@useResult
$Res call({
 String message, String code
});




}
/// @nodoc
class _$ErrorEventCopyWithImpl<$Res>
    implements $ErrorEventCopyWith<$Res> {
  _$ErrorEventCopyWithImpl(this._self, this._then);

  final ErrorEvent _self;
  final $Res Function(ErrorEvent) _then;

/// Create a copy of EventDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = null,}) {
  return _then(ErrorEvent(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
