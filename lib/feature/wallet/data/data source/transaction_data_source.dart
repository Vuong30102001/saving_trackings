import 'package:isar/isar.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/data%20source/balance_data_source.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/isar_service.dart';
import 'package:saving_trackings_flutter/feature/wallet/data/models/transaction_model.dart';

abstract class TransactionDataSource{
  Future<void> addTransaction(TransactionModel transactionModel);
  Future<List<TransactionModel>> getTransactions(String userId);
}

class TransactionDataSourceImpl implements TransactionDataSource{
  final IsarService isarService;
  final BalanceDataSource balanceDataSource;

  TransactionDataSourceImpl(this.isarService, this.balanceDataSource);

  @override
  Future<void> addTransaction(TransactionModel transactionModel) async {
    final isar = await isarService.db;
    await isar.writeTxn(() async {
      await isar.transactionModels.put(transactionModel);
    });
    await balanceDataSource.saveBalance(transactionModel.userId, transactionModel.amount);
  }

  @override
  Future<List<TransactionModel>> getTransactions(String userId) async {
    final isar = await isarService.db;
    return await isar.transactionModels.filter().userIdEqualTo(userId).findAll();
  }
}