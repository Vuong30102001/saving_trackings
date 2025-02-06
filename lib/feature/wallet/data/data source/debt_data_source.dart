import 'package:isar/isar.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/isar_service.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/models/debt_model.dart';

abstract class DebtDataSource{
  Future<void> addDebt(DebtModel debt);
  Future<List<DebtModel>> getDebts(String userId);
}
class DebtDataSourceImpl implements DebtDataSource{
  final IsarService isarService;

  DebtDataSourceImpl(this.isarService);

  @override
  Future<void> addDebt(DebtModel debt) async {
    final isar = await isarService.db;
    await isar.writeTxn(() async {
      await isar.debtModels.put(debt);
    });
  }

  @override
  Future<List<DebtModel>> getDebts(String userId) async {
    final isar = await isarService.db;
    return await isar.debtModels.filter().userIdEqualTo(userId).findAll();
  }
}