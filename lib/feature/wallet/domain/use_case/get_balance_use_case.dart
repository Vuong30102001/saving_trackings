import 'package:saving_trackings_flutter/feature/wallet/domain/entities/balance_entity.dart';
import 'package:saving_trackings_flutter/feature/wallet/domain/repository/balance_repository.dart';

class GetBalanceUseCase{
  final BalanceRepository balanceRepository;
  GetBalanceUseCase({required this.balanceRepository});

  Future<BalanceEntity> getBalance(String userId) async {
    return await balanceRepository.getBalance(userId);
  }
}