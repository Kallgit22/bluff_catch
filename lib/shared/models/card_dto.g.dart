// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CardDTO _$CardDTOFromJson(Map<String, dynamic> json) => _CardDTO(
  suit: $enumDecode(_$SuitDTOEnumMap, json['suit']),
  rank: $enumDecode(_$RankDTOEnumMap, json['rank']),
);

Map<String, dynamic> _$CardDTOToJson(_CardDTO instance) => <String, dynamic>{
  'suit': _$SuitDTOEnumMap[instance.suit]!,
  'rank': _$RankDTOEnumMap[instance.rank]!,
};

const _$SuitDTOEnumMap = {
  SuitDTO.hearts: 'hearts',
  SuitDTO.diamonds: 'diamonds',
  SuitDTO.clubs: 'clubs',
  SuitDTO.spades: 'spades',
};

const _$RankDTOEnumMap = {
  RankDTO.two: 'two',
  RankDTO.three: 'three',
  RankDTO.four: 'four',
  RankDTO.five: 'five',
  RankDTO.six: 'six',
  RankDTO.seven: 'seven',
  RankDTO.eight: 'eight',
  RankDTO.nine: 'nine',
  RankDTO.ten: 'ten',
  RankDTO.jack: 'jack',
  RankDTO.queen: 'queen',
  RankDTO.king: 'king',
  RankDTO.ace: 'ace',
};
