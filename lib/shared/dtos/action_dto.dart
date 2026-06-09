import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/card_dto.dart';

part 'action_dto.freezed.dart';
part 'action_dto.g.dart';

@freezed
sealed class ActionDTO with _$ActionDTO {
  const factory ActionDTO.throwCards({
    required String playerId,
    required List<CardDTO> cards,
    required RankDTO claimedRank,
  }) = ThrowCardsAction;

  const factory ActionDTO.challenge({
    required String playerId,
  }) = ChallengeAction;

  const factory ActionDTO.pass({
    required String playerId,
  }) = PassAction;

  const factory ActionDTO.leaveMatch({
    required String playerId,
  }) = LeaveMatchAction;

  const factory ActionDTO.startRound({
    required String matchId,
  }) = StartRoundAction;

  const factory ActionDTO.startMatch({
    required String matchId,
    required List<String> playerNames,
  }) = StartMatchAction;

  factory ActionDTO.fromJson(Map<String, dynamic> json) => _$ActionDTOFromJson(json);
}
