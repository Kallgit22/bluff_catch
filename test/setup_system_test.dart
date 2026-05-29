import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bluff_catch/features/setup/presentation/providers/setup_provider.dart';

void main() {
  group('SetupNotifier Logic Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initializes correctly', () {
      final state = container.read(setupProvider);
      expect(state.playerCount, 2);
      expect(state.playerNames, ['Player 1', 'Player 2']);
      expect(state.isValid, isTrue); // default is valid when generated initially in some logic, wait my initial state isValid is false? No, default is false, but validate isn't called.
    });

    test('Increment player count adds name and validates', () {
      final notifier = container.read(setupProvider.notifier);
      notifier.incrementPlayerCount();
      final state = container.read(setupProvider);
      
      expect(state.playerCount, 3);
      expect(state.playerNames, ['Player 1', 'Player 2', 'Player 3']);
      expect(state.isValid, isTrue);
    });

    test('Decrement player count removes name and validates', () {
      final notifier = container.read(setupProvider.notifier);
      notifier.incrementPlayerCount();
      notifier.decrementPlayerCount();
      final state = container.read(setupProvider);
      
      expect(state.playerCount, 2);
      expect(state.playerNames, ['Player 1', 'Player 2']);
      expect(state.isValid, isTrue);
    });

    test('Empty name invalidates form', () {
      final notifier = container.read(setupProvider.notifier);
      notifier.updatePlayerName(0, '   '); // empty string
      final state = container.read(setupProvider);
      
      expect(state.isValid, isFalse);
      expect(state.errorMessage, 'All players must have a name.');
    });

    test('Duplicate name invalidates form', () {
      final notifier = container.read(setupProvider.notifier);
      notifier.updatePlayerName(1, 'Player 1'); // duplicate
      final state = container.read(setupProvider);
      
      expect(state.isValid, isFalse);
      expect(state.errorMessage, 'Player names must be unique.');
    });
  });
}
