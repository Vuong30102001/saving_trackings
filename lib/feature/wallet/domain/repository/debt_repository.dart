import 'package:saving_trackings_flutter/feature/wallet/domain/entities/debt_entity.dart';

abstract class DebtRepository{
  Future<void> addDebt(DebtEntity debt);
  Future<List<DebtEntity>> getDebts(String userId);
}