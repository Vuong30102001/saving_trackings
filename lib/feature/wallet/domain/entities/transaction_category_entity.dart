import 'package:json_annotation/json_annotation.dart';

part 'transaction_category_entity.g.dart';

@JsonSerializable()
class TransactionCategoryEntity{
  final String userId;
  final String name;
  final String type;

  TransactionCategoryEntity({
    required this.userId,
    required this.name,
    required this.type
  });

  factory TransactionCategoryEntity.fromJson(Map<String, dynamic> json)
    => _$TransactionCategoryEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionCategoryEntityToJson(this);
}