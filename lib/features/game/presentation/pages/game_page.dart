import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/game_state_provider.dart';
import '../providers/game_ui_provider.dart';
import '../widgets/playing_card_widget.dart';
import '../widgets/player_status_avatar.dart';
import '../widgets/rank_selector_bottom_sheet.dart';
import '../widgets/round_start_dialog.dart';
import '../widgets/challenge_result_dialog.dart';
import '../widgets/victory_screen_widget.dart';
import '../widgets/exit_confirmation_dialog.dart';
import '../../../../core/services/audio_service.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/entities/card.dart';
import '../../domain/entities/player.dart';
import '../../../../core/theme/app_themes.dart';
import '../../../../core/providers/settings_provider.dart';

class GamePage extends ConsumerStatefulWidget {
  const GamePage({super.key});

  @override
  ConsumerState<GamePage> createState() => _GamePageState();
}

class _GamePageState extends ConsumerState<GamePage> {
  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final uiState = ref.watch(gameUIProvider);
    final settings = ref.watch(settingsProvider);
    final themeConfig = AppThemes.getThemeById(settings.themeId);

    if (gameState.players.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.amber)));
    }

    ref.listen(gameStateProvider, (previous, next) {
      if (next.lastEvent != AnimationEvent.none &&
          (previous?.lastEvent != next.lastEvent ||
              previous?.passCount != next.passCount)) {
        _handleAnimationEvent(context, ref, next.lastEvent);
        if (previous?.activePlayerIndex != next.activePlayerIndex) {
          ref.read(gameUIProvider.notifier).resetSelection();
        }
      }
    });

    final activePlayer =
        gameState.players.isNotEmpty && gameState.activePlayerIndex >= 0
        ? gameState.players[gameState.activePlayerIndex]
        : null;

    if (gameState.status == GameStatus.finished) {
      return Scaffold(
        body: SafeArea(child: VictoryScreenWidget(gameState: gameState)),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: themeConfig.backgroundGradient),
        child: SafeArea(
          child: Stack(
            children: [
              // ZONE 1 - Center Table Area
              Align(
                alignment: Alignment.center,
                child: _buildCenterTableArea(context, gameState),
              ),

              // ZONE 4 - Left Leaderboard Panel
              Positioned(
                left: 16,
                top: 80,
                bottom: 80,
                child: _buildLeaderboardPanel(context, gameState),
              ),

              // ZONE 5 - Right Action Panel
              if (activePlayer != null)
                Positioned(
                  right: 16,
                  top: 80,
                  bottom: 0,
                  child: _buildRightPanel(
                    context,
                    ref,
                    gameState,
                    uiState,
                    activePlayer,
                  ),
                ),

              // ZONE 6 - Top Opponents Row
              Positioned(
                top: 0,
                left: 180,
                right: 150,
                child: _buildOpponentsRow(context, gameState),
              ),

              // ZONE 2 - Top Left Profile
              if (activePlayer != null)
                Positioned(
                  top: 0,
                  left: 16,
                  child: _buildMyProfile(context, activePlayer),
                ),

              // ZONE 3 - Top Right Exit Button
              if (activePlayer != null)
                Positioned(
                  top: 0,
                  right: 16,
                  child: _buildExitButton(context, activePlayer),
                ),

              // ZONE 7 - Bottom Player Hand
              if (activePlayer != null)
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildActivePlayerHand(
                      context,
                      ref,
                      gameState,
                      uiState,
                      activePlayer,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAnimationEvent(
    BuildContext context,
    WidgetRef ref,
    AnimationEvent event,
  ) {
    if (!context.mounted) return;

    // Check if we need to show the new round dialog
    if (event == AnimationEvent.roundPassed ||
        event == AnimationEvent.challengeLie ||
        event == AnimationEvent.challengeTruth) {
      final gameState = ref.read(gameStateProvider);
      if (gameState.status == GameStatus.playing &&
          gameState.activePlayerIndex >= 0) {
        final activePlayer = gameState.players[gameState.activePlayerIndex];
        RoundStartDialog.show(
          context,
          playerName: activePlayer.playerName,
          avatarColorIndex: activePlayer.avatarColor,
        );
      }
      return;
    }

    String message = '';
    switch (event) {
      case AnimationEvent.gameOver:
        message = 'Game Over!';
        break;
      default:
        break;
    }

    if (message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildExitButton(BuildContext context, Player player) {
    return IconButton(
      icon: const Icon(Icons.exit_to_app, color: Colors.white70),
      onPressed: () => _showExitConfirmation(context, player.playerName),
      tooltip: 'Exit Game',
    );
  }

  void _showExitConfirmation(BuildContext context, String playerName) {
    ExitConfirmationDialog.show(
      context,
      playerName: playerName,
      onConfirm: () {
        final activePlayer = ref
            .read(gameStateProvider)
            .players
            .firstWhere((p) => p.currentTurn);
        ref.read(gameStateProvider.notifier).exitGame(activePlayer.playerId);
      },
    );
  }

  Widget _buildMyProfile(BuildContext context, Player player) {
    final theme = Theme.of(context);
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
    final color = avatarColors[player.avatarColor % avatarColors.length];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color,
            child: Text(
              player.playerName.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                player.playerName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                ' Cards',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOpponentsRow(BuildContext context, GameState gameState) {
    if (gameState.players.length <= 1) return const SizedBox.shrink();

    final activeIdx = gameState.activePlayerIndex;
    final N = gameState.players.length;
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

    List<Widget> opponents = [];
    for (int i = 1; i < N; i++) {
      int idx = (activeIdx + i) % N;
      final player = gameState.players[idx];

      opponents.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Opacity(
            opacity:
                (player.hasPassed ||
                    player.hasPendingVictory ||
                    player.isEliminated)
                ? 0.5
                : 1.0,
            child: PlayerStatusAvatar(
              player: player,
              isActive: false,
              avatarColor: avatarColors[idx % avatarColors.length],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: opponents,
      ),
    );
  }

  Widget _buildLeaderboardPanel(BuildContext context, GameState gameState) {
    final sortedPlayers = List<Player>.from(gameState.players)
      ..sort((a, b) => (a.rankPosition ?? 99).compareTo(b.rankPosition ?? 99));

    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'LEADERBOARD',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: sortedPlayers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final p = sortedPlayers[index];
                return Row(
                  children: [
                    Text(
                      p.rankPosition != null ? '#' : '-',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        p.playerName,
                        style: TextStyle(
                          color: p.isEliminated ? Colors.grey : Colors.white,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterTableArea(BuildContext context, GameState gameState) {
    final theme = Theme.of(context);
    final poolSize = gameState.pool.length;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/game_table.png'),
          fit: BoxFit.contain,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: Stack(
                key: ValueKey<int>(poolSize > 0 ? 1 : 0),
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  if (poolSize > 0)
                    for (int i = 0; i < (poolSize > 8 ? 8 : poolSize); i++)
                      Positioned(
                        left: (i * 2.0),
                        top: (i * 1.5),
                        child: Transform.rotate(
                          angle: (i % 2 == 0 ? 0.05 : -0.05),
                          child: const PlayingCardWidget(
                            isHidden: true,
                            width: 70,
                            height: 105,
                          ),
                        ),
                      ),
                  if (poolSize == 0)
                    Container(
                      width: 90,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'EMPTY\nTABLE',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 100, height: 130),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (poolSize > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  ' CARDS',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPanel(
    BuildContext context,
    WidgetRef ref,
    GameState gameState,
    GameUIState uiState,
    Player player,
  ) {
    final claim = gameState.currentClaimedRank;
    final bool isPoolEmpty = gameState.pool.isEmpty;
    final bool hasSelected = uiState.selectedCards.isNotEmpty;
    final bool canChallenge =
        !isPoolEmpty &&
        (gameState.lastPlayerId != null &&
            gameState.lastPlayerId != player.playerId);

    return SizedBox(
      width: 160,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (claim != null) ...[
              const Center(
                child: Text(
                  'ACTIVE CHAIN',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.2),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    claim.label,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            if (!isPoolEmpty) ...[
              FilledButton.icon(
                onPressed: () {
                  try {
                    ref
                        .read(gameStateProvider.notifier)
                        .passTurn(player.playerId);
                    ref.read(gameUIProvider.notifier).resetSelection();
                  } catch (e) {
                    _showErrorSnackBar(context, e.toString());
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.skip_next, size: 20),
                label: const Text(
                  'Pass',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
            ],
            FilledButton.icon(
              onPressed: hasSelected
                  ? () =>
                        _handlePlayTap(context, ref, gameState, uiState, player)
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: hasSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.withValues(alpha: 0.3),
                foregroundColor: hasSelected ? Colors.white : Colors.white54,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.play_arrow, size: 20),
              label: Text(
                isPoolEmpty ? 'Throw Cards' : 'Add Cards',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (canChallenge) ...[
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => _handleChallengeTap(
                  context,
                  ref,
                  gameState,
                  uiState,
                  player,
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.gavel, size: 20),
                label: const Text(
                  'Challenge',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActivePlayerHand(
    BuildContext context,
    WidgetRef ref,
    GameState gameState,
    GameUIState uiState,
    Player player,
  ) {
    final int cardCount = player.handCards.length;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double handAreaHeight = math.max(
      100.0,
      math.min(150.0, screenHeight * 0.30),
    );
    final double cardHeight = handAreaHeight * 0.75;
    final double cardWidth = cardHeight * 0.66;
    final double stride = cardWidth * 0.5;

    final double totalWidth = cardCount > 0
        ? cardWidth + (cardCount - 1) * stride
        : 0;

    return SizedBox(
      height: handAreaHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: math.max(
            MediaQuery.of(context).size.width * 0.5,
            totalWidth + 32,
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: List.generate(cardCount, (index) {
              final card = player.handCards[index];
              final isSelected = uiState.selectedCards.contains(card);

              return Positioned(
                left: 16.0 + (index * stride),
                bottom: 0,
                child: GestureDetector(
                  onTap: () => ref
                      .read(gameUIProvider.notifier)
                      .toggleCardSelection(card),
                  child: Transform.translate(
                    offset: Offset(0, isSelected ? -20 : 0),
                    child: PlayingCardWidget(
                      card: card,
                      isSelected: isSelected,
                      width: cardWidth,
                      height: cardHeight,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  void _handlePlayTap(
    BuildContext context,
    WidgetRef ref,
    GameState gameState,
    GameUIState uiState,
    Player player,
  ) {
    if (gameState.pool.isEmpty) {
      RankSelectorBottomSheet.show(
        context,
        onRankSelected: (rank) {
          ref.read(gameUIProvider.notifier).selectRank(rank);
          try {
            ref.read(audioServiceProvider).playCardThrow();
            ref
                .read(gameStateProvider.notifier)
                .throwCards(player.playerId, uiState.selectedCards, rank);
            ref.read(gameUIProvider.notifier).resetSelection();
          } catch (e) {
            _showErrorSnackBar(context, e.toString());
          }
        },
      );
    } else {
      try {
        ref.read(audioServiceProvider).playCardThrow();
        ref
            .read(gameStateProvider.notifier)
            .addCards(
              player.playerId,
              uiState.selectedCards,
              gameState.currentClaimedRank!,
            );
        ref.read(gameUIProvider.notifier).resetSelection();
      } catch (e) {
        _showErrorSnackBar(context, e.toString());
      }
    }
  }

  Future<void> _handleChallengeTap(
    BuildContext context,
    WidgetRef ref,
    GameState gameState,
    GameUIState uiState,
    Player player,
  ) async {
    if (uiState.isResolvingChallenge) return;

    final previousPlayer = gameState.players.firstWhere(
      (p) => p.playerId == gameState.lastPlayerId,
    );
    final challenger = player;
    final revealedCards = List<PlayingCard>.from(gameState.lastPlayedCards);
    final claim = gameState.currentClaimedRank!;

    ref.read(gameUIProvider.notifier).startChallengeResolution(revealedCards);

    ref.read(audioServiceProvider).playSuspense();

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      Navigator.of(context).pop();

      final wasTruth = revealedCards.every((c) => c.rank == claim);

      if (wasTruth) {
        ref.read(audioServiceProvider).playTruthWin();
      } else {
        ref.read(audioServiceProvider).playLieWin();
      }

      await ChallengeResultDialog.show(
        context,
        wasTruth: wasTruth,
        challengerName: challenger.playerName,
        previousPlayerName: previousPlayer.playerName,
        revealedCards: revealedCards,
        claimedRank: claim,
      );

      try {
        ref.read(gameStateProvider.notifier).challenge(challenger.playerId);
        ref.read(gameUIProvider.notifier).endChallengeResolution();
        ref.read(gameUIProvider.notifier).resetSelection();
      } catch (e) {
        ref.read(gameUIProvider.notifier).endChallengeResolution();
        if (!context.mounted) return;
        _showErrorSnackBar(context, e.toString());
      }
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    final cleanMessage = message.startsWith('Bad state: ')
        ? message.substring(11)
        : message;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          cleanMessage,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
