import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/card.dart';
import '../../domain/entities/game_state.dart';
import '../providers/test_harness_provider.dart';

/// Debug-only test page for verifying the multiplayer pipeline.
///
/// Three sections:
///   1. Connection Panel — match ID, player selector, lifecycle buttons
///   2. Game State Inspector — live GameState display + action buttons
///   3. Debug Log Console — timestamped action/event log
class TestHarnessPage extends ConsumerWidget {
  const TestHarnessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('🧪 Multiplayer Test Harness'),
        backgroundColor: const Color(0xFF16213E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear logs',
            onPressed: () => ref.read(testHarnessProvider.notifier).clearLogs(),
          ),
        ],
      ),
      body: const Row(
        children: [
          // Left: Connection + Actions
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _ConnectionPanel(),
                Divider(color: Colors.white24, height: 1),
                Expanded(child: _GameStateInspector()),
              ],
            ),
          ),
          VerticalDivider(color: Colors.white24, width: 1),
          // Right: Log console
          Expanded(
            flex: 2,
            child: _DebugLogConsole(),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CONNECTION PANEL
// =============================================================================

class _ConnectionPanel extends ConsumerStatefulWidget {
  const _ConnectionPanel();

  @override
  ConsumerState<_ConnectionPanel> createState() => _ConnectionPanelState();
}

class _ConnectionPanelState extends ConsumerState<_ConnectionPanel> {
  late TextEditingController _matchIdController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(testHarnessProvider);
    _matchIdController = TextEditingController(text: state.matchId);
  }

  @override
  void dispose() {
    _matchIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(testHarnessProvider);
    final notifier = ref.read(testHarnessProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(12),
      color: const Color(0xFF16213E),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Match ID row
          Row(
            children: [
              _statusDot(state.connectionStatus),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _matchIdController,
                  onChanged: notifier.setMatchId,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
                  decoration: InputDecoration(
                    labelText: 'Match ID',
                    labelStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.copy, size: 16, color: Colors.grey),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _matchIdController.text));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Match ID copied'), duration: Duration(seconds: 1)),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Player selector
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'p_0', label: Text('P0', style: TextStyle(fontSize: 11))),
                  ButtonSegment(value: 'p_1', label: Text('P1', style: TextStyle(fontSize: 11))),
                ],
                selected: {state.playerId},
                onSelectionChanged: (s) => notifier.setPlayerId(s.first),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) return const Color(0xFF0F3460);
                    return Colors.transparent;
                  }),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Action buttons row
          Row(
            children: [
              _actionButton('Create', Icons.add, Colors.blue, () => notifier.createMatch()),
              const SizedBox(width: 6),
              _actionButton('Start', Icons.play_arrow, Colors.green, () => notifier.startMatch()),
              const SizedBox(width: 6),
              _actionButton(
                state.connectionStatus == ConnectionStatus.connected ? 'Connected' : 'Connect',
                Icons.wifi,
                state.connectionStatus == ConnectionStatus.connected ? Colors.green : Colors.orange,
                () => notifier.connectToMatch(),
              ),
              const SizedBox(width: 6),
              _actionButton('Disconnect', Icons.wifi_off, Colors.red, () => notifier.disconnect()),
              const SizedBox(width: 6),
              _actionButton('Reconnect', Icons.refresh, Colors.purple, () => notifier.testReconnect()),
            ],
          ),
          if (state.lastError != null) ...[
            const SizedBox(height: 4),
            Text(
              '⚠ ${state.lastError}',
              style: const TextStyle(color: Colors.redAccent, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusDot(ConnectionStatus status) {
    Color color;
    switch (status) {
      case ConnectionStatus.connected:
        color = Colors.greenAccent;
        break;
      case ConnectionStatus.connecting:
        color = Colors.yellowAccent;
        break;
      case ConnectionStatus.error:
        color = Colors.redAccent;
        break;
      case ConnectionStatus.disconnected:
        color = Colors.grey;
        break;
    }
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _actionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: SizedBox(
        height: 32,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: 14),
          label: Text(label, style: const TextStyle(fontSize: 10)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color.withValues(alpha: 0.2),
            foregroundColor: color,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// GAME STATE INSPECTOR
// =============================================================================

class _GameStateInspector extends ConsumerWidget {
  const _GameStateInspector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(testHarnessProvider);
    final notifier = ref.read(testHarnessProvider.notifier);
    final gs = state.gameState;

    if (gs == null) {
      return const Center(
        child: Text(
          'No game state.\nCreate → Start → Connect to begin.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      );
    }

    final isMyTurn = gs.status == GameStatus.playing &&
        gs.activePlayerIndex >= 0 &&
        gs.activePlayerIndex < gs.players.length &&
        gs.players[gs.activePlayerIndex].playerId == state.playerId;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status bar
          _sectionHeader('Match Status'),
          _infoRow('Status', gs.status.name, _statusColor(gs.status)),
          _infoRow('Active Player', 'p_${gs.activePlayerIndex}',
              isMyTurn ? Colors.greenAccent : Colors.white70),
          _infoRow('Pool', '${gs.pool.length} cards', Colors.white70),
          _infoRow('Discard', '${gs.discardPile.length} cards', Colors.white70),
          _infoRow('Pass Count', '${gs.passCount}', Colors.white70),
          _infoRow('Claimed Rank', gs.currentClaimedRank?.name ?? 'none', Colors.white70),
          _infoRow('Last Event', gs.lastEvent.name, _eventColor(gs.lastEvent)),

          const SizedBox(height: 12),
          _sectionHeader('Players'),
          ...gs.players.map((p) => _playerRow(p, state.playerId, gs.activePlayerIndex)),

          const SizedBox(height: 12),
          _sectionHeader('My Hand (${state.playerId})'),
          _myHand(gs, state.playerId),

          const SizedBox(height: 12),
          _sectionHeader('Actions'),
          if (isMyTurn)
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text('🟢 YOUR TURN', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 12)),
            )
          else
            const Padding(
              padding: EdgeInsets.only(bottom: 6),
              child: Text('⏳ Waiting for opponent...', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _gameActionChip('Throw (truth)', Colors.blue, () => notifier.throwFirstCards()),
              _gameActionChip('Throw (bluff)', Colors.orange, () => notifier.throwBluff()),
              _gameActionChip('Pass', Colors.amber, () => notifier.passTurn()),
              _gameActionChip('Challenge', Colors.red, () => notifier.challenge()),
              _gameActionChip('Leave', Colors.grey, () => notifier.leaveMatch()),
            ],
          ),

          const SizedBox(height: 16),
          _sectionHeader('Verification Checklist'),
          _checklistItem(1, 'Match created', gs.status != GameStatus.waiting || gs.players.isNotEmpty, gs),
          _checklistItem(2, 'Match started', gs.status == GameStatus.playing || gs.status == GameStatus.finished, gs),
          _checklistItem(3, 'Cards thrown', gs.lastEvent == AnimationEvent.cardsThrown || gs.pool.isNotEmpty || gs.discardPile.isNotEmpty, gs),
          _checklistItem(4, 'Turn passed', gs.passCount > 0 || gs.lastEvent == AnimationEvent.roundPassed, gs),
          _checklistItem(5, 'Challenge (lie)', gs.lastEvent == AnimationEvent.challengeLie, gs),
          _checklistItem(6, 'Challenge (truth)', gs.lastEvent == AnimationEvent.challengeTruth, gs),
          _checklistItem(7, 'Pool reset', gs.lastEvent == AnimationEvent.roundPassed, gs),
          _checklistItem(8, 'Ranking', gs.players.any((p) => p.hasPendingVictory || p.rankPosition != null), gs),
          _checklistItem(9, 'Reconnect', false, gs), // manual
          _checklistItem(10, 'Leave match', gs.players.any((p) => p.isEliminated), gs),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          )),
    );
  }

  Widget _infoRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
          ),
          Text(value, style: TextStyle(color: valueColor, fontSize: 11, fontFamily: 'monospace')),
        ],
      ),
    );
  }

  Widget _playerRow(dynamic player, String localPlayerId, int activeIndex) {
    final isMe = player.playerId == localPlayerId;
    final isActive = player.playerId == 'p_$activeIndex';
    final statusIcons = [
      if (isMe) '👤',
      if (isActive) '▶',
      if (player.isEliminated) '💀',
      if (player.hasPendingVictory) '🏆',
      if (player.hasPassed) '⏭',
    ].join(' ');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(4),
        border: isActive ? Border.all(color: Colors.greenAccent.withValues(alpha: 0.5)) : null,
      ),
      child: Row(
        children: [
          Text(
            '${player.playerId}',
            style: TextStyle(
              color: isMe ? Colors.lightBlueAccent : Colors.white70,
              fontSize: 11,
              fontFamily: 'monospace',
              fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 8),
          Text(player.playerName,
              style: const TextStyle(color: Colors.white, fontSize: 11)),
          const Spacer(),
          Text('${player.handCards.length} cards',
              style: const TextStyle(color: Colors.white54, fontSize: 11)),
          const SizedBox(width: 8),
          if (player.rankPosition != null)
            Text('#${player.rankPosition}',
                style: const TextStyle(color: Colors.amberAccent, fontSize: 11)),
          const SizedBox(width: 4),
          Text(statusIcons, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _myHand(GameState gs, String playerId) {
    final playerIndex = gs.players.indexWhere((p) => p.playerId == playerId);
    if (playerIndex == -1) {
      return const Text('Player not found', style: TextStyle(color: Colors.grey, fontSize: 11));
    }
    final hand = gs.players[playerIndex].handCards;
    if (hand.isEmpty) {
      return const Text('Empty hand', style: TextStyle(color: Colors.grey, fontSize: 11));
    }
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: hand.map((card) {
        final suitSymbol = switch (card.suit) {
          Suit.hearts => '♥',
          Suit.diamonds => '♦',
          Suit.clubs => '♣',
          Suit.spades => '♠',
        };
        final color = (card.suit == Suit.hearts || card.suit == Suit.diamonds)
            ? Colors.redAccent
            : Colors.white;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${card.rank.name[0].toUpperCase()}$suitSymbol',
            style: TextStyle(color: color, fontSize: 11, fontFamily: 'monospace'),
          ),
        );
      }).toList(),
    );
  }

  Widget _gameActionChip(String label, Color color, VoidCallback onTap) {
    return ActionChip(
      label: Text(label, style: TextStyle(color: color, fontSize: 11)),
      backgroundColor: color.withValues(alpha: 0.15),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _checklistItem(int number, String label, bool passed, GameState gs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Text(
            passed ? '✅' : '⬜',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 6),
          Text(
            '$number. $label',
            style: TextStyle(
              color: passed ? Colors.greenAccent : Colors.white54,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(GameStatus status) {
    switch (status) {
      case GameStatus.waiting:
        return Colors.yellowAccent;
      case GameStatus.playing:
        return Colors.greenAccent;
      case GameStatus.finished:
        return Colors.redAccent;
    }
  }

  Color _eventColor(AnimationEvent event) {
    switch (event) {
      case AnimationEvent.none:
        return Colors.grey;
      case AnimationEvent.cardsThrown:
        return Colors.lightBlueAccent;
      case AnimationEvent.challengeTruth:
        return Colors.orangeAccent;
      case AnimationEvent.challengeLie:
        return Colors.greenAccent;
      case AnimationEvent.roundPassed:
        return Colors.amberAccent;
      case AnimationEvent.gameOver:
        return Colors.redAccent;
    }
  }
}

// =============================================================================
// DEBUG LOG CONSOLE
// =============================================================================

class _DebugLogConsole extends ConsumerWidget {
  const _DebugLogConsole();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(testHarnessProvider);
    final logs = state.logs;

    return Container(
      color: const Color(0xFF0D1117),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xFF161B22),
            child: Row(
              children: [
                const Icon(Icons.terminal, color: Colors.grey, size: 14),
                const SizedBox(width: 6),
                const Text('Debug Console',
                    style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('${logs.length} entries',
                    style: TextStyle(color: Colors.grey[600], fontSize: 10)),
              ],
            ),
          ),
          Expanded(
            child: logs.isEmpty
                ? const Center(
                    child: Text('No logs yet.',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  )
                : ListView.builder(
                    reverse: true,
                    itemCount: logs.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final entry = logs[logs.length - 1 - index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Text(
                          entry.formatted,
                          style: TextStyle(
                            color: _logColor(entry.direction),
                            fontSize: 10,
                            fontFamily: 'monospace',
                            height: 1.4,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _logColor(String direction) {
    switch (direction) {
      case '→':
        return const Color(0xFF58A6FF); // blue — sent
      case '←':
        return const Color(0xFF3FB950); // green — received
      case '⚠':
        return const Color(0xFFD29922); // yellow — warning
      case '✓':
        return const Color(0xFF56D364); // bright green — success
      case '🔄':
        return const Color(0xFFBC8CFF); // purple — reconnect
      default:
        return Colors.grey;
    }
  }
}
