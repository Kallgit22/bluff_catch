// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get uid; String get username; String get displayName; String get avatar; int get points; int get matchesPlayed; int get wins; double get winRate; String get rank; String get theme; bool get isPrivate;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get lastLogin;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.points, points) || other.points == points)&&(identical(other.matchesPlayed, matchesPlayed) || other.matchesPlayed == matchesPlayed)&&(identical(other.wins, wins) || other.wins == wins)&&(identical(other.winRate, winRate) || other.winRate == winRate)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastLogin, lastLogin) || other.lastLogin == lastLogin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,username,displayName,avatar,points,matchesPlayed,wins,winRate,rank,theme,isPrivate,createdAt,lastLogin);

@override
String toString() {
  return 'UserProfile(uid: $uid, username: $username, displayName: $displayName, avatar: $avatar, points: $points, matchesPlayed: $matchesPlayed, wins: $wins, winRate: $winRate, rank: $rank, theme: $theme, isPrivate: $isPrivate, createdAt: $createdAt, lastLogin: $lastLogin)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String uid, String username, String displayName, String avatar, int points, int matchesPlayed, int wins, double winRate, String rank, String theme, bool isPrivate,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime lastLogin
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? username = null,Object? displayName = null,Object? avatar = null,Object? points = null,Object? matchesPlayed = null,Object? wins = null,Object? winRate = null,Object? rank = null,Object? theme = null,Object? isPrivate = null,Object? createdAt = null,Object? lastLogin = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,matchesPlayed: null == matchesPlayed ? _self.matchesPlayed : matchesPlayed // ignore: cast_nullable_to_non_nullable
as int,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as int,winRate: null == winRate ? _self.winRate : winRate // ignore: cast_nullable_to_non_nullable
as double,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastLogin: null == lastLogin ? _self.lastLogin : lastLogin // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String username,  String displayName,  String avatar,  int points,  int matchesPlayed,  int wins,  double winRate,  String rank,  String theme,  bool isPrivate, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime lastLogin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.uid,_that.username,_that.displayName,_that.avatar,_that.points,_that.matchesPlayed,_that.wins,_that.winRate,_that.rank,_that.theme,_that.isPrivate,_that.createdAt,_that.lastLogin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String username,  String displayName,  String avatar,  int points,  int matchesPlayed,  int wins,  double winRate,  String rank,  String theme,  bool isPrivate, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime lastLogin)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.uid,_that.username,_that.displayName,_that.avatar,_that.points,_that.matchesPlayed,_that.wins,_that.winRate,_that.rank,_that.theme,_that.isPrivate,_that.createdAt,_that.lastLogin);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String username,  String displayName,  String avatar,  int points,  int matchesPlayed,  int wins,  double winRate,  String rank,  String theme,  bool isPrivate, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime lastLogin)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.uid,_that.username,_that.displayName,_that.avatar,_that.points,_that.matchesPlayed,_that.wins,_that.winRate,_that.rank,_that.theme,_that.isPrivate,_that.createdAt,_that.lastLogin);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile extends UserProfile {
  const _UserProfile({this.uid = '', this.username = 'player', this.displayName = 'New Player', this.avatar = 'avatar_1', this.points = 0, this.matchesPlayed = 0, this.wins = 0, this.winRate = 0.0, this.rank = 'Bronze', this.theme = 'classic_casino', this.isPrivate = false, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.lastLogin}): super._();
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override@JsonKey() final  String uid;
@override@JsonKey() final  String username;
@override@JsonKey() final  String displayName;
@override@JsonKey() final  String avatar;
@override@JsonKey() final  int points;
@override@JsonKey() final  int matchesPlayed;
@override@JsonKey() final  int wins;
@override@JsonKey() final  double winRate;
@override@JsonKey() final  String rank;
@override@JsonKey() final  String theme;
@override@JsonKey() final  bool isPrivate;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime lastLogin;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.points, points) || other.points == points)&&(identical(other.matchesPlayed, matchesPlayed) || other.matchesPlayed == matchesPlayed)&&(identical(other.wins, wins) || other.wins == wins)&&(identical(other.winRate, winRate) || other.winRate == winRate)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.isPrivate, isPrivate) || other.isPrivate == isPrivate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastLogin, lastLogin) || other.lastLogin == lastLogin));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,username,displayName,avatar,points,matchesPlayed,wins,winRate,rank,theme,isPrivate,createdAt,lastLogin);

@override
String toString() {
  return 'UserProfile(uid: $uid, username: $username, displayName: $displayName, avatar: $avatar, points: $points, matchesPlayed: $matchesPlayed, wins: $wins, winRate: $winRate, rank: $rank, theme: $theme, isPrivate: $isPrivate, createdAt: $createdAt, lastLogin: $lastLogin)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String uid, String username, String displayName, String avatar, int points, int matchesPlayed, int wins, double winRate, String rank, String theme, bool isPrivate,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime lastLogin
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? username = null,Object? displayName = null,Object? avatar = null,Object? points = null,Object? matchesPlayed = null,Object? wins = null,Object? winRate = null,Object? rank = null,Object? theme = null,Object? isPrivate = null,Object? createdAt = null,Object? lastLogin = null,}) {
  return _then(_UserProfile(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatar: null == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,matchesPlayed: null == matchesPlayed ? _self.matchesPlayed : matchesPlayed // ignore: cast_nullable_to_non_nullable
as int,wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as int,winRate: null == winRate ? _self.winRate : winRate // ignore: cast_nullable_to_non_nullable
as double,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as String,theme: null == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as String,isPrivate: null == isPrivate ? _self.isPrivate : isPrivate // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastLogin: null == lastLogin ? _self.lastLogin : lastLogin // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
