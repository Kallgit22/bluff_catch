import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'setup_provider.freezed.dart';
part 'setup_provider.g.dart';

@freezed
abstract class SetupState with _$SetupState {
  const factory SetupState({
    @Default(2) int playerCount,
    @Default(['Player 1', 'Player 2']) List<String> playerNames,
    @Default(true) bool isValid,
    @Default('') String errorMessage,
  }) = _SetupState;
}

@riverpod
class SetupNotifier extends _$SetupNotifier {
  @override
  SetupState build() {
    return const SetupState();
  }

  void incrementPlayerCount() {
    if (state.playerCount < 10) {
      final newCount = state.playerCount + 1;
      final newNames = List<String>.from(state.playerNames)..add('Player $newCount');
      state = state.copyWith(
        playerCount: newCount,
        playerNames: newNames,
      );
      _validate();
    }
  }

  void decrementPlayerCount() {
    if (state.playerCount > 2) {
      final newCount = state.playerCount - 1;
      final newNames = List<String>.from(state.playerNames)..removeLast();
      state = state.copyWith(
        playerCount: newCount,
        playerNames: newNames,
      );
      _validate();
    }
  }

  void updatePlayerName(int index, String name) {
    if (index >= 0 && index < state.playerNames.length) {
      final newNames = List<String>.from(state.playerNames);
      newNames[index] = name;
      state = state.copyWith(playerNames: newNames);
      _validate();
    }
  }

  void _validate() {
    bool isValid = true;
    String errorMessage = '';

    // Check for empty names
    if (state.playerNames.any((name) => name.trim().isEmpty)) {
      isValid = false;
      errorMessage = 'All players must have a name.';
    } 
    // Check for unique names
    else {
      final uniqueNames = state.playerNames.map((n) => n.trim().toLowerCase()).toSet();
      if (uniqueNames.length != state.playerNames.length) {
        isValid = false;
        errorMessage = 'Player names must be unique.';
      }
    }

    state = state.copyWith(
      isValid: isValid,
      errorMessage: errorMessage,
    );
  }
}
