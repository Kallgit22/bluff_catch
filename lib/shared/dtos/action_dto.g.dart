// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThrowCardsAction _$ThrowCardsActionFromJson(Map<String, dynamic> json) =>
    ThrowCardsAction(
      playerId: json['playerId'] as String,
      cards: (json['cards'] as List<dynamic>)
          .map((e) => CardDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
      claimedRank: $enumDecode(_$RankDTOEnumMap, json['claimedRank']),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ThrowCardsActionToJson(ThrowCardsAction instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'cards': instance.cards,
      'claimedRank': _$RankDTOEnumMap[instance.claimedRank]!,
      'runtimeType': instance.$type,
    };

const _$RankDTOEnumMap = {
  RankDTO.two: 'two',
  RankDTO.three: 'three',
  RankDTO.four: 'four',
  RankDTO.five: 'five',
  RankDTO.six: 'six',
  RankDTO.seven: 'seven',
  RankDTO.eight: 'eight',
  RankDTO.nine: 'nine',
  RankDTO.ten: 'ten',
  RankDTO.jack: 'jack',
  RankDTO.queen: 'queen',
  RankDTO.king: 'king',
  RankDTO.ace: 'ace',
};

ChallengeAction _$ChallengeActionFromJson(Map<String, dynamic> json) =>
    ChallengeAction(
      playerId: json['playerId'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ChallengeActionToJson(ChallengeAction instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'runtimeType': instance.$type,
    };

PassAction _$PassActionFromJson(Map<String, dynamic> json) => PassAction(
  playerId: json['playerId'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$PassActionToJson(PassAction instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'runtimeType': instance.$type,
    };

LeaveMatchAction _$LeaveMatchActionFromJson(Map<String, dynamic> json) =>
    LeaveMatchAction(
      playerId: json['playerId'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$LeaveMatchActionToJson(LeaveMatchAction instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'runtimeType': instance.$type,
    };

StartRoundAction _$StartRoundActionFromJson(Map<String, dynamic> json) =>
    StartRoundAction(
      matchId: json['matchId'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$StartRoundActionToJson(StartRoundAction instance) =>
    <String, dynamic>{
      'matchId': instance.matchId,
      'runtimeType': instance.$type,
    };

StartMatchAction _$StartMatchActionFromJson(Map<String, dynamic> json) =>
    StartMatchAction(
      matchId: json['matchId'] as String,
      playerNames: (json['playerNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$StartMatchActionToJson(StartMatchAction instance) =>
    <String, dynamic>{
      'matchId': instance.matchId,
      'playerNames': instance.playerNames,
      'runtimeType': instance.$type,
    };
