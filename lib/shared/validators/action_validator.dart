import '../dtos/action_dto.dart';

class ActionValidator {
  static String? validate(ActionDTO action) {
    return action.map(
      throwCards: (a) {
        if (a.playerId.isEmpty) return 'Player ID cannot be empty.';
        if (a.cards.isEmpty) return 'Must throw at least 1 card.';
        if (a.cards.length > 4) return 'Cannot throw more than 4 cards.';
        return null;
      },
      challenge: (a) {
        if (a.playerId.isEmpty) return 'Player ID cannot be empty.';
        return null;
      },
      pass: (a) {
        if (a.playerId.isEmpty) return 'Player ID cannot be empty.';
        return null;
      },
      leaveMatch: (a) {
        if (a.playerId.isEmpty) return 'Player ID cannot be empty.';
        return null;
      },
      startRound: (a) {
        if (a.matchId.isEmpty) return 'Match ID cannot be empty.';
        return null;
      },
      startMatch: (a) {
        if (a.matchId.isEmpty) return 'Match ID cannot be empty.';
        if (a.playerNames.length < 2) return 'Need at least 2 players to start a match.';
        if (a.playerNames.length > 10) return 'Cannot have more than 10 players.';
        return null;
      },
    );
  }
}
