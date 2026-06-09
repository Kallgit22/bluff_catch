import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_dto.freezed.dart';
part 'card_dto.g.dart';

enum SuitDTO {
  @JsonValue('hearts') hearts,
  @JsonValue('diamonds') diamonds,
  @JsonValue('clubs') clubs,
  @JsonValue('spades') spades,
}

enum RankDTO {
  @JsonValue('two') two,
  @JsonValue('three') three,
  @JsonValue('four') four,
  @JsonValue('five') five,
  @JsonValue('six') six,
  @JsonValue('seven') seven,
  @JsonValue('eight') eight,
  @JsonValue('nine') nine,
  @JsonValue('ten') ten,
  @JsonValue('jack') jack,
  @JsonValue('queen') queen,
  @JsonValue('king') king,
  @JsonValue('ace') ace,
}

@freezed
abstract class CardDTO with _$CardDTO {
  const factory CardDTO({
    required SuitDTO suit,
    required RankDTO rank,
  }) = _CardDTO;

  factory CardDTO.fromJson(Map<String, dynamic> json) => _$CardDTOFromJson(json);
}
