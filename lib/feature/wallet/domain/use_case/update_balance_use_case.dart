import 'package:saving_trackings_flutter/feature/wallet/domain/repository/balance_repository.dart';

class UpdateBalanceUseCase{
  final BalanceRepository balanceRepository;
  UpdateBalanceUseCase({required this.balanceRepository});

  Future<void> updateBalance(String userId, double amount, bool isIncome) async {
    final balance = await balanceRepository.getBalance(userId);
    final newBalance = isIncome ? balance.amount + amount : balance.amount - amount;
    await balanceRepository.updateBalance(userId, newBalance);
  }
}