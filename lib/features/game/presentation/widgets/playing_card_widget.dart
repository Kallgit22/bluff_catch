import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../domain/entities/card.dart';

class PlayingCardWidget extends StatelessWidget {
  final PlayingCard? card;
  final bool isHidden;
  final bool isSelected;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const PlayingCardWidget({
    super.key,
    this.card,
    this.isHidden = false,
    this.isSelected = false,
    this.onTap,
    this.width = 60,
    this.height = 90,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        transform: Matrix4.translationValues(0, isSelected ? -15 : 0, 0),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isHidden ? theme.colorScheme.primaryContainer : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? theme.colorScheme.primary 
                : Colors.black.withValues(alpha: 0.2),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.3 : 0.1),
              blurRadius: isSelected ? 8 : 4,
              offset: Offset(0, isSelected ? 4 : 2),
            ),
          ],
        ),
        child: isHidden
            ? Center(
                child: Icon(
                  Icons.layers,
                  color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
                  size: 32,
                ),
              )
            : _buildCardFace(),
      ),
    );
  }

  Widget _buildCardFace() {
    if (card == null) return const SizedBox();
    
    final isRed = card!.suit == Suit.hearts || card!.suit == Suit.diamonds;
    final color = isRed ? Colors.red : Colors.black;
    final rankStr = card!.rank.label;
    
    IconData suitIcon;
    switch (card!.suit) {
      case Suit.hearts:
        suitIcon = CupertinoIcons.heart_fill;
        break;
      case Suit.diamonds:
        suitIcon = CupertinoIcons.suit_diamond_fill;
        break;
      case Suit.clubs:
        suitIcon = CupertinoIcons.suit_club_fill;
        break;
      case Suit.spades:
        suitIcon = CupertinoIcons.suit_spade_fill;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                rankStr,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Icon(
            suitIcon,
            color: color,
            size: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RotatedBox(
                quarterTurns: 2,
                child: Text(
                  rankStr,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
