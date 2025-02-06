import 'package:saving_trackings_flutter/feature/wallet/domain/entities/transaction_entity.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/repository/transaction_repository.dart';

class GetTransactionUseCase{
  final TransactionRepository transactionRepository;
  GetTransactionUseCase({required this.transactionRepository});

  Future<List<TransactionEntity>> getTransactions(String userId) async {
    return await transactionRepository.getTransactions(userId);
  }
}