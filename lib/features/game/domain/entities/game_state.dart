import 'package:freezed_annotation/freezed_annotation.dart';
import 'player.dart';
import 'card.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

enum GameStatus { waiting, playing, finished }

enum AnimationEvent {
  none,
  cardsThrown,
  challengeTruth,
  challengeLie,
  roundPassed,
  gameOver,
}

@freezed
abstract class GameState with _$GameState {
  const GameState._();

  const factory GameState({
    @Default([]) List<Player> players,
    @Default([]) List<PlayingCard> pool,
    @Default([]) List<PlayingCard> discardPile,
    Rank? currentClaimedRank,
    String? lastPlayerId,
    @Default([]) List<PlayingCard> lastPlayedCards,
    @Default(0) int passCount,
    @Default(0) int activePlayerIndex,
    @Default(GameStatus.waiting) GameStatus status,
    @Default(AnimationEvent.none) AnimationEvent lastEvent,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) => _$GameStateFromJson(json);
}
