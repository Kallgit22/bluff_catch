import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../domain/room_player.dart';
import '../../domain/room.dart';
import '../providers/room_lobby_provider.dart';

class RoomLobbyPage extends ConsumerStatefulWidget {
  final String roomId;
  
  const RoomLobbyPage({super.key, required this.roomId});

  @override
  ConsumerState<RoomLobbyPage> createState() => _RoomLobbyPageState();
}

class _RoomLobbyPageState extends ConsumerState<RoomLobbyPage> with WidgetsBindingObserver {
  bool _leaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      // Fire and forget leave
      ref.read(roomLobbyControllerProvider.notifier).leaveRoom(widget.roomId);
    }
  }

  Future<void> _handleLeave(bool isHost) async {
    if (_leaving) return;
    
    if (isHost) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Leave Room?', style: TextStyle(color: Colors.white)),
          content: const Text('As the host, leaving will close the room for all players.', style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false), 
              child: const Text('Cancel', style: TextStyle(color: Colors.white54))
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true), 
              child: const Text('Leave', style: TextStyle(color: Colors.redAccent))
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }
    
    setState(() => _leaving = true);
    final error = await ref.read(roomLobbyControllerProvider.notifier).leaveRoom(widget.roomId);
    
    if (mounted) {
      setState(() => _leaving = false);
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      } else {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final themeConfig = AppThemes.getThemeById(settings.themeId);
    final roomStream = ref.watch(roomLobbyStreamProvider(widget.roomId));
    final isLoading = ref.watch(roomLobbyControllerProvider);
    final controller = ref.read(roomLobbyControllerProvider.notifier);
    
    final localUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    
    // Determine host status outside for PopScope
    final currentRoom = roomStream.value;
    final isHost = currentRoom?.hostUid == localUid;

    ref.listen<AsyncValue<Room?>>(roomLobbyStreamProvider(widget.roomId), (previous, next) {
      if (previous?.value != null && next.value == null) {
        if (!_leaving && mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('Room was closed.'))
           );
           context.go('/online-hub');
        }
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleLeave(isHost);
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: isLoading || _leaving ? null : () => _handleLeave(isHost),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ROOM: ',
                style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
              Text(
                widget.roomId,
                style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 4),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white, size: 20),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: widget.roomId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Room code copied to clipboard')),
                  );
                },
              ),
            ],
          ),
          centerTitle: true,
          actions: [
            roomStream.when(
              data: (room) {
                if (room == null) return const SizedBox.shrink();
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Text(
                      '${room.players.length} / ${room.maxPlayers} PLAYERS',
                      style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            if (isHost)
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Room Settings coming soon')),
                  );
                },
              ),
            const SizedBox(width: 16),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: themeConfig.backgroundGradient,
          ),
          child: SafeArea(
            child: roomStream.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.amber)),
              error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
              data: (room) {
                if (room == null) {
                  return const Center(child: Text('Room not found or closed.', style: TextStyle(color: Colors.white54, fontSize: 18)));
                }

                final localPlayer = room.players.firstWhere(
                  (p) => p.uid == localUid, 
                  orElse: () => room.players.first
                );
                final allReady = room.players.every((p) => p.isReady);

                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250,
                            childAspectRatio: 0.75, // Better aspect ratio to prevent overflow
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                          ),
                          itemCount: room.players.length,
                          itemBuilder: (context, index) {
                            final player = room.players[index];
                            return _PlayerLobbyCard(player: player);
                          },
                        ),
                      ),
                    ),
                    
                    // Bottom Action Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        border: const Border(top: BorderSide(color: Colors.white12)),
                      ),
                      child: Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: isLoading || _leaving ? null : () => _handleLeave(isHost),
                            icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
                            label: const Text('LEAVE ROOM', style: TextStyle(color: Colors.redAccent)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.redAccent),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            ),
                          ),
                          const Spacer(),
                          if (isHost) ...[
                            FilledButton.icon(
                              onPressed: (allReady && !isLoading && !_leaving)
                                  ? () async {
                                      final error = await controller.startMatch(widget.roomId);
                                      if (error == null && context.mounted) {
                                        context.go('/game');
                                      } else if (error != null && context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Failed to start match: $error')),
                                        );
                                      }
                                    }
                                  : null,
                              icon: isLoading 
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black54, strokeWidth: 2))
                                : const Icon(Icons.play_arrow, color: Colors.black87),
                              label: const Text('START MATCH', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.amber,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                disabledBackgroundColor: Colors.white24,
                              ),
                            ),
                          ] else ...[
                            FilledButton.icon(
                              onPressed: isLoading || _leaving 
                                ? null 
                                : () async {
                                    final error = await controller.toggleLocalReady(widget.roomId);
                                    if (error != null && context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Failed to update ready state: $error')),
                                      );
                                    }
                                  },
                              icon: isLoading
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black54, strokeWidth: 2))
                                : Icon(localPlayer.isReady ? Icons.close : Icons.check, color: Colors.black87),
                              label: Text(
                                localPlayer.isReady ? 'UNREADY' : 'READY UP', 
                                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, letterSpacing: 1.5)
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: localPlayer.isReady ? Colors.grey : Colors.greenAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                disabledBackgroundColor: Colors.white24,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayerLobbyCard extends StatelessWidget {
  final RoomPlayer player;

  const _PlayerLobbyCard({required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: player.isReady ? Colors.greenAccent.withValues(alpha: 0.5) : Colors.white12,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 32, // Reduced to prevent overflow
                      backgroundColor: Colors.white12,
                      backgroundImage: AssetImage('assets/avatars/${player.avatarUrl}.jpg'),
                      onBackgroundImageError: (_, _) {},
                      child: const Icon(Icons.person, size: 32, color: Colors.white38),
                    ),
                    if (player.isHost)
                      const Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.amber,
                          child: Icon(Icons.star, size: 14, color: Colors.black87),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded( // Using Expanded/Flexible handles text scaling cleanly
                  child: Center(
                    child: Text(
                      player.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Text(
                  '${player.points} PTS',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: player.isReady ? Colors.greenAccent.withValues(alpha: 0.2) : Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FittedBox(
                    child: Text(
                      player.isReady ? 'READY' : 'WAITING',
                      style: TextStyle(
                        color: player.isReady ? Colors.greenAccent : Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (player.isReady)
            const Positioned(
              top: 8,
              right: 8,
              child: Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
            ),
        ],
      ),
    );
  }
}
