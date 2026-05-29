import 'package:flutter/material.dart';
import '../../domain/entities/card.dart';
import 'playing_card_widget.dart';

class ChallengeResultDialog extends StatelessWidget {
  final bool wasTruth;
  final String challengerName;
  final String previousPlayerName;
  final List<PlayingCard> revealedCards;
  final Rank claimedRank;

  const ChallengeResultDialog({
    super.key,
    required this.wasTruth,
    required this.challengerName,
    required this.previousPlayerName,
    required this.revealedCards,
    required this.claimedRank,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // If previous player lied (wasTruth == false), challenger succeeds.
    final bool challengerSuccess = !wasTruth;
    
    final Color highlightColor = challengerSuccess ? Colors.green : Colors.red;
    final IconData mainIcon = challengerSuccess ? Icons.check_circle : Icons.warning_rounded;
    final String mainText = challengerSuccess ? 'Correct!' : 'Incorrect!';
    final String descriptionText = challengerSuccess
        ? '$previousPlayerName say true!'
        : '$previousPlayerName tell lie!';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
            maxWidth: 600,
          ),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: highlightColor,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: highlightColor.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 5,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        mainIcon,
                        color: highlightColor,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        mainText,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: highlightColor,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        descriptionText,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '$previousPlayerName actually played:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: revealedCards.map((card) {
                          final isMatch = card.rank == claimedRank;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isMatch ? Colors.green : Colors.red,
                                width: 2,
                              ),
                            ),
                            child: PlayingCardWidget(
                              card: card,
                              width: 50,
                              height: 75,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: highlightColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required bool wasTruth,
    required String challengerName,
    required String previousPlayerName,
    required List<PlayingCard> revealedCards,
    required Rank claimedRank,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ChallengeResultDialog(
        wasTruth: wasTruth,
        challengerName: challengerName,
        previousPlayerName: previousPlayerName,
        revealedCards: revealedCards,
        claimedRank: claimedRank,
      ),
    );
  }
}
