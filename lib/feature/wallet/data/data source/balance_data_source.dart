import 'package:isar/isar.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/isar_service.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/models/balance_model.dart';

abstract class BalanceDataSource{
  Future<BalanceModel?> getBalance(String userId);
  Future<void> updateBalance(String userId, double newBalance);
  Future<void> saveBalance(String userId, double amount);
}

class BalanceDataSourceImpl implements BalanceDataSource{
  final IsarService isarService;
  BalanceDataSourceImpl(this.isarService);

  @override
  Future<BalanceModel?> getBalance(String userId) async {
    try {
      final isar = await isarService.db;
      final balance = await isar.balanceModels
          .filter()
          .userIdEqualTo(userId)
          .findFirst();

      if (balance == null) {
        print("Không tìm thấy balance cho userId: $userId");
      } else {
        print("Balance tìm thấy: $balance");
      }

      return balance;
    } catch (e) {
      print("Lỗi khi truy vấn balance: $e");
      return null;
    }
  }

  @override
  Future<void> updateBalance(String userId, double newBalance) async {
    final isar = await isarService.db;
    await isar.writeTxn(() async {
      final balance = await getBalance(userId);
      if(balance != null){
        balance.balance = newBalance;
        await isar.balanceModels.put(balance);
      }
      else
        {
          await isar.balanceModels.put(BalanceModel()
            ..userId = userId
            ..balance = newBalance
          );
        }
    });
  }

  @override
  Future<void> saveBalance(String userId, double amount) async {
    final isar = await isarService.db;
    final balance = BalanceModel()
      ..id = int.parse(DateTime.now().millisecond.toString())
      ..userId = userId
      ..balance = amount;
    await isar.writeTxn(() async {
      await isar.balanceModels.put(balance);
    });
  }
}