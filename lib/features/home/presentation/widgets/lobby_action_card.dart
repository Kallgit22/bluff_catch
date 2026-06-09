import 'package:flutter/material.dart';

class LobbyActionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;
  final Color baseColor;

  const LobbyActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
    required this.baseColor,
  });

  @override
  State<LobbyActionCard> createState() => _LobbyActionCardState();
}

class _LobbyActionCardState extends State<LobbyActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: widget.isPrimary ? 260 : 200,
            height: widget.isPrimary ? 340 : 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.baseColor.withValues(alpha: 0.8),
                  widget.baseColor.withValues(alpha: 0.4),
                ],
              ),
              border: Border.all(
                color: widget.isPrimary ? Colors.white : Colors.white30,
                width: widget.isPrimary ? 3 : 1,
              ),
              boxShadow: [
                if (widget.isPrimary)
                  BoxShadow(
                    color: widget.baseColor.withValues(alpha: 0.6),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background Icon
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    widget.icon,
                    size: widget.isPrimary ? 180 : 120,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        widget.icon,
                        size: widget.isPrimary ? 48 : 36,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.isPrimary ? 28 : 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          shadows: const [
                            Shadow(color: Colors.black54, blurRadius: 4),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: widget.isPrimary ? 14 : 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
