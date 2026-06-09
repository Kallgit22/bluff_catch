import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_themes.dart';
import '../../../../core/providers/settings_provider.dart';
import '../providers/online_hub_provider.dart';

class OnlineHubPage extends ConsumerWidget {
  const OnlineHubPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final currentThemeConfig = AppThemes.getThemeById(settings.themeId);
    final hubState = ref.watch(onlineHubProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            ref.read(onlineHubProvider.notifier).reset();
            context.pop();
          },
        ),
        title: const Text(
          'ONLINE HUB',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: currentThemeConfig.backgroundGradient,
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Left Panel - Navigation Options
              Expanded(
                flex: 4,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 20, 20, 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _HubMenuButton(
                                title: 'CREATE ROOM',
                                icon: Icons.add_circle_outline,
                                isSelected: hubState == OnlineHubState.creating || hubState == OnlineHubState.created,
                                onTap: () => ref.read(onlineHubProvider.notifier).selectCreateRoom(),
                              ),
                              const SizedBox(height: 16),
                              _HubMenuButton(
                                title: 'JOIN ROOM',
                                icon: Icons.login,
                                isSelected: hubState == OnlineHubState.joining,
                                onTap: () => ref.read(onlineHubProvider.notifier).selectJoinRoom(),
                              ),
                              const SizedBox(height: 16),
                              _HubMenuButton(
                                title: 'PRIVATE MATCH',
                                icon: Icons.security,
                                isSelected: false,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Private Match logic is same as Create Room for now')),
                                  );
                                  ref.read(onlineHubProvider.notifier).selectCreateRoom();
                                },
                              ),
                              const SizedBox(height: 16),
                              _HubMenuButton(
                                title: 'QUICK MATCH',
                                icon: Icons.flash_on,
                                isSelected: hubState == OnlineHubState.quickMatch,
                                onTap: () {
                                  ref.read(onlineHubProvider.notifier).selectQuickMatch();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Divider
              Container(
                width: 1,
                color: Colors.white.withValues(alpha: 0.1),
                margin: const EdgeInsets.symmetric(vertical: 40),
              ),

              // Right Panel - Interactive State
              Expanded(
                flex: 5,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 40, 20),
                          child: _buildRightPanel(context, ref, hubState),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightPanel(BuildContext context, WidgetRef ref, OnlineHubState state) {
    switch (state) {
      case OnlineHubState.none:
        return const Center(
          child: Text(
            'SELECT A MULTIPLAYER MODE',
            style: TextStyle(color: Colors.white38, fontSize: 18, letterSpacing: 2),
          ),
        );
      case OnlineHubState.creating:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.amber),
              SizedBox(height: 24),
              Text(
                'GENERATING SECURE ROOM...',
                style: TextStyle(color: Colors.white70, letterSpacing: 2),
              ),
            ],
          ),
        );
      case OnlineHubState.created:
        final code = ref.read(onlineHubProvider.notifier).generatedRoomCode ?? 'ERROR';
        return _RoomCodeDisplay(code: code);
      case OnlineHubState.joining:
        return const _JoinRoomForm();
      case OnlineHubState.quickMatch:
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hourglass_empty, size: 64, color: Colors.white38),
              SizedBox(height: 24),
              Text(
                'MATCHMAKING COMING SOON',
                style: TextStyle(color: Colors.white70, fontSize: 18, letterSpacing: 2),
              ),
            ],
          ),
        );
    }
  }
}

class _HubMenuButton extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _HubMenuButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_HubMenuButton> createState() => _HubMenuButtonState();
}

class _HubMenuButtonState extends State<_HubMenuButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = Colors.amber.shade400;
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          decoration: BoxDecoration(
            color: widget.isSelected 
                ? activeColor.withValues(alpha: 0.15) 
                : (_isHovered ? Colors.white.withValues(alpha: 0.05) : Colors.transparent),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected 
                  ? activeColor.withValues(alpha: 0.5) 
                  : (_isHovered ? Colors.white24 : Colors.transparent),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: widget.isSelected ? activeColor : Colors.white54,
                size: 28,
              ),
              const SizedBox(width: 20),
              Text(
                widget.title,
                style: TextStyle(
                  color: widget.isSelected ? Colors.white : Colors.white70,
                  fontSize: 18,
                  fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              if (widget.isSelected)
                Icon(Icons.chevron_right, color: activeColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomCodeDisplay extends StatelessWidget {
  final String code;

  const _RoomCodeDisplay({required this.code});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 64),
        const SizedBox(height: 24),
        const Text(
          'ROOM CREATED SUCCESSFULLY',
          style: TextStyle(color: Colors.greenAccent, fontSize: 16, letterSpacing: 2, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        const Text(
          'YOUR ROOM CODE',
          style: TextStyle(color: Colors.white54, fontSize: 14, letterSpacing: 2),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
          ),
          child: Text(
            code,
            style: const TextStyle(
              color: Colors.amber,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Room code copied to clipboard')),
                );
              },
              icon: const Icon(Icons.copy, color: Colors.white),
              label: const Text('COPY', style: TextStyle(color: Colors.white)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white38),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
            const SizedBox(width: 16),
            FilledButton.icon(
              onPressed: () {
                // Mock Share logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share dialog would open here')),
                );
              },
              icon: const Icon(Icons.share, color: Colors.black87),
              label: const Text('SHARE', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: 300,
          child: FilledButton.icon(
            onPressed: () => context.push('/room-lobby', extra: code),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('GO TO LOBBY', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
          ),
        ),
      ],
    );
  }
}

class _JoinRoomForm extends ConsumerStatefulWidget {
  const _JoinRoomForm();

  @override
  ConsumerState<_JoinRoomForm> createState() => _JoinRoomFormState();
}

class _JoinRoomFormState extends ConsumerState<_JoinRoomForm> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = ref.watch(onlineHubProvider.notifier).joinRoomError;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.meeting_room, color: Colors.white54, size: 64),
        const SizedBox(height: 24),
        const Text(
          'ENTER ROOM CODE',
          style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: 300,
          child: TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.amber, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 8),
            maxLength: 6,
            textCapitalization: TextCapitalization.characters,
            enabled: !_isLoading,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.3),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.amber.shade400, width: 2),
              ),
              errorText: error,
            ),
            onChanged: (val) {
              if (val.length == 6) {
                // Auto trigger when 6 chars
              }
            },
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: 300,
          child: FilledButton(
            onPressed: _isLoading ? null : () async {
              setState(() { _isLoading = true; });
              final success = await ref.read(onlineHubProvider.notifier).attemptJoinRoom(_controller.text);
              if (success && context.mounted) {
                 context.push('/room-lobby', extra: _controller.text.toUpperCase());
              } else if (context.mounted) {
                 setState(() { _isLoading = false; });
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.amber.shade400,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              disabledBackgroundColor: Colors.amber.withValues(alpha: 0.3),
            ),
            child: _isLoading 
              ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.black54, strokeWidth: 3))
              : const Text(
                  'JOIN MATCH',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
