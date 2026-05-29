import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/card.dart';

part 'game_ui_provider.freezed.dart';
part 'game_ui_provider.g.dart';

@freezed
abstract class GameUIState with _$GameUIState {
  const factory GameUIState({
    @Default([]) List<PlayingCard> selectedCards,
    Rank? selectedRank,
    @Default(false) bool isAnimating, // Blocks interaction during animations
    @Default(false) bool isResolvingChallenge, // Locks UI during challenge sequence
    @Default([]) List<PlayingCard> challengedCards, // Temporary holder for cards being revealed
  }) = _GameUIState;
}

@riverpod
class GameUINotifier extends _$GameUINotifier {
  @override
  GameUIState build() {
    return const GameUIState();
  }

  void startChallengeResolution(List<PlayingCard> cards) {
    state = state.copyWith(isResolvingChallenge: true, challengedCards: cards);
  }

  void endChallengeResolution() {
    state = state.copyWith(isResolvingChallenge: false, challengedCards: []);
  }

  void toggleCardSelection(PlayingCard card) {
    if (state.isAnimating) return;
    
    final currentSelected = List<PlayingCard>.from(state.selectedCards);
    if (currentSelected.contains(card)) {
      currentSelected.remove(card);
    } else {
      if (currentSelected.length < 4) {
        currentSelected.add(card);
      }
    }
    state = state.copyWith(selectedCards: currentSelected);
  }

  void selectRank(Rank rank) {
    state = state.copyWith(selectedRank: rank);
  }

  void setAnimating(bool animating) {
    state = state.copyWith(isAnimating: animating);
  }

  void resetSelection() {
    state = state.copyWith(selectedCards: [], selectedRank: null);
  }
}
