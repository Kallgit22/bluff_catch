// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  uid: json['uid'] as String? ?? '',
  username: json['username'] as String? ?? 'player',
  displayName: json['displayName'] as String? ?? 'New Player',
  avatar: json['avatar'] as String? ?? 'avatar_1',
  points: (json['points'] as num?)?.toInt() ?? 0,
  matchesPlayed: (json['matchesPlayed'] as num?)?.toInt() ?? 0,
  wins: (json['wins'] as num?)?.toInt() ?? 0,
  winRate: (json['winRate'] as num?)?.toDouble() ?? 0.0,
  rank: json['rank'] as String? ?? 'Bronze',
  theme: json['theme'] as String? ?? 'classic_casino',
  isPrivate: json['isPrivate'] as bool? ?? false,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  lastLogin: const TimestampConverter().fromJson(json['lastLogin']),
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'username': instance.username,
      'displayName': instance.displayName,
      'avatar': instance.avatar,
      'points': instance.points,
      'matchesPlayed': instance.matchesPlayed,
      'wins': instance.wins,
      'winRate': instance.winRate,
      'rank': instance.rank,
      'theme': instance.theme,
      'isPrivate': instance.isPrivate,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'lastLogin': const TimestampConverter().toJson(instance.lastLogin),
    };
