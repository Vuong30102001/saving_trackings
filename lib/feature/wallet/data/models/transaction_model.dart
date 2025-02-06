import 'package:isar/isar.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/entities/transaction_entity.dart';

part 'transaction_model.g.dart';

@collection
class TransactionModel{
  Id id = Isar.autoIncrement;
  late String userId;
  @enumerated
  late TransactionType type;
  late double amount;
  late DateTime dateTime;

  TransactionModel();

  TransactionEntity toEntity(){
    return TransactionEntity(
        id: id.toString(),
        userId: userId,
        type: type,
        amount: amount,
        dateTime: dateTime
    );
  }

  static TransactionModel fromEntity(TransactionEntity transaction){
    return TransactionModel()
        ..id = int.parse(transaction.id)
        ..userId = transaction.userId
        ..type = transaction.type
        ..amount = transaction.amount
        ..dateTime = transaction.dateTime;
  }
}