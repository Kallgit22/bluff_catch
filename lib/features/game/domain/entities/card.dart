import 'package:freezed_annotation/freezed_annotation.dart';

part 'card.freezed.dart';
part 'card.g.dart';

enum Suit { hearts, diamonds, clubs, spades }
enum Rank { two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace }

@freezed
abstract class PlayingCard with _$PlayingCard {
  const factory PlayingCard({
    required Suit suit,
    required Rank rank,
  }) = _PlayingCard;

  factory PlayingCard.fromJson(Map<String, dynamic> json) => _$PlayingCardFromJson(json);
}

extension RankExtension on Rank {
  String get label {
    switch (this) {
      case Rank.two: return '2';
      case Rank.three: return '3';
      case Rank.four: return '4';
      case Rank.five: return '5';
      case Rank.six: return '6';
      case Rank.seven: return '7';
      case Rank.eight: return '8';
      case Rank.nine: return '9';
      case Rank.ten: return '10';
      case Rank.jack: return 'J';
      case Rank.queen: return 'Q';
      case Rank.king: return 'K';
      case Rank.ace: return 'A';
    }
  }

  int compareValue(Rank other) {
    return index.compareTo(other.index);
  }
}

extension PlayingCardListExtension on List<PlayingCard> {
  void sortHand() {
    sort((a, b) {
      final rankCompare = a.rank.compareValue(b.rank);
      if (rankCompare != 0) return rankCompare;
      return a.suit.index.compareTo(b.suit.index);
    });
  }
}
