import 'package:cloud_firestore/cloud_firestore.dart';
import 'room_player.dart';

class Room {
  final String roomId;
  final String status;
  final String hostUid;
  final int maxPlayers;
  final List<RoomPlayer> players;
  final DateTime createdAt;

  const Room({
    required this.roomId,
    required this.status,
    required this.hostUid,
    required this.maxPlayers,
    required this.players,
    required this.createdAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    final playersList = json['players'] as List<dynamic>? ?? [];
    
    return Room(
      roomId: json['roomId'] as String? ?? '',
      status: json['status'] as String? ?? 'waiting',
      hostUid: json['hostUid'] as String? ?? '',
      maxPlayers: json['maxPlayers'] as int? ?? 10,
      players: playersList
          .map((p) => RoomPlayer.fromJson(Map<String, dynamic>.from(p as Map)))
          .toList(),
      createdAt: _parseTimestamp(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'status': status,
      'hostUid': hostUid,
      'maxPlayers': maxPlayers,
      'players': players.map((p) => p.toJson()).toList(),
      'createdAt': createdAt,
    };
  }

  static DateTime _parseTimestamp(dynamic val) {
    if (val is Timestamp) {
      return val.toDate();
    }
    return DateTime.now();
  }
}
