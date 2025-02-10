// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_category_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionCategoryEntity _$TransactionCategoryEntityFromJson(
        Map<String, dynamic> json) =>
    TransactionCategoryEntity(
      userId: json['userId'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$TransactionCategoryEntityToJson(
        TransactionCategoryEntity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'type': instance.type,
    };
