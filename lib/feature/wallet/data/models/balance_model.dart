import 'package:isar/isar.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/entities/balance_entity.dart';

part 'balance_model.g.dart';

@collection
class BalanceModel{
  Id id = Isar.autoIncrement;
  late String userId;
  late double balance;

  BalanceModel();

  BalanceEntity toEntity(){
    return BalanceEntity(
        id: id,
        userId: userId,
        amount: balance,
    );
  }

  static BalanceModel fromEntity(BalanceEntity balance) {
    return BalanceModel()
      ..id = balance.id
      ..userId = balance.userId
      ..balance = balance.amount;
  }
}