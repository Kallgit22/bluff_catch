// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
ActionDTO _$ActionDTOFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'throwCards':
          return ThrowCardsAction.fromJson(
            json
          );
                case 'challenge':
          return ChallengeAction.fromJson(
            json
          );
                case 'pass':
          return PassAction.fromJson(
            json
          );
                case 'leaveMatch':
          return LeaveMatchAction.fromJson(
            json
          );
                case 'startRound':
          return StartRoundAction.fromJson(
            json
          );
                case 'startMatch':
          return StartMatchAction.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'ActionDTO',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$ActionDTO {



  /// Serializes this ActionDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionDTO);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ActionDTO()';
}


}

/// @nodoc
class $ActionDTOCopyWith<$Res>  {
$ActionDTOCopyWith(ActionDTO _, $Res Function(ActionDTO) __);
}


/// Adds pattern-matching-related methods to [ActionDTO].
extension ActionDTOPatterns on ActionDTO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ThrowCardsAction value)?  throwCards,TResult Function( ChallengeAction value)?  challenge,TResult Function( PassAction value)?  pass,TResult Function( LeaveMatchAction value)?  leaveMatch,TResult Function( StartRoundAction value)?  startRound,TResult Function( StartMatchAction value)?  startMatch,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ThrowCardsAction() when throwCards != null:
return throwCards(_that);case ChallengeAction() when challenge != null:
return challenge(_that);case PassAction() when pass != null:
return pass(_that);case LeaveMatchAction() when leaveMatch != null:
return leaveMatch(_that);case StartRoundAction() when startRound != null:
return startRound(_that);case StartMatchAction() when startMatch != null:
return startMatch(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ThrowCardsAction value)  throwCards,required TResult Function( ChallengeAction value)  challenge,required TResult Function( PassAction value)  pass,required TResult Function( LeaveMatchAction value)  leaveMatch,required TResult Function( StartRoundAction value)  startRound,required TResult Function( StartMatchAction value)  startMatch,}){
final _that = this;
switch (_that) {
case ThrowCardsAction():
return throwCards(_that);case ChallengeAction():
return challenge(_that);case PassAction():
return pass(_that);case LeaveMatchAction():
return leaveMatch(_that);case StartRoundAction():
return startRound(_that);case StartMatchAction():
return startMatch(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ThrowCardsAction value)?  throwCards,TResult? Function( ChallengeAction value)?  challenge,TResult? Function( PassAction value)?  pass,TResult? Function( LeaveMatchAction value)?  leaveMatch,TResult? Function( StartRoundAction value)?  startRound,TResult? Function( StartMatchAction value)?  startMatch,}){
final _that = this;
switch (_that) {
case ThrowCardsAction() when throwCards != null:
return throwCards(_that);case ChallengeAction() when challenge != null:
return challenge(_that);case PassAction() when pass != null:
return pass(_that);case LeaveMatchAction() when leaveMatch != null:
return leaveMatch(_that);case StartRoundAction() when startRound != null:
return startRound(_that);case StartMatchAction() when startMatch != null:
return startMatch(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String playerId,  List<CardDTO> cards,  RankDTO claimedRank)?  throwCards,TResult Function( String playerId)?  challenge,TResult Function( String playerId)?  pass,TResult Function( String playerId)?  leaveMatch,TResult Function( String matchId)?  startRound,TResult Function( String matchId,  List<String> playerNames)?  startMatch,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ThrowCardsAction() when throwCards != null:
return throwCards(_that.playerId,_that.cards,_that.claimedRank);case ChallengeAction() when challenge != null:
return challenge(_that.playerId);case PassAction() when pass != null:
return pass(_that.playerId);case LeaveMatchAction() when leaveMatch != null:
return leaveMatch(_that.playerId);case StartRoundAction() when startRound != null:
return startRound(_that.matchId);case StartMatchAction() when startMatch != null:
return startMatch(_that.matchId,_that.playerNames);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String playerId,  List<CardDTO> cards,  RankDTO claimedRank)  throwCards,required TResult Function( String playerId)  challenge,required TResult Function( String playerId)  pass,required TResult Function( String playerId)  leaveMatch,required TResult Function( String matchId)  startRound,required TResult Function( String matchId,  List<String> playerNames)  startMatch,}) {final _that = this;
switch (_that) {
case ThrowCardsAction():
return throwCards(_that.playerId,_that.cards,_that.claimedRank);case ChallengeAction():
return challenge(_that.playerId);case PassAction():
return pass(_that.playerId);case LeaveMatchAction():
return leaveMatch(_that.playerId);case StartRoundAction():
return startRound(_that.matchId);case StartMatchAction():
return startMatch(_that.matchId,_that.playerNames);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String playerId,  List<CardDTO> cards,  RankDTO claimedRank)?  throwCards,TResult? Function( String playerId)?  challenge,TResult? Function( String playerId)?  pass,TResult? Function( String playerId)?  leaveMatch,TResult? Function( String matchId)?  startRound,TResult? Function( String matchId,  List<String> playerNames)?  startMatch,}) {final _that = this;
switch (_that) {
case ThrowCardsAction() when throwCards != null:
return throwCards(_that.playerId,_that.cards,_that.claimedRank);case ChallengeAction() when challenge != null:
return challenge(_that.playerId);case PassAction() when pass != null:
return pass(_that.playerId);case LeaveMatchAction() when leaveMatch != null:
return leaveMatch(_that.playerId);case StartRoundAction() when startRound != null:
return startRound(_that.matchId);case StartMatchAction() when startMatch != null:
return startMatch(_that.matchId,_that.playerNames);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class ThrowCardsAction implements ActionDTO {
  const ThrowCardsAction({required this.playerId, required final  List<CardDTO> cards, required this.claimedRank, final  String? $type}): _cards = cards,$type = $type ?? 'throwCards';
  factory ThrowCardsAction.fromJson(Map<String, dynamic> json) => _$ThrowCardsActionFromJson(json);

 final  String playerId;
 final  List<CardDTO> _cards;
 List<CardDTO> get cards {
  if (_cards is EqualUnmodifiableListView) return _cards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cards);
}

 final  RankDTO claimedRank;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ActionDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThrowCardsActionCopyWith<ThrowCardsAction> get copyWith => _$ThrowCardsActionCopyWithImpl<ThrowCardsAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ThrowCardsActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThrowCardsAction&&(identical(other.playerId, playerId) || other.playerId == playerId)&&const DeepCollectionEquality().equals(other._cards, _cards)&&(identical(other.claimedRank, claimedRank) || other.claimedRank == claimedRank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,const DeepCollectionEquality().hash(_cards),claimedRank);

@override
String toString() {
  return 'ActionDTO.throwCards(playerId: $playerId, cards: $cards, claimedRank: $claimedRank)';
}


}

/// @nodoc
abstract mixin class $ThrowCardsActionCopyWith<$Res> implements $ActionDTOCopyWith<$Res> {
  factory $ThrowCardsActionCopyWith(ThrowCardsAction value, $Res Function(ThrowCardsAction) _then) = _$ThrowCardsActionCopyWithImpl;
@useResult
$Res call({
 String playerId, List<CardDTO> cards, RankDTO claimedRank
});




}
/// @nodoc
class _$ThrowCardsActionCopyWithImpl<$Res>
    implements $ThrowCardsActionCopyWith<$Res> {
  _$ThrowCardsActionCopyWithImpl(this._self, this._then);

  final ThrowCardsAction _self;
  final $Res Function(ThrowCardsAction) _then;

/// Create a copy of ActionDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? cards = null,Object? claimedRank = null,}) {
  return _then(ThrowCardsAction(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,cards: null == cards ? _self._cards : cards // ignore: cast_nullable_to_non_nullable
as List<CardDTO>,claimedRank: null == claimedRank ? _self.claimedRank : claimedRank // ignore: cast_nullable_to_non_nullable
as RankDTO,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ChallengeAction implements ActionDTO {
  const ChallengeAction({required this.playerId, final  String? $type}): $type = $type ?? 'challenge';
  factory ChallengeAction.fromJson(Map<String, dynamic> json) => _$ChallengeActionFromJson(json);

 final  String playerId;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ActionDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengeActionCopyWith<ChallengeAction> get copyWith => _$ChallengeActionCopyWithImpl<ChallengeAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChallengeActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChallengeAction&&(identical(other.playerId, playerId) || other.playerId == playerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId);

@override
String toString() {
  return 'ActionDTO.challenge(playerId: $playerId)';
}


}

/// @nodoc
abstract mixin class $ChallengeActionCopyWith<$Res> implements $ActionDTOCopyWith<$Res> {
  factory $ChallengeActionCopyWith(ChallengeAction value, $Res Function(ChallengeAction) _then) = _$ChallengeActionCopyWithImpl;
@useResult
$Res call({
 String playerId
});




}
/// @nodoc
class _$ChallengeActionCopyWithImpl<$Res>
    implements $ChallengeActionCopyWith<$Res> {
  _$ChallengeActionCopyWithImpl(this._self, this._then);

  final ChallengeAction _self;
  final $Res Function(ChallengeAction) _then;

/// Create a copy of ActionDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,}) {
  return _then(ChallengeAction(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class PassAction implements ActionDTO {
  const PassAction({required this.playerId, final  String? $type}): $type = $type ?? 'pass';
  factory PassAction.fromJson(Map<String, dynamic> json) => _$PassActionFromJson(json);

 final  String playerId;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ActionDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PassActionCopyWith<PassAction> get copyWith => _$PassActionCopyWithImpl<PassAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PassActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PassAction&&(identical(other.playerId, playerId) || other.playerId == playerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId);

@override
String toString() {
  return 'ActionDTO.pass(playerId: $playerId)';
}


}

/// @nodoc
abstract mixin class $PassActionCopyWith<$Res> implements $ActionDTOCopyWith<$Res> {
  factory $PassActionCopyWith(PassAction value, $Res Function(PassAction) _then) = _$PassActionCopyWithImpl;
@useResult
$Res call({
 String playerId
});




}
/// @nodoc
class _$PassActionCopyWithImpl<$Res>
    implements $PassActionCopyWith<$Res> {
  _$PassActionCopyWithImpl(this._self, this._then);

  final PassAction _self;
  final $Res Function(PassAction) _then;

/// Create a copy of ActionDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,}) {
  return _then(PassAction(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class LeaveMatchAction implements ActionDTO {
  const LeaveMatchAction({required this.playerId, final  String? $type}): $type = $type ?? 'leaveMatch';
  factory LeaveMatchAction.fromJson(Map<String, dynamic> json) => _$LeaveMatchActionFromJson(json);

 final  String playerId;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ActionDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveMatchActionCopyWith<LeaveMatchAction> get copyWith => _$LeaveMatchActionCopyWithImpl<LeaveMatchAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveMatchActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveMatchAction&&(identical(other.playerId, playerId) || other.playerId == playerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId);

@override
String toString() {
  return 'ActionDTO.leaveMatch(playerId: $playerId)';
}


}

/// @nodoc
abstract mixin class $LeaveMatchActionCopyWith<$Res> implements $ActionDTOCopyWith<$Res> {
  factory $LeaveMatchActionCopyWith(LeaveMatchAction value, $Res Function(LeaveMatchAction) _then) = _$LeaveMatchActionCopyWithImpl;
@useResult
$Res call({
 String playerId
});




}
/// @nodoc
class _$LeaveMatchActionCopyWithImpl<$Res>
    implements $LeaveMatchActionCopyWith<$Res> {
  _$LeaveMatchActionCopyWithImpl(this._self, this._then);

  final LeaveMatchAction _self;
  final $Res Function(LeaveMatchAction) _then;

/// Create a copy of ActionDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? playerId = null,}) {
  return _then(LeaveMatchAction(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class StartRoundAction implements ActionDTO {
  const StartRoundAction({required this.matchId, final  String? $type}): $type = $type ?? 'startRound';
  factory StartRoundAction.fromJson(Map<String, dynamic> json) => _$StartRoundActionFromJson(json);

 final  String matchId;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ActionDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartRoundActionCopyWith<StartRoundAction> get copyWith => _$StartRoundActionCopyWithImpl<StartRoundAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StartRoundActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartRoundAction&&(identical(other.matchId, matchId) || other.matchId == matchId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,matchId);

@override
String toString() {
  return 'ActionDTO.startRound(matchId: $matchId)';
}


}

/// @nodoc
abstract mixin class $StartRoundActionCopyWith<$Res> implements $ActionDTOCopyWith<$Res> {
  factory $StartRoundActionCopyWith(StartRoundAction value, $Res Function(StartRoundAction) _then) = _$StartRoundActionCopyWithImpl;
@useResult
$Res call({
 String matchId
});




}
/// @nodoc
class _$StartRoundActionCopyWithImpl<$Res>
    implements $StartRoundActionCopyWith<$Res> {
  _$StartRoundActionCopyWithImpl(this._self, this._then);

  final StartRoundAction _self;
  final $Res Function(StartRoundAction) _then;

/// Create a copy of ActionDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? matchId = null,}) {
  return _then(StartRoundAction(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class StartMatchAction implements ActionDTO {
  const StartMatchAction({required this.matchId, required final  List<String> playerNames, final  String? $type}): _playerNames = playerNames,$type = $type ?? 'startMatch';
  factory StartMatchAction.fromJson(Map<String, dynamic> json) => _$StartMatchActionFromJson(json);

 final  String matchId;
 final  List<String> _playerNames;
 List<String> get playerNames {
  if (_playerNames is EqualUnmodifiableListView) return _playerNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playerNames);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of ActionDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartMatchActionCopyWith<StartMatchAction> get copyWith => _$StartMatchActionCopyWithImpl<StartMatchAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StartMatchActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartMatchAction&&(identical(other.matchId, matchId) || other.matchId == matchId)&&const DeepCollectionEquality().equals(other._playerNames, _playerNames));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,matchId,const DeepCollectionEquality().hash(_playerNames));

@override
String toString() {
  return 'ActionDTO.startMatch(matchId: $matchId, playerNames: $playerNames)';
}


}

/// @nodoc
abstract mixin class $StartMatchActionCopyWith<$Res> implements $ActionDTOCopyWith<$Res> {
  factory $StartMatchActionCopyWith(StartMatchAction value, $Res Function(StartMatchAction) _then) = _$StartMatchActionCopyWithImpl;
@useResult
$Res call({
 String matchId, List<String> playerNames
});




}
/// @nodoc
class _$StartMatchActionCopyWithImpl<$Res>
    implements $StartMatchActionCopyWith<$Res> {
  _$StartMatchActionCopyWithImpl(this._self, this._then);

  final StartMatchAction _self;
  final $Res Function(StartMatchAction) _then;

/// Create a copy of ActionDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? matchId = null,Object? playerNames = null,}) {
  return _then(StartMatchAction(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,playerNames: null == playerNames ? _self._playerNames : playerNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
