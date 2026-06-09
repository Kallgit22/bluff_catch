import 'package:cloud_firestore/cloud_firestore.dart';

class RoomPlayer {
  final String uid;
  final String displayName;
  final String avatarUrl;
  final int points;
  final bool isHost;
  final bool isReady;
  final DateTime joinedAt;
  final DateTime lastSeen;
  final bool isOnline;

  const RoomPlayer({
    required this.uid,
    required this.displayName,
    required this.avatarUrl,
    required this.points,
    required this.isHost,
    required this.isReady,
    required this.joinedAt,
    required this.lastSeen,
    required this.isOnline,
  });

  factory RoomPlayer.fromJson(Map<String, dynamic> json) {
    return RoomPlayer(
      uid: json['uid'] as String? ?? '',
      displayName: json['displayName'] as String? ?? 'Unknown',
      avatarUrl: json['avatarUrl'] as String? ?? 'avatar_1',
      points: json['points'] as int? ?? 0,
      isHost: json['isHost'] as bool? ?? false,
      isReady: json['isReady'] as bool? ?? false,
      joinedAt: _parseTimestamp(json['joinedAt']),
      lastSeen: _parseTimestamp(json['lastSeen']),
      isOnline: json['isOnline'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'points': points,
      'isHost': isHost,
      'isReady': isReady,
      'joinedAt': joinedAt,
      'lastSeen': lastSeen,
      'isOnline': isOnline,
    };
  }

  static DateTime _parseTimestamp(dynamic val) {
    if (val is Timestamp) {
      return val.toDate();
    }
    return DateTime.now();
  }
}
