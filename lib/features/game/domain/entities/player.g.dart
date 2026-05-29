// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Player _$PlayerFromJson(Map<String, dynamic> json) => _Player(
  playerId: json['playerId'] as String,
  playerName: json['playerName'] as String,
  avatarColor: (json['avatarColor'] as num).toInt(),
  handCards:
      (json['handCards'] as List<dynamic>?)
          ?.map((e) => PlayingCard.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  rankPosition: (json['rankPosition'] as num?)?.toInt(),
  isEliminated: json['isEliminated'] as bool? ?? false,
  currentTurn: json['currentTurn'] as bool? ?? false,
  hasPassed: json['hasPassed'] as bool? ?? false,
  hasPendingVictory: json['hasPendingVictory'] as bool? ?? false,
  liesCaught: (json['liesCaught'] as num?)?.toInt() ?? 0,
  successfulBluffs: (json['successfulBluffs'] as num?)?.toInt() ?? 0,
  challengesWon: (json['challengesWon'] as num?)?.toInt() ?? 0,
  cardsConsumed: (json['cardsConsumed'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PlayerToJson(_Player instance) => <String, dynamic>{
  'playerId': instance.playerId,
  'playerName': instance.playerName,
  'avatarColor': instance.avatarColor,
  'handCards': instance.handCards,
  'rankPosition': instance.rankPosition,
  'isEliminated': instance.isEliminated,
  'currentTurn': instance.currentTurn,
  'hasPassed': instance.hasPassed,
  'hasPendingVictory': instance.hasPendingVictory,
  'liesCaught': instance.liesCaught,
  'successfulBluffs': instance.successfulBluffs,
  'challengesWon': instance.challengesWon,
  'cardsConsumed': instance.cardsConsumed,
};
