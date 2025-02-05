import 'package:saving_trackings_flutter/feature/wallet/domain/entities/transaction_entity.dart';

abstract class TransactionRepository{
  Future<void> addTransaction(TransactionEntity transaction);
  Future<List<TransactionEntity>> getTransactions(String userId);
}