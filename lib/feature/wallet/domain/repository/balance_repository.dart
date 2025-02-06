import 'package:saving_trackings_flutter/feature/wallet/domain/entities/balance_entity.dart';

abstract class BalanceRepository{
  Future<BalanceEntity> getBalance(String userId);
  Future<void> updateBalance(String userId, double newBalance);
  Future<void> saveBalance(String userId, double amount);
}