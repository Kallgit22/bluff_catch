import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
sealed class UserProfile with _$UserProfile {
  const UserProfile._();

  const factory UserProfile({
    @Default('') String uid,
    @Default('player') String username,
    @Default('New Player') String displayName,
    @Default('avatar_1') String avatar,
    @Default(0) int points,
    @Default(0) int matchesPlayed,
    @Default(0) int wins,
    @Default(0.0) double winRate,
    @Default('Bronze') String rank,
    @Default('classic_casino') String theme,
    @Default(false) bool isPrivate,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime lastLogin,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  factory UserProfile.empty(String uid, {String? email, String? name}) {
    final now = DateTime.now();
    return UserProfile(
      uid: uid,
      username: email?.split('@')[0] ?? 'player_${uid.substring(0, 5)}',
      displayName: name ?? 'New Player',
      createdAt: now,
      lastLogin: now,
    );
  }
}

class TimestampConverter implements JsonConverter<DateTime, Object?> {
  const TimestampConverter();

  @override
  DateTime fromJson(Object? json) {
    if (json == null) return DateTime.now();
    if (json is Timestamp) {
      return json.toDate();
    }
    if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    if (json is String) {
      return DateTime.parse(json);
    }
    return DateTime.now();
  }

  @override
  Object? toJson(DateTime object) {
    return Timestamp.fromDate(object);
  }
}
