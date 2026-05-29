import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/player_count_selector.dart';
import '../providers/setup_provider.dart';
import '../../../game/presentation/providers/game_state_provider.dart';

class SetupPage extends ConsumerWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupState = ref.watch(setupProvider);
    final theme = Theme.of(context);

    // List of predefined harmonious colors for avatars
    final avatarColors = [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.tealAccent,
      Colors.pinkAccent,
      Colors.amberAccent,
      Colors.indigoAccent,
      Colors.lightGreenAccent,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Setup', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Row(
          children: [
            // Left Side: Header & Player Count
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PREPARE YOUR PLAYERS',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select the number of players (2-10). Pass-and-play works best with friends sitting in a circle.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: PlayerCountSelector(
                          count: setupState.playerCount,
                          onIncrement: () => ref.read(setupProvider.notifier).incrementPlayerCount(),
                          onDecrement: () => ref.read(setupProvider.notifier).decrementPlayerCount(),
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (setupState.errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            setupState.errorMessage,
                            style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: setupState.isValid
                              ? () {
                                  final finalNames = setupState.playerNames.map((n) => n.trim()).toList();
                                  ref.read(gameStateProvider.notifier).startGame(finalNames);
                                  context.go('/game');
                                }
                              : null,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'START GAME',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Right Side: Scrollable Name Inputs
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                  border: Border(left: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.1))),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                  itemCount: setupState.playerCount,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return CustomTextField(
                      labelText: 'Player ${index + 1}',
                      initialValue: setupState.playerNames[index],
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: avatarColors[index % avatarColors.length],
                        ),
                      ),
                      onChanged: (value) => ref.read(setupProvider.notifier).updatePlayerName(index, value),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
