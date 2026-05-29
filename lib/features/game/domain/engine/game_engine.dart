import '../entities/card.dart';
import '../entities/player.dart';
import '../entities/game_state.dart';

class GameEngine {
  /// Initializes a new game with the given players.
  static GameState initializeGame(List<Player> players) {
    if (players.isEmpty) return const GameState();
    var newState = GameState(players: players, status: GameStatus.playing, lastEvent: AnimationEvent.none);
    return _assignTurn(newState, 0); // Start with player 0
  }

  /// Called when a player makes a move by placing cards face down
  /// and claiming a specific rank.
  static GameState playCards({
    required GameState state,
    required String playerId,
    required List<PlayingCard> cards,
    required Rank claimedRank,
  }) {
    if (state.status != GameStatus.playing) throw StateError('Game is not active.');
    if (cards.isEmpty || cards.length > 4) throw ArgumentError('Must play 1 to 4 cards.');
    
    final playerIndex = state.players.indexWhere((p) => p.playerId == playerId);
    if (playerIndex == -1) throw ArgumentError('Player not found.');
    if (playerIndex != state.activePlayerIndex) throw StateError('Not your turn.');

    if (state.currentClaimedRank != null && claimedRank != state.currentClaimedRank) {
      throw StateError('Must claim the same rank as the current chain.');
    }

    var player = state.players[playerIndex];
    final newHand = List<PlayingCard>.from(player.handCards);
    for (final card in cards) {
      if (!newHand.remove(card)) {
        throw ArgumentError('Player does not have the played cards.');
      }
    }
    
    player = player.copyWith(handCards: newHand);

    final newPlayers = List<Player>.from(state.players);
    newPlayers[playerIndex] = player;

    final newPool = List<PlayingCard>.from(state.pool)..addAll(cards);
    
    var newState = state.copyWith(
      players: newPlayers,
      pool: newPool,
      currentClaimedRank: claimedRank,
      lastPlayerId: playerId,
      lastPlayedCards: cards,
      passCount: 0,
      lastEvent: AnimationEvent.cardsThrown,
    );
    
    newState = _resetPassStatuses(newState);
    newState = _evaluateRankings(newState);
    newState = _checkGameEnd(newState);

    if (newState.status == GameStatus.finished) return newState;
    return _advanceTurn(newState);
  }

  /// Called when a player passes their turn.
  static GameState passTurn({
    required GameState state,
    required String playerId,
  }) {
    if (state.status != GameStatus.playing) throw StateError('Game is not active.');
    if (state.pool.isEmpty) throw StateError('Cannot pass on the first turn of a round.');
    
    final playerIndex = state.players.indexWhere((p) => p.playerId == playerId);
    if (playerIndex == -1) throw ArgumentError('Player not found.');
    if (playerIndex != state.activePlayerIndex) throw StateError('Not your turn.');

    var newPlayers = List<Player>.from(state.players);
    newPlayers[playerIndex] = newPlayers[playerIndex].copyWith(hasPassed: true);
    
    var newState = state.copyWith(
      players: newPlayers,
      passCount: state.passCount + 1,
      lastEvent: AnimationEvent.none,
    );

    final activePlayersCount = newState.players.where((p) => !p.isEliminated && !p.hasPendingVictory).length;
    
    // Check passCount >= activePlayersCount without -1
    // The player who threw the last cards can still 'Add Cards' or 'Pass'
    int requiredPasses = activePlayersCount;
    
    if (newState.passCount >= requiredPasses) {
      final lastPlayerId = newState.lastPlayerId;
      newState = _endRound(newState, true);
      
      if (lastPlayerId != null) {
        final lastPlayerIndex = newState.players.indexWhere((p) => p.playerId == lastPlayerId);
        if (lastPlayerIndex != -1) {
          newState = _assignTurn(newState, lastPlayerIndex);
          if (newState.players[lastPlayerIndex].isEliminated) {
            newState = _advanceTurn(newState);
          }
        }
      }
      return newState.copyWith(lastEvent: AnimationEvent.roundPassed);
    }

    return _advanceTurn(newState);
  }

  /// Called when a player challenges the previous move.
  static GameState challenge({
    required GameState state,
    required String challengerId,
  }) {
    if (state.status != GameStatus.playing) throw StateError('Game is not active.');
    if (state.lastPlayerId == null || state.lastPlayedCards.isEmpty) {
      throw StateError('No previous play to challenge.');
    }
    
    final challengerIndex = state.players.indexWhere((p) => p.playerId == challengerId);
    if (challengerIndex == -1) throw ArgumentError('Player not found.');
    if (challengerIndex != state.activePlayerIndex) throw StateError('Only the current player can challenge.');

    final claimedRank = state.currentClaimedRank!;
    final wasTruth = state.lastPlayedCards.every((card) => card.rank == claimedRank);
    
    final previousPlayerIndex = state.players.indexWhere((p) => p.playerId == state.lastPlayerId);
    
    final loserIndex = wasTruth ? challengerIndex : previousPlayerIndex;
    final winnerIndex = wasTruth ? previousPlayerIndex : challengerIndex;

    var newPlayers = List<Player>.from(state.players);
    var loser = newPlayers[loserIndex];
    var winner = newPlayers[winnerIndex];
    
    // Update stats
    final poolSize = state.pool.length;
    loser = loser.copyWith(
      handCards: [...loser.handCards, ...state.pool]..sortHand(),
      cardsConsumed: loser.cardsConsumed + poolSize,
    );
    
    if (wasTruth) {
      winner = winner.copyWith(successfulBluffs: winner.successfulBluffs + 1);
    } else {
      winner = winner.copyWith(
        liesCaught: winner.liesCaught + 1,
        challengesWon: winner.challengesWon + 1,
      );
    }

    newPlayers[loserIndex] = loser;
    newPlayers[winnerIndex] = winner;
    
    var newState = state.copyWith(
      players: newPlayers,
      lastEvent: wasTruth ? AnimationEvent.challengeTruth : AnimationEvent.challengeLie,
    );
    newState = _endRound(newState, false);
    
    newState = _evaluateRankings(newState);
    newState = _checkGameEnd(newState);

    if (newState.status == GameStatus.finished) return newState;

    final finalWinnerIndex = newState.players.indexWhere((p) => p.playerId == state.players[winnerIndex].playerId);
    if (finalWinnerIndex != -1) {
      newState = _assignTurn(newState, finalWinnerIndex);
      if (newState.players[finalWinnerIndex].isEliminated) {
         newState = _advanceTurn(newState);
      }
    }

    return newState;
  }

  // --- Helpers ---

  static GameState _advanceTurn(GameState state) {
    if (state.players.isEmpty) return state;
    int nextIndex = (state.activePlayerIndex + 1) % state.players.length;
    
    int loopCount = 0;
    while (state.players[nextIndex].isEliminated || state.players[nextIndex].hasPassed || state.players[nextIndex].hasPendingVictory) {
      nextIndex = (nextIndex + 1) % state.players.length;
      loopCount++;
      if (loopCount > state.players.length) break;
    }
    
    return _assignTurn(state, nextIndex);
  }

  static GameState _assignTurn(GameState state, int index) {
    var newPlayers = List<Player>.from(state.players);
    for (int i = 0; i < newPlayers.length; i++) {
      newPlayers[i] = newPlayers[i].copyWith(currentTurn: i == index);
    }
    return state.copyWith(
      players: newPlayers,
      activePlayerIndex: index,
    );
  }
  
  static GameState _resetPassStatuses(GameState state) {
    var newPlayers = state.players.map((p) => p.copyWith(hasPassed: false)).toList();
    return state.copyWith(players: newPlayers);
  }

  static GameState _endRound(GameState state, bool toDiscard) {
    var newState = state;
    
    if (toDiscard) {
      final newDiscard = List<PlayingCard>.from(state.discardPile)..addAll(state.pool);
      newState = newState.copyWith(discardPile: newDiscard);
    }
    
    newState = _resetPassStatuses(newState);
    
    // Finalize pending victories since pool is safely flushing
    int currentRank = 1;
    for (final p in newState.players) {
       if (p.rankPosition != null && p.rankPosition! >= currentRank) {
          currentRank = p.rankPosition! + 1;
       }
    }
    
    var finalPlayers = newState.players.map((p) {
      if (p.hasPendingVictory && !p.isEliminated && p.hasEmptyHand) {
        return p.copyWith(
          isEliminated: true,
          hasPendingVictory: false,
          rankPosition: currentRank++,
          currentTurn: false,
          hasPassed: false,
        );
      }
      return p;
    }).toList();
    
    return newState.copyWith(
      players: finalPlayers,
      pool: [],
      currentClaimedRank: null,
      lastPlayerId: null,
      lastPlayedCards: [],
      passCount: 0,
    );
  }
  
  static GameState _evaluateRankings(GameState state) {
     int currentRank = 1;
     for (final p in state.players) {
        if (p.rankPosition != null && p.rankPosition! >= currentRank) {
           currentRank = p.rankPosition! + 1;
        }
     }
     
     var newPlayers = state.players.map((p) {
        if (p.hasEmptyHand && !p.isEliminated && !p.hasPendingVictory) {
           return p.copyWith(
             hasPendingVictory: true,
           );
        }
        // If a player got cards back (lost a challenge) after being in pending victory, they rejoin
        if (!p.hasEmptyHand && p.hasPendingVictory) {
           return p.copyWith(
             hasPendingVictory: false,
           );
        }
        return p;
     }).toList();
     
     return state.copyWith(players: newPlayers);
  }

  static GameState _checkGameEnd(GameState state) {
     final activeCount = state.players.where((p) => !p.isEliminated).length;
     if (activeCount <= 1) {
        var newState = _evaluateRankings(state);
        var finalPlayers = newState.players.map((p) {
           if (!p.isEliminated) {
             int maxRank = 0;
             for (final op in newState.players) {
               if (op.rankPosition != null && op.rankPosition! > maxRank) maxRank = op.rankPosition!;
             }
             return p.copyWith(isEliminated: true, rankPosition: maxRank + 1, currentTurn: false);
           }
           return p;
        }).toList();
        
        return newState.copyWith(players: finalPlayers, status: GameStatus.finished, activePlayerIndex: -1, lastEvent: AnimationEvent.gameOver);
     }
     return state;
  }

  /// Called when a player exits the game
  static GameState forfeitPlayer({
    required GameState state,
    required String playerId,
  }) {
    if (state.status != GameStatus.playing) return state;

    final playerIndex = state.players.indexWhere((p) => p.playerId == playerId);
    if (playerIndex == -1) return state;
    if (state.players[playerIndex].isEliminated) return state;

    var newPlayers = List<Player>.from(state.players);

    // Calculate maximum rank currently assigned + active players left
    int maxRank = 0;
    int uneliminatedCount = 0;
    for (final p in state.players) {
      if (p.rankPosition != null && p.rankPosition! > maxRank) maxRank = p.rankPosition!;
      if (!p.isEliminated && !p.hasPendingVictory) uneliminatedCount++;
    }

    // Force eliminate with highest rank
    var player = newPlayers[playerIndex].copyWith(
      isEliminated: true,
      handCards: [],
      hasPendingVictory: false,
      rankPosition: maxRank + uneliminatedCount,
      currentTurn: false,
      hasPassed: false,
    );
    newPlayers[playerIndex] = player;

    var newState = state.copyWith(players: newPlayers);

    // Prevent unfair challenge if they threw the last cards
    if (newState.lastPlayerId == playerId) {
      newState = newState.copyWith(
        lastPlayerId: null,
        pool: [],
        discardPile: [...state.discardPile, ...state.pool],
        lastPlayedCards: [],
        currentClaimedRank: null,
        passCount: 0,
      );
      newState = _resetPassStatuses(newState);
    }

    if (state.activePlayerIndex == playerIndex) {
      newState = _advanceTurn(newState);
    }

    return _checkGameEnd(newState);
  }
}
