import 'package:freezed_annotation/freezed_annotation.dart';
import 'card.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
abstract class Player with _$Player {
  const Player._();

  const factory Player({
    required String playerId,
    required String playerName,
    required int avatarColor,
    @Default([]) List<PlayingCard> handCards,
    int? rankPosition,
    @Default(false) bool isEliminated,
    @Default(false) bool currentTurn,
    @Default(false) bool hasPassed,
    @Default(false) bool hasPendingVictory,
    
    // Statistics
    @Default(0) int liesCaught,
    @Default(0) int successfulBluffs,
    @Default(0) int challengesWon,
    @Default(0) int cardsConsumed,
  }) = _Player;

  /// Returns the total number of cards currently in the player's hand.
  int get totalCards => handCards.length;

  /// Checks if the player's hand is completely empty.
  bool get hasEmptyHand => handCards.isEmpty;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}
