import 'package:saving_trackings_flutter/feature/wallet/domain/entities/debt_entity.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/entities/transaction_entity.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/repository/balance_repository.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/repository/debt_repository.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/repository/transaction_repository.dart';

class AddTransactionUseCase{
  final TransactionRepository transactionRepository;
  final BalanceRepository balanceRepository;
  final DebtRepository debtRepository;
  AddTransactionUseCase({
    required this.transactionRepository,
    required this.balanceRepository,
    required this.debtRepository
  });

  Future<void> addTransaction(TransactionEntity transaction) async {
    //add transaction
    await transactionRepository.addTransaction(transaction);

    //handle wallet
    if(transaction.type == TransactionType.income){
      final balance = await balanceRepository.getBalance(transaction.userId);
      double newBalance = balance.amount + transaction.amount;
      await balanceRepository.updateBalance(transaction.userId, newBalance);
    }
    else if(transaction.type == TransactionType.expense){
      final balance = await balanceRepository.getBalance(transaction.userId);
      double newBalance = balance.amount - transaction.amount;
      await balanceRepository.updateBalance(transaction.userId, newBalance);
    }

    if(transaction.type == TransactionType.lend || transaction.type == TransactionType.borrow){
      final debt = DebtEntity(
          id: transaction.id,
          userId: transaction.userId,
          type: transaction.type.name,
          amount: transaction.amount,
          dateTime: transaction.dateTime,
          isPaid: false,
      );
      await debtRepository.addDebt(debt);
    }
  }
}