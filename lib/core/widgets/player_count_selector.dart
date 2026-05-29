import 'package:flutter/material.dart';

class PlayerCountSelector extends StatelessWidget {
  final int count;
  final int min;
  final int max;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const PlayerCountSelector({
    super.key,
    required this.count,
    this.min = 2,
    this.max = 10,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            'Number of Players',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                icon: Icons.remove,
                onPressed: count > min ? onDecrement : null,
                theme: theme,
              ),
              const SizedBox(width: 32),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Text(
                  '$count',
                  key: ValueKey<int>(count),
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 32),
              _buildButton(
                icon: Icons.add,
                onPressed: count < max ? onIncrement : null,
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required ThemeData theme,
  }) {
    return Material(
      color: onPressed == null 
          ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5) 
          : theme.colorScheme.primaryContainer,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Icon(
            icon,
            size: 28,
            color: onPressed == null 
                ? theme.colorScheme.onSurface.withValues(alpha: 0.3)
                : theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
