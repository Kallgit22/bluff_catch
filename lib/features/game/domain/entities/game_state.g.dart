// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameState _$GameStateFromJson(Map<String, dynamic> json) => _GameState(
  players:
      (json['players'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  pool:
      (json['pool'] as List<dynamic>?)
          ?.map((e) => PlayingCard.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  discardPile:
      (json['discardPile'] as List<dynamic>?)
          ?.map((e) => PlayingCard.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  currentClaimedRank: $enumDecodeNullable(
    _$RankEnumMap,
    json['currentClaimedRank'],
  ),
  lastPlayerId: json['lastPlayerId'] as String?,
  lastPlayedCards:
      (json['lastPlayedCards'] as List<dynamic>?)
          ?.map((e) => PlayingCard.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  passCount: (json['passCount'] as num?)?.toInt() ?? 0,
  activePlayerIndex: (json['activePlayerIndex'] as num?)?.toInt() ?? 0,
  status:
      $enumDecodeNullable(_$GameStatusEnumMap, json['status']) ??
      GameStatus.waiting,
  lastEvent:
      $enumDecodeNullable(_$AnimationEventEnumMap, json['lastEvent']) ??
      AnimationEvent.none,
);

Map<String, dynamic> _$GameStateToJson(_GameState instance) =>
    <String, dynamic>{
      'players': instance.players,
      'pool': instance.pool,
      'discardPile': instance.discardPile,
      'currentClaimedRank': _$RankEnumMap[instance.currentClaimedRank],
      'lastPlayerId': instance.lastPlayerId,
      'lastPlayedCards': instance.lastPlayedCards,
      'passCount': instance.passCount,
      'activePlayerIndex': instance.activePlayerIndex,
      'status': _$GameStatusEnumMap[instance.status]!,
      'lastEvent': _$AnimationEventEnumMap[instance.lastEvent]!,
    };

const _$RankEnumMap = {
  Rank.two: 'two',
  Rank.three: 'three',
  Rank.four: 'four',
  Rank.five: 'five',
  Rank.six: 'six',
  Rank.seven: 'seven',
  Rank.eight: 'eight',
  Rank.nine: 'nine',
  Rank.ten: 'ten',
  Rank.jack: 'jack',
  Rank.queen: 'queen',
  Rank.king: 'king',
  Rank.ace: 'ace',
};

const _$GameStatusEnumMap = {
  GameStatus.waiting: 'waiting',
  GameStatus.playing: 'playing',
  GameStatus.finished: 'finished',
};

const _$AnimationEventEnumMap = {
  AnimationEvent.none: 'none',
  AnimationEvent.cardsThrown: 'cardsThrown',
  AnimationEvent.challengeTruth: 'challengeTruth',
  AnimationEvent.challengeLie: 'challengeLie',
  AnimationEvent.roundPassed: 'roundPassed',
  AnimationEvent.gameOver: 'gameOver',
};
