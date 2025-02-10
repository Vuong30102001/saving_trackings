import 'package:json_annotation/json_annotation.dart';

part 'transaction_entity.g.dart';

enum TransactionType{
  income,
  expense,
  lend,
  borrow,
}

@JsonSerializable()
class TransactionEntity{
  final String id;
  final String userId;
  @JsonKey(unknownEnumValue: TransactionType.income)
  final TransactionType type;
  final String category;
  final double amount;
  final DateTime dateTime;

  TransactionEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.category,
    required this.amount,
    required this.dateTime
  });

  factory TransactionEntity.fromJson(Map<String, dynamic> json) => _$TransactionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionEntityToJson(this);
}