// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameStateUpdatedEvent _$GameStateUpdatedEventFromJson(
  Map<String, dynamic> json,
) => GameStateUpdatedEvent(
  gameState: json['gameState'] as Map<String, dynamic>,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$GameStateUpdatedEventToJson(
  GameStateUpdatedEvent instance,
) => <String, dynamic>{
  'gameState': instance.gameState,
  'runtimeType': instance.$type,
};

MatchStartedEvent _$MatchStartedEventFromJson(Map<String, dynamic> json) =>
    MatchStartedEvent(
      matchId: json['matchId'] as String,
      playerIds: (json['playerIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$MatchStartedEventToJson(MatchStartedEvent instance) =>
    <String, dynamic>{
      'matchId': instance.matchId,
      'playerIds': instance.playerIds,
      'runtimeType': instance.$type,
    };

ErrorEvent _$ErrorEventFromJson(Map<String, dynamic> json) => ErrorEvent(
  message: json['message'] as String,
  code: json['code'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$ErrorEventToJson(ErrorEvent instance) =>
    <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
      'runtimeType': instance.$type,
    };
