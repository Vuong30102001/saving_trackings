import 'package:isar/isar.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/entities/debt_entity.dart';

part 'debt_model.g.dart';

@collection
class DebtModel{
  Id id = Isar.autoIncrement;
  late String userId;
  late String type;
  late double amount;
  late DateTime dateTime;
  late bool isPaid;

  DebtModel();

  DebtEntity toEntity(){
    return DebtEntity(
        id: id.toString(),
        userId: userId,
        type: type,
        amount: amount,
        dateTime: dateTime,
        isPaid: isPaid
    );
  }

  static DebtModel fromEntity(DebtEntity debt) {
    return DebtModel()
        ..id = int.parse(debt.id)
        ..userId = debt.userId
        ..type = debt.type
        ..amount = debt.amount
        ..dateTime = debt.dateTime
        ..isPaid = debt.isPaid;
  }
}