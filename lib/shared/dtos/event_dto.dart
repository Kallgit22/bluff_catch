import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_dto.freezed.dart';
part 'event_dto.g.dart';

@freezed
sealed class EventDTO with _$EventDTO {
  const factory EventDTO.gameStateUpdated({
    required Map<String, dynamic> gameState,
  }) = GameStateUpdatedEvent;

  const factory EventDTO.matchStarted({
    required String matchId,
    required List<String> playerIds,
  }) = MatchStartedEvent;

  const factory EventDTO.error({
    required String message,
    required String code,
  }) = ErrorEvent;

  factory EventDTO.fromJson(Map<String, dynamic> json) => _$EventDTOFromJson(json);
}
